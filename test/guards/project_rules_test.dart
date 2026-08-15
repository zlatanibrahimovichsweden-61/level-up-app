import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'rules.dart';

/// The project's mechanically-enforced rules, applied to the real repository.
///
/// The detectors live in `rules.dart` and are proven to actually detect
/// violations in `rules_test.dart`. This file only points them at `lib/` and
/// records the policy: what is enforced at zero, what is allowlisted, and what
/// is ratcheted.
///
/// Each rule below states WHY it exists, because a guard whose reason has been
/// forgotten gets deleted the first time it is inconvenient.
void main() {
  late List<Source> sources;

  setUpAll(() {
    sources = libSources();
  });

  test('lib/ is actually being scanned', () {
    // If a refactor moves lib/ or the filter becomes too aggressive, every rule
    // below would pass vacuously. This is the canary for that.
    expect(
      sources.length,
      greaterThan(100),
      reason: 'expected the full lib/ tree; the scan looks empty or filtered',
    );
  });

  // -------------------------------------------------------------------------
  test('Bloc stays inside the quiz feature', () {
    // Riverpod is the app's state management AND its DI. Bloc exists for the
    // quiz engine only, where three concurrent async sources (timer ticks,
    // answer taps, network confirmations) make an explicit state machine worth
    // its cost. Written down in State_Management.md and bloc/SKILL.md; unenforced
    // until now. A third state-management pattern arriving by drift is how a
    // codebase ends up with three ways to do one thing.
    expect(
      blocOutsideQuiz(sources),
      isEmpty,
      reason:
          'flutter_bloc may only be imported under lib/features/quiz/. '
          'Everything else uses Riverpod — see .claude/skills/river/SKILL.md.',
    );
  });

  // -------------------------------------------------------------------------
  test('no provider is mutated during initState', () {
    // BUG-001, as a test. Writing to a provider in initState runs during
    // element mount — part of the build phase — and Riverpod asserts on it.
    // It red-screened the entire registration wizard on a real device while
    // 216 widget tests stayed green, because a direct-pump test mounts during
    // the INITIAL build where the guard flag is not set. Only router-driven
    // navigation reaches it, so no unit test will ever catch this class for us.
    expect(
      providerMutationInInitState(sources),
      isEmpty,
      reason:
          'A provider was written to inside initState. Defer it with '
          'WidgetsBinding.instance.addPostFrameCallback, or move the write to a '
          'callback. See docs/KNOWN_BUGS.md BUG-001.',
    );
  });

  // -------------------------------------------------------------------------
  group('user-facing copy goes through AppLocalizations', () {
    // Arabic is the baseline locale here, not an edge case, so a hardcoded
    // English string is a bug in half the product.
    //
    // Two of the current seven are genuine leaks (the placeholder route and the
    // Retry button) and belong to Wave 3. The rest are legitimately
    // untranslatable: a flag emoji, and punctuation joining two already
    // localized halves. So this is an allowlist plus a ratchet rather than a
    // ban — new files cannot introduce a leak, and the total cannot grow.
    const knownFiles = <String, String>{
      'lib/core/router/app_router.dart':
          'Wave-3: the "not built yet" placeholder route copy.',
      'lib/core/widgets/state_widget.dart': 'Wave-3: the Retry button label.',
      'lib/features/auth/screens/login_screen.dart':
          'Flag emoji + punctuation joining localized legal-link halves.',
      'lib/features/registration/screens/signup_identity_screen.dart':
          'Flag emoji beside the read-only phone field.',
    };

    /// Frozen 2026-08-14. May fall, never rise.
    const baseline = 7;

    test('no NEW file introduces a hardcoded string', () {
      final offenders = rawTextLiterals(sources)
          .map((site) => site.split(':').first)
          .toSet()
          .where((path) => !knownFiles.containsKey(path))
          .toList();

      expect(
        offenders,
        isEmpty,
        reason:
            'Hardcoded user-facing text in a file that had none. Use '
            'AppLocalizations.of(context) and add the key to BOTH '
            'lib/l10n/app_en.arb and app_ar.arb.\n${offenders.join('\n')}',
      );
    });

    test('the count does not grow', () {
      final all = rawTextLiterals(sources);
      expect(
        all.length,
        lessThanOrEqualTo(baseline),
        reason:
            'Hardcoded Text() literals rose above the frozen baseline of '
            '$baseline. Localize the new one. If you removed some, lower the '
            'baseline in this test.\n${all.join('\n')}',
      );
    });
  });

  // -------------------------------------------------------------------------
  test('hardcoded fontSize does not increase (ratchet)', () {
    // There is no TextTheme in this app and 153 call sites set fontSize inline.
    // That is the same class of violation the palette guard was built for —
    // a design value decided at the call site instead of in the design system —
    // applied to typography, and entirely uncaught.
    //
    // It cannot be enforced at zero without a refactor that is out of Wave-2
    // scope. So it is a RATCHET: the number may fall, never rise. That turns
    // "we should add a TextTheme one day" from an aspiration into a boundary —
    // new screens cannot make it worse while the debt is paid down deliberately.
    //
    // Frozen 2026-08-14. Lower it when you remove some; never raise it.
    const baseline = 153;

    final n = hardcodedFontSizeCount(sources);
    expect(
      n,
      lessThanOrEqualTo(baseline),
      reason:
          'Hardcoded fontSize count rose to $n (baseline $baseline). Read the '
          'size from the theme instead of setting it at the call site. If you '
          'legitimately reduced the count, lower the baseline here.',
    );
  });

  // -------------------------------------------------------------------------
  test('both ARB files carry the same keys', () {
    // A key missing from app_ar.arb does not throw — gen-l10n falls back to
    // English silently. The failure mode is an Arabic screen with an English
    // word in it that nobody notices until a student does.
    final drift = arbKeyDrift(
      File('lib/l10n/app_en.arb').readAsStringSync(),
      File('lib/l10n/app_ar.arb').readAsStringSync(),
    );

    expect(
      drift.missingInAr,
      isEmpty,
      reason:
          'Keys in app_en.arb with no Arabic translation. gen-l10n will fall '
          'back to English SILENTLY: ${drift.missingInAr.join(', ')}',
    );
    expect(
      drift.extraInAr,
      isEmpty,
      reason:
          'Orphan keys in app_ar.arb with no English source — usually a typo '
          'or a leftover: ${drift.extraInAr.join(', ')}',
    );
  });
}
