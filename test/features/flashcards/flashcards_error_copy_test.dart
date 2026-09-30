import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/flashcards/widgets/flashcards_error_copy.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The flashcards funnel from error to sentence + Retry (API→UI Wave 22).
///
/// `getFlashcardsForLecture` answers `403` with three different codes and the
/// wire gives the client no other way to tell why, so the mapping is by CODE
/// alone and each branch is pinned: the sentence, and whether a Retry is
/// offered. Server `title`/`detail` are never rendered.
void main() {
  late AppLocalizations en;
  late AppLocalizations ar;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
    ar = await AppLocalizations.delegate.load(const Locale('ar'));
  });

  const previewUsedUp = ApiException(
    status: 403,
    code: 'flashcard_subscription_required',
  );
  const insufficientScope = ApiException(
    status: 403,
    code: 'insufficient_scope',
  );
  const pendingDeletion = ApiException(
    status: 403,
    code: 'account_pending_deletion',
  );

  group('flashcard_subscription_required', () {
    test('is the preview-used-up line, with no Retry', () {
      final copy = flashcardsErrorCopy(en, previewUsedUp);

      expect(copy.message, en.flashcardPreviewUsedUp);
      expect(copy.message, "You've used this week's free flashcards.");
      // A retry would 403 again: the weekly preview is spent.
      expect(copy.canRetry, isFalse);
    });

    test('is not the quiz paywall copy, and is not a generic failure', () {
      final copy = flashcardsErrorCopy(en, previewUsedUp);

      expect(copy.message, isNot(en.errorSubscriptionRequired));
      expect(copy.message, isNot(en.errorWeeklyQuestionLimitReached));
      expect(copy.message, isNot(en.genericError));
    });

    test('says nothing about buying (the app is purchase-silent)', () {
      // adr-049 §3. The line is a fact about this week, not a call to action.
      final message = flashcardsErrorCopy(en, previewUsedUp).message;

      expect(message.toLowerCase(), isNot(contains('subscri')));
      expect(message.toLowerCase(), isNot(contains('upgrade')));
      expect(message.toLowerCase(), isNot(contains('price')));
    });

    test('the quiz codes are NOT flashcard codes', () {
      // `weekly_question_limit_reached` stays quiz-only (openapi.yaml:1891),
      // and the quiz's `subscription_required` is a different code. Neither
      // may borrow the flashcard sentence.
      for (final code in [
        'weekly_question_limit_reached',
        'subscription_required',
      ]) {
        final copy = flashcardsErrorCopy(
          en,
          ApiException(status: 403, code: code),
        );
        expect(copy.message, en.genericError, reason: code);
      }
    });

    test('in Arabic', () {
      final copy = flashcardsErrorCopy(ar, previewUsedUp);

      expect(copy.message, ar.flashcardPreviewUsedUp);
      expect(copy.message, isNot(en.flashcardPreviewUsedUp));
      expect(copy.canRetry, isFalse);
    });
  });

  group('insufficient_scope', () {
    test('is the shared scope line, with no Retry', () {
      final copy = flashcardsErrorCopy(en, insufficientScope);

      expect(copy.message, en.errorInsufficientScope);
      expect(copy.canRetry, isFalse);
    });

    test('does not depend on which of the four causes it was', () {
      // School track, another cohort, an unreleased term, an unknown UUID: the
      // body is byte-identical and "do not try to tell them apart". Whatever
      // detail the server attaches, the sentence is the same.
      final plain = flashcardsErrorCopy(en, insufficientScope);
      final withDetail = flashcardsErrorCopy(
        en,
        const ApiException(
          status: 403,
          code: 'insufficient_scope',
          detail: 'lecture belongs to another cohort',
        ),
      );

      expect(withDetail, plain);
      expect(withDetail.message, isNot(contains('cohort')));
    });
  });

  group('account_pending_deletion', () {
    test('is the pending-deletion line, with no Retry', () {
      final copy = flashcardsErrorCopy(en, pendingDeletion);

      expect(copy.message, en.accountPendingDeletion);
      // "Do not log the user out and do not retry" (openapi.yaml:82-83).
      expect(copy.canRetry, isFalse);
    });

    test('is recognised through a subclass, as everywhere else', () {
      final copy = flashcardsErrorCopy(
        en,
        const UnauthorizedException(code: 'account_pending_deletion'),
      );

      expect(copy.message, en.accountPendingDeletion);
      expect(copy.canRetry, isFalse);
    });
  });

  group('offline', () {
    test('OfflineException is the offline line, with Retry', () {
      final copy = flashcardsErrorCopy(en, const OfflineException());

      expect(copy.message, en.offline);
      expect(copy.canRetry, isTrue);
    });

    test('a transport failure is the same', () {
      final copy = flashcardsErrorCopy(en, const NetworkException());

      expect(copy.message, en.offline);
      expect(copy.canRetry, isTrue);
    });

    test('in Arabic', () {
      final copy = flashcardsErrorCopy(ar, const OfflineException());

      expect(copy.message, ar.offline);
      expect(copy.message, isNot(en.offline));
      expect(copy.canRetry, isTrue);
    });
  });

  group('anything else', () {
    test('an unknown API code is the generic line, with Retry', () {
      final copy = flashcardsErrorCopy(
        en,
        const ApiException(status: 500, code: 'internal_error'),
      );

      expect(copy.message, en.genericError);
      expect(copy.canRetry, isTrue);
    });

    test('a non-API error, or none, does not leak', () {
      for (final error in [Exception('boom'), StateError('x'), null]) {
        final copy = flashcardsErrorCopy(en, error);
        expect(copy.message, en.genericError, reason: '$error');
        expect(copy.canRetry, isTrue, reason: '$error');
      }
    });

    test('a raw code or server detail is never shown', () {
      final copy = flashcardsErrorCopy(
        en,
        const ApiException(
          status: 500,
          code: 'db_connection_lost',
          detail: 'connection to 10.0.0.4 refused',
        ),
      );

      expect(copy.message, isNot(contains('db_connection_lost')));
      expect(copy.message, isNot(contains('10.0.0.4')));
    });
  });
}
