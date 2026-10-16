import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show AsyncValue;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/features/flashcards/widgets/flashcards_error_copy.dart';
import 'package:level_up_app/features/leaderboard/board_failure.dart';
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

  /// CW02 slice A. The contract's third client rule for this code — route to the
  /// cancel screen — is NOT built: that screen does not exist (it lands in
  /// CW05). Until then every local site that branches on
  /// [isAccountPendingDeletion] must only choose copy and withhold Retry. These
  /// tests pin that seam, one per site file: the branch yields the site's
  /// existing copy / variant with no Retry, AND the file makes no navigation or
  /// sign-out call (the contract also says: do not log out, do not retry).
  ///
  /// The source scan is shallow on purpose — it cannot tell whether a call is
  /// reachable from the pending-deletion branch, only that the file has none.
  /// That is exactly the property wanted until CW05 adds a redirect target.
  group('no redirect yet (CW05 lands the target)', () {
    const cw05 =
        'CW05 adds the pending-deletion redirect target; update this '
        'assertion on purpose when it lands';

    final forbidden = <String, RegExp>{
      'context.go(': RegExp(r'context\.go\('),
      'context.push': RegExp(r'context\.push'),
      'context.replace': RegExp(r'context\.replace'),
      'GoRouter.of': RegExp(r'GoRouter\.of'),
      '.goNamed(': RegExp(r'\.goNamed\('),
      'Navigator.': RegExp(r'Navigator\.'),
      'routerProvider': RegExp('routerProvider'),
      'forceLogout': RegExp('forceLogout'),
      '.logout(': RegExp(r'\.logout\('),
    };

    List<String> navigationCalls(String source) {
      final code = stripComments(source);
      return [
        for (final entry in forbidden.entries)
          if (entry.value.hasMatch(code)) entry.key,
      ];
    }

    void expectNoRedirect(String path) {
      final found = navigationCalls(File(path).readAsStringSync());
      expect(found, isEmpty, reason: '$path calls ${found.join(', ')}. $cw05');
    }

    test('the scan itself sees every call and ignores comments', () {
      const samples = <String, String>{
        'context.go(': 'context.go(x)',
        'context.push': 'context.pushNamed(x)',
        'context.replace': 'context.replace(x)',
        'GoRouter.of': 'GoRouter.of(context)',
        '.goNamed(': 'router.goNamed(x)',
        'Navigator.': 'Navigator.of(context).pop()',
        'routerProvider': 'ref.read(routerProvider)',
        'forceLogout': 'auth.forceLogout(reason)',
        '.logout(': 'auth.logout()',
      };
      // Every pattern in the list has a sample, so none can silently rot.
      expect(samples.keys.toSet(), forbidden.keys.toSet());
      for (final sample in samples.entries) {
        expect(
          navigationCalls('void f() { ${sample.value}; }'),
          contains(sample.key),
          reason: 'the scan must catch ${sample.key}',
        );
        expect(
          navigationCalls('// ${sample.value}\n/* ${sample.value} */'),
          isEmpty,
          reason: 'a comment is not a call (${sample.key})',
        );
        // A `//` inside a string literal is not a comment: the call after it
        // on the same line is still code.
        expect(
          navigationCalls("final u = 'https://x.y'; ${sample.value};"),
          contains(sample.key),
          reason: 'a URL string must not hide ${sample.key} after it',
        );
      }
    });

    test('the comment stripper is string-aware', () {
      // `//` and `/*` inside strings (single, double, triple, raw, with an
      // interpolation holding another string) stay; real comments go.
      expect(
        stripComments("var a = 'x // y'; // gone\nvar b;"),
        contains('x // y'),
      );
      expect(
        stripComments("var a = 'x // y'; // gone\nvar b;"),
        isNot(contains('gone')),
      );
      expect(
        stripComments('var a = "p /* q */ r"; /* gone */'),
        contains('p /* q */ r'),
      );
      expect(
        stripComments('var a = "p /* q */ r"; /* gone */'),
        isNot(contains('gone')),
      );
      expect(
        stripComments("var a = r'a // b'; // gone"),
        contains("r'a // b'"),
      );
      expect(
        stripComments("var a = '''a // b\n// c'''; // gone"),
        contains('a // b\n// c'),
      );
      expect(
        stripComments("var a = 'it\\'s // here'; // gone"),
        contains("it\\'s // here"),
      );
      expect(
        stripComments("var a = '\${b['//']} // q'; // gone"),
        contains("'//'"),
      );
      // An apostrophe in a comment does not open a string that swallows code.
      expect(
        stripComments("// don't\nvoid f() { context.go(x); }"),
        contains('context.go('),
      );
      expect(
        stripComments("/* it's */ void f() { context.go(x); }"),
        contains('context.go('),
      );
      // Block comments nest in Dart.
      expect(
        stripComments('/* a /* b */ still comment */ keep'),
        isNot(contains('still')),
      );
    });

    testWidgets(
      'catalog_states.dart — pending deletion keeps its copy and withholds '
      'Retry, and nothing here navigates or signs out',
      (tester) async {
        // Sites: `isAccountPendingDeletion(value.error)` (the rendered copy and
        // the Retry callback) and `_messageKeyFor` (a ScreenError key that
        // StateWidget never displays, because this widget always supplies its
        // own error child — so only the first is observable from here). The
        // same behaviour is also asserted through a real screen in
        // `test/features/mistakes/mistakes_screens_test.dart`
        // ("account_pending_deletion is NOT swallowed as a scope error").
        for (final l10n in [en, ar]) {
          // It outranks BOTH insufficient_scope meanings, so both are checked.
          for (final scope in ScopeErrorCopy.values) {
            await tester.pumpWidget(
              MaterialApp(
                locale: Locale(l10n.localeName),
                theme: AppTheme.light,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Scaffold(
                  body: CatalogAsyncView<int>(
                    value: AsyncValue<int>.error(
                      pendingDeletion,
                      StackTrace.empty,
                    ),
                    scopeError: scope,
                    isEmpty: (_) => false,
                    emptyMessage: 'empty',
                    onRetry: () {},
                    onLoaded: (_) => const SizedBox.shrink(),
                    skeleton: const SizedBox.shrink(),
                  ),
                ),
              ),
            );
            await tester.pump();

            final reason = '${l10n.localeName} / ${scope.name}';
            expect(
              find.text(l10n.accountPendingDeletion),
              findsOneWidget,
              reason: reason,
            );
            expect(find.text(l10n.genericError), findsNothing, reason: reason);
            expect(find.text(l10n.retry), findsNothing, reason: reason);
            expect(find.byType(FilledButton), findsNothing, reason: reason);
          }
        }

        expectNoRedirect('lib/features/catalog/widgets/catalog_states.dart');
      },
    );

    test('flashcards_error_copy.dart — pending deletion keeps its copy and '
        'withholds Retry, and nothing here navigates or signs out', () {
      // Site: the `_ when isAccountPendingDeletion(error)` arm. Also asserted
      // in `test/features/flashcards/flashcards_error_copy_test.dart`
      // ("account_pending_deletion"); repeated here only because that file
      // does not own the "no redirect yet" seam.
      for (final l10n in [en, ar]) {
        expect(
          flashcardsErrorCopy(l10n, pendingDeletion),
          FlashcardsErrorCopy(
            message: l10n.accountPendingDeletion,
            canRetry: false,
          ),
          reason: l10n.localeName,
        );
      }

      expectNoRedirect(
        'lib/features/flashcards/widgets/flashcards_error_copy.dart',
      );
    });

    test('board_failure.dart — pending deletion keeps its copy and withholds '
        'Retry, and nothing here navigates or signs out', () {
      // Sites: `boardFailureText` and `boardRetryAllowed` (two calls). Also
      // asserted through real screens in
      // `test/features/leaderboard/leaderboard_screen_test.dart`
      // ("account_pending_deletion (adr-114) — the grace window") and
      // `test/features/home/top_student_section_test.dart`.
      for (final l10n in [en, ar]) {
        expect(
          boardFailureText(l10n, pendingDeletion),
          l10n.accountPendingDeletion,
          reason: l10n.localeName,
        );
      }
      expect(boardRetryAllowed(pendingDeletion), isFalse);

      expectNoRedirect('lib/features/leaderboard/board_failure.dart');
    });

    test('profile_error_copy.dart — pending deletion keeps its banner copy (no '
        'Retry on this path), and nothing here navigates or signs out', () {
      // Site: `profileSaveErrorMessage`. It returns a banner string only; the
      // profile screen has no Retry button on this path to withhold.
      for (final l10n in [en, ar]) {
        expect(
          profileSaveErrorMessage(l10n, pendingDeletion),
          l10n.accountPendingDeletion,
          reason: l10n.localeName,
        );
      }

      expectNoRedirect('lib/features/profile/profile_error_copy.dart');
    });

    test('quiz_error_copy.dart — pending deletion keeps its copy and withholds '
        'Retry, and nothing here navigates or signs out', () {
      // Sites: `quizErrorMessage` and `suppressesRetry` (two calls).
      for (final l10n in [en, ar]) {
        expect(
          quizErrorMessage(l10n, pendingDeletion),
          l10n.accountPendingDeletion,
          reason: l10n.localeName,
        );
      }
      expect(suppressesRetry(pendingDeletion), isTrue);

      expectNoRedirect('lib/features/quiz/widgets/quiz_error_copy.dart');
    });
  });
}

