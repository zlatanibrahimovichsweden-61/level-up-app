import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/profile/profile_error_copy.dart';
import 'package:level_up_app/features/quiz/widgets/quiz_error_copy.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// `403 account_pending_deletion` (adr-114) as a CROSS-CUTTING code.
///
/// The contract's rule is default-deny: every authenticated `/api/v1` endpoint
/// answers it except four (`openapi.yaml:62-71`), and an endpoint added later
/// is blocked unless it is added to that list. So the thing worth testing is
/// not "endpoint X handles it" — it is that one predicate defines it and every
/// error-copy funnel in the app consults that predicate.
///
/// Sixteen stable operations can return it; only seven DECLARE it. The contract
/// says so about two of them itself: "DECLARED from 3.5.1-m1, but REACHABLE
/// since 3.3.0-m1 — this operation simply failed to declare it." The census is
/// per OPERATION, not per text match — see [isAccountPendingDeletion].
void main() {
  late AppLocalizations en;
  late AppLocalizations ar;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
    ar = await AppLocalizations.delegate.load(const Locale('ar'));
  });

  const pendingDeletion = ApiException(
    status: 403,
    code: 'account_pending_deletion',
  );

  group('isAccountPendingDeletion', () {
    test('recognises the code', () {
      expect(isAccountPendingDeletion(pendingDeletion), isTrue);
    });

    test('does not confuse it with the OTHER 403 the same routes answer', () {
      // `insufficient_scope` is route-dependent and, on the Mistakes overview,
      // legitimately retryable. Collapsing the two is the mistake #61 exists
      // about.
      expect(
        isAccountPendingDeletion(
          const ApiException(status: 403, code: 'insufficient_scope'),
        ),
        isFalse,
      );
    });

    test('ignores transport failures and non-API errors', () {
      expect(isAccountPendingDeletion(const OfflineException()), isFalse);
      expect(isAccountPendingDeletion(const NetworkException()), isFalse);
      expect(isAccountPendingDeletion(null), isFalse);
      expect(isAccountPendingDeletion(Exception('boom')), isFalse);
    });

    test('matches on the code, so a subclass is recognised too', () {
      // Deliberately not `is AccountPendingDeletionException`: the interceptor
      // builds a plain ApiException today and the existing tests construct one
      // directly. A subclass added later must not silently stop matching.
      expect(
        isAccountPendingDeletion(
          const UnauthorizedException(code: 'account_pending_deletion'),
        ),
        isTrue,
      );
    });
  });

  group('every error-copy funnel consults it', () {
    test('quiz — all four quiz endpoints share one helper', () {
      // None of `createQuiz`, `submitAnswer`, `finishQuiz` or `getExplanation`
      // DECLARES this code; all four can return it, because none is on the
      // allowlist.
      expect(quizErrorMessage(en, pendingDeletion), en.accountPendingDeletion);
      expect(quizErrorMessage(ar, pendingDeletion), ar.accountPendingDeletion);
      expect(quizErrorMessage(en, pendingDeletion), isNot(en.genericError));
    });

    test('quiz — the existing codes are untouched', () {
      expect(
        quizErrorMessage(
          en,
          const ApiException(status: 403, code: 'subscription_required'),
        ),
        en.errorSubscriptionRequired,
      );
      expect(
        quizErrorMessage(
          en,
          const ApiException(status: 422, code: 'not_enough_questions'),
        ),
        en.errorNotEnoughQuestions,
      );
      expect(quizErrorMessage(en, const OfflineException()), en.offline);
    });

    test('profile — PATCH /me is NOT on the allowlist, only GET /me is', () {
      expect(
        profileSaveErrorMessage(en, pendingDeletion),
        en.accountPendingDeletion,
      );
      expect(
        profileSaveErrorMessage(ar, pendingDeletion),
        ar.accountPendingDeletion,
      );
    });

    test('profile — offline still outranks it, and validation still works', () {
      expect(profileSaveErrorMessage(en, const OfflineException()), en.offline);
      expect(
        profileSaveErrorMessage(en, const ValidationException(errors: {})),
        en.errorValidationFailed,
      );
    });
  });

  group('suppressesRetry', () {
    test('withholds Retry for a pending deletion', () {
      // "do not log the user out and do not retry" — `openapi.yaml:82-83`.
      expect(suppressesRetry(pendingDeletion), isTrue);
    });

    // API→UI Wave 12. The server closed the quiz (finished, or auto-finished
    // after 24 h): the identical answer can only 409 again.
    test('withholds Retry for quiz_already_finished too', () {
      expect(
        suppressesRetry(
          const ApiException(status: 409, code: 'quiz_already_finished'),
        ),
        isTrue,
      );
    });

    test('leaves every other failure retryable', () {
      // Narrowness is the point. A helper that suppressed Retry broadly would
      // strand students on failures that DO recover.
      expect(suppressesRetry(const OfflineException()), isFalse);
      expect(suppressesRetry(const NetworkException()), isFalse);
      expect(
        suppressesRetry(const ApiException(status: 500, code: 'server_error')),
        isFalse,
      );
      expect(
        suppressesRetry(
          const ApiException(status: 422, code: 'not_enough_questions'),
        ),
        isFalse,
      );
      expect(suppressesRetry(null), isFalse);
    });

    test('is not the same question as opensLimitSheet', () {
      // One routes a failure to a different surface; the other removes a button
      // from the surface already showing. They must not be conflated.
      expect(opensLimitSheet(pendingDeletion), isFalse);
      expect(
        suppressesRetry(
          const ApiException(
            status: 403,
            code: 'weekly_question_limit_reached',
          ),
        ),
        isFalse,
      );
    });
  });

  group('the copy itself', () {
    test('exists in both locales and is not the generic message', () {
      expect(en.accountPendingDeletion, isNotEmpty);
      expect(ar.accountPendingDeletion, isNotEmpty);
      expect(en.accountPendingDeletion, isNot(ar.accountPendingDeletion));
      expect(en.accountPendingDeletion, isNot(en.genericError));
    });

    test('is purchase-silent (adr-049 §3)', () {
      // This code is adjacent to the subscription surfaces, and the app must
      // never mention price, payment or a place to buy.
      for (final copy in [
        en.accountPendingDeletion,
        ar.accountPendingDeletion,
      ]) {
        for (final banned in [
          'subscribe',
          'Subscribe',
          'upgrade',
          'Upgrade',
          'EGP',
          'اشترك',
          'ترقية',
        ]) {
          expect(copy.contains(banned), isFalse, reason: 'found "$banned"');
        }
      }
    });
  });
}
