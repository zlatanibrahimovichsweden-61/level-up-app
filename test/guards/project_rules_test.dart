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
  test('autoDispose notifiers that await track their own disposal', () {
    // Wave-3 3A. An autoDispose provider dies with its last listener, so an
    // await that outlives the screen resumes on a dead notifier and throws on
    // the next `state =`. Unhandled async error, invisible to a green suite.
    //
    // Non-autoDispose providers are deliberately excluded: they live for the
    // container's lifetime and cannot hit this, so guarding them would be
    // noise. That distinction is why the original "9 sites" finding narrowed
    // to 4 real ones.
    expect(
      autoDisposeNotifiersWithoutDisposalFlag(sources),
      isEmpty,
      reason:
          'An autoDispose notifier awaits but has no disposal flag. Add '
          '`bool _disposed = false;` and `ref.onDispose(() => _disposed = true);` '
          'in build(), then guard each post-await `state =` with '
          '`if (_disposed) return;` — placed AFTER any side effect that must '
          'survive the screen closing.',
    );
  });

  // -------------------------------------------------------------------------
  group('user-facing copy goes through AppLocalizations', () {
    // Arabic is the baseline locale here, not an edge case, so a hardcoded
    // English string is a bug in half the product.
    //
    // Wave 3 fixed the two genuine leaks: the shared Retry button
    // (`state_widget.dart`, reached from every screen without a custom error
    // view) and the `/subscription` placeholder body. Both now read existing
    // ARB keys — `retry` and `comingSoon` — so no translation was invented and
    // ARB parity was never at risk.
    //
    // The four that remain are ALL legitimately untranslatable, which is why
    // this stays an allowlist rather than becoming a ban: two flag emoji, and
    // two punctuation joiners between halves that are themselves localized
    // (`Text('${l10n.legalPrefix} ')`).
    //
    // The fifth was NOT untranslatable and is now gone: the legal line's
    // separator was the literal '، ' — U+060C ARABIC COMMA — rendered in BOTH
    // locales, so English read "User Agreement، Privacy Policy". It is now the
    // `legalSeparator` ARB key, ', ' in English and '، ' in Arabic.
    const knownFiles = <String, String>{
      'lib/features/auth/screens/login_screen.dart':
          'Flag emoji + punctuation joining localized legal-link halves.',
      'lib/features/registration/screens/signup_identity_screen.dart':
          'Flag emoji beside the read-only phone field.',
    };

    /// Frozen 2026-08-14 at 7. Lowered to 5 on 2026-08-15 after Wave 3 removed
    /// two genuine leaks, and to 4 on 2026-08-21 when the legal separator was
    /// localized — remediation each time, not an artificial reduction. Lowered
    /// in the same change as the removal, per RISKS.md R-7. May fall further,
    /// never rise.
    const baseline = 4;

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
    // Frozen 2026-08-14 at 153. **Lowered to 0 on 2026-08-21**: the designer
    // supplied the scale (`typography-style-inter.md`), `AppType` transcribes
    // it, and all 153 call sites were migrated onto it. R-1 is closed.
    //
    // The real enforcement now lives in
    // `test/core/theme/typography_discipline_test.dart`, which is the palette
    // guard's twin and also names the offending file:line. This stays as the
    // ratchet half of the pair — it counts, that one locates — and it is
    // deliberately redundant, because the count is the thing that regressed
    // for two months while everyone believed the prose rule was holding.
    const baseline = 0;

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
  test('raw elevation effects do not increase (ratchet)', () {
    // Elevation's version of the fontSize ratchet, and it exists for the same
    // reason: a design value decided at a call site. Five `BoxShadow`s shipped
    // with Figma's *blur* number in Flutter's `blurRadius` field - two
    // different units, roughly 2x too soft - under a colour token that only
    // read on one canvas (docs/DESIGN_ISSUES.md #47). Nothing caught any of it,
    // because a shadow written inline compiles, analyses clean, and looks
    // plausible on whichever canvas it was eyeballed against.
    //
    // The tokens now live in `lib/core/theme/app_elevation.dart` and the only
    // code allowed to paint them lives in `lib/core/widgets/elevation/`. Those
    // two folders are exempt; everything else is counted.
    //
    // Frozen 2026-09-17 at 11, measured with this detector, not estimated. The
    // eleven were the nav bar's blur, the onboarding sheet, the Mistakes
    // subject card (2), the AI panel, the review filter (2), the OTP timer, the
    // avatar badge, the profile header and a profile stat card.
    //
    // **Each of edits 2-5 lowers this in the SAME change that removes a site**
    // (RISKS.md R-7): edit2 -2, edit3 -2, edit4 -3, edit5 -4. When it reaches
    // 0, replace this count with a zero-enforcement test that names the
    // offending `file:line`, the way the typography pair already works -
    // `typography_discipline_test.dart` locates, this one counts.
    //
    // 2026-09-18, edit2: 11 -> 9, measured with this detector after the change.
    // The nav bar's `MaskFilter.blur` became `AppElevation.navBarShadows` under
    // `paintFigmaShadows`, and the onboarding sheet's `BoxShadow` became
    // `onboardingSheetShadows` under `ElevatedSurface`. The nine left are the
    // OTP timer, the Mistakes subject card (2), the avatar badge, the profile
    // header, a profile stat card, the review filter (2) and the AI panel -
    // edits 3, 4 and 5.
    const baseline = 9;

    final sites = rawElevationEffects(sources);
    expect(
      sites.length,
      lessThanOrEqualTo(baseline),
      reason:
          'Raw elevation effects rose to ${sites.length} (baseline '
          '$baseline). Do not write a BoxShadow, an elevation, a MaskFilter '
          'or a BackdropFilter at a call site: read the component\'s token '
          'from `Theme.of(context).extension<AppElevation>()!` and hand it to '
          '`ElevatedSurface`. If you legitimately removed a site, lower the '
          'baseline here in the same change.\n${sites.join('\n')}',
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