/// Dart source with its comments removed and its string literals left alone.
///
/// The previous version (`replaceAll(RegExp('//.*'), '')`) treated the `//` in
/// `'https://…'` as the start of a comment and deleted the rest of the line, so
/// a forbidden call written after a URL on the same line was invisible to the
/// scan. This walks the source instead: line and (nested) block comments are
/// dropped; single-, double-, triple-quoted and raw strings are copied through
/// verbatim, including an interpolation `${…}` that holds another string.
///
/// A forbidden name inside a string literal still counts as a hit. That errs
/// toward failing — the right direction for a "nothing here navigates" guard.
String stripComments(String source) {
  final out = StringBuffer();
  _copyCode(source, 0, out, inInterpolation: false);
  return out.toString();
}

/// Copies code from [from] to the end — or, for an interpolation, to the `}`
/// that closes its `${`. Returns the index after where it stopped.
int _copyCode(
  String s,
  int from,
  StringBuffer out, {
  required bool inInterpolation,
}) {
  var i = from;
  var depth = 0;
  while (i < s.length) {
    if (s.startsWith('//', i)) {
      while (i < s.length && s[i] != '\n') {
        i++;
      }
      continue;
    }
    if (s.startsWith('/*', i)) {
      i = _skipBlockComment(s, i);
      out.write(' ');
      continue;
    }
    final c = s[i];
    if (c == "'" || c == '"') {
      i = _copyString(s, i, out, raw: _isRawPrefix(s, i));
      continue;
    }
    if (inInterpolation) {
      if (c == '{') depth++;
      if (c == '}') {
        if (depth == 0) return i;
        depth--;
      }
    }
    out.write(c);
    i++;
  }
  return i;
}

/// `r'…'` / `r"…"`: an `r` that is not the tail of an identifier.
bool _isRawPrefix(String s, int quote) {
  if (quote == 0 || s[quote - 1] != 'r') return false;
  if (quote == 1) return true;
  return !RegExp(r'[A-Za-z0-9_$]').hasMatch(s[quote - 2]);
}

/// The index after the (possibly nested) block comment that starts at [start].
int _skipBlockComment(String s, int start) {
  var depth = 1;
  var i = start + 2;
  while (i < s.length && depth > 0) {
    if (s.startsWith('/*', i)) {
      depth++;
      i += 2;
    } else if (s.startsWith('*/', i)) {
      depth--;
      i += 2;
    } else {
      i++;
    }
  }
  return i;
}

/// Copies the string literal that opens at [start]; returns the index after it.
int _copyString(String s, int start, StringBuffer out, {required bool raw}) {
  final quote = s[start];
  final open = s.startsWith(quote * 3, start) ? quote * 3 : quote;
  out.write(open);
  var i = start + open.length;
  while (i < s.length) {
    if (s.startsWith(open, i)) {
      out.write(open);
      return i + open.length;
    }
    final c = s[i];
    if (!raw && c == r'\') {
      out.write(s.substring(i, i + 2 > s.length ? s.length : i + 2));
      i += 2;
      continue;
    }
    // An unterminated single-line string: stop rather than swallow the file.
    if (open.length == 1 && c == '\n') return i;
    if (!raw && s.startsWith(r'${', i)) {
      out.write(r'${');
      i = _copyCode(s, i + 2, out, inInterpolation: true);
      if (i < s.length) {
        out.write('}');
        i++;
      }
      continue;
    }
    out.write(c);
    i++;
  }
  return i;
}
