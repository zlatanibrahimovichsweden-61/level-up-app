import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/features/profile/widgets/profile_confirm_dialog.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

/// Which CTAs wear edit2's elevation, and in which tone.
///
/// The wrapper is what carries the shadow and (in dark) the lavender glow, so a
/// CTA that loses its `PrimaryCta` loses its elevation silently — nothing
/// fails to compile and nothing looks obviously wrong on the light canvas. The
/// primitive's own painting is edit1's test; this pins the CALL SITES.
///
/// **The buttons deliberately NOT wrapped** (edit2.md §7.3.2). None of these has
/// a Figma frame, so giving one a drop shadow would be inventing a design
/// value; the list is recorded here because "it has no wrapper" is otherwise
/// indistinguishable from "somebody forgot":
///
/// * the error-state Retry buttons — `core/widgets/state_widget.dart`,
///   `catalog/widgets/catalog_states.dart`, `home/screens/home_screen.dart`,
///   `profile/screens/profile_screen.dart`,
///   `leaderboard/screens/leaderboard_screen.dart`,
///   `registration/widgets/school_picker_field.dart`;
/// * `registration/screens/registration_expired_view.dart`;
/// * the `core/router/app_router.dart` "route not found" fallback.
///
/// **Edit Profile's Save and both OTP CTAs are no longer among them.** edit5
/// wrapped Save on 2026-09-20 (`348:8911` / glow `348:8909`), pinned in
/// `test/features/profile/edit_profile_elevation_test.dart`; the same edit's
/// OTP chunk wrapped "Verify" and the success "Continue"
/// (`Frame 427319502` / `427319511`), pinned in
/// `test/features/auth/otp_elevation_test.dart`. Each lives with its own
/// screen's harness rather than here, because reaching it needs one.
///
/// **The quiz CTAs are no longer among them.** edit4 wrapped Setup "Start",
/// the taking screen's Confirm/Next/Finish and Result "Review Questions" on
/// 2026-09-20; each is pinned in its own screen's test file rather than here,
/// because reaching them needs that file's harness.
void main() {
  PrimaryCta ctaWrapping(WidgetTester tester, Finder button) => tester.widget(
    find.ancestor(of: button, matching: find.byType(PrimaryCta)).first,
  );

  /// The app chrome only. Riverpod 3 does not export `Override`, so a scope
  /// is wrapped around this at the call site rather than passed into it.
  Widget app(Widget home) => MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );

  // -------------------------------------------------------------------------
  group('Onboarding', () {
    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(path: '/', builder: (_, _) => const OnboardingScreen()),
                GoRoute(
                  path: '/login',
                  builder: (_, _) => const Scaffold(body: Text('login')),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Get Started is the primary tone', (tester) async {
      await pump(tester);
      final cta = ctaWrapping(tester, find.byType(FilledButton));
      expect(cta.tone, CtaTone.primary);
      expect(cta.enabled, isTrue);
    });

    testWidgets('Log In is the outline tone', (tester) async {
      await pump(tester);
      final cta = ctaWrapping(tester, find.byType(OutlinedButton));
      expect(cta.tone, CtaTone.outline);
    });
  });

  // -------------------------------------------------------------------------
  group('Login', () {
    Future<void> pump(WidgetTester tester, {bool offline = false}) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
            isOnlineProvider.overrideWith((ref) => Stream.value(!offline)),
          ],
          child: app(const LoginScreen()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Send OTP is primary, Create New Account is outline', (
      tester,
    ) async {
      await pump(tester);
      expect(
        ctaWrapping(tester, find.byType(FilledButton)).tone,
        CtaTone.primary,
      );
      expect(
        ctaWrapping(tester, find.byType(OutlinedButton)).tone,
        CtaTone.outline,
      );
    });

    testWidgets('online · `enabled` mirrors `onPressed != null`', (
      tester,
    ) async {
      await pump(tester);
      expect(ctaWrapping(tester, find.byType(FilledButton)).enabled, isTrue);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    });

    // A fresh pump rather than a second one inside the test above: re-pumping
    // a new `ProviderScope` over the same element tree keeps the screen's
    // State, and the re-subscribed stream has not delivered by the time the
    // assertion runs.
    testWidgets('offline · both CTAs go disabled, wrapper included', (
      tester,
    ) async {
      await pump(tester, offline: true);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(ctaWrapping(tester, find.byType(FilledButton)).enabled, isFalse);
      expect(ctaWrapping(tester, find.byType(OutlinedButton)).enabled, isFalse);
    });
  });

  // -------------------------------------------------------------------------
  group('Sign Up_2 (track)', () {
    testWidgets('Continue is disabled until a track is picked, and the '
        'wrapper says so too', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(registrationControllerProvider.notifier)
          .start(
            const RegistrationArgs(
              registrationToken: 'reg.token',
              expiresInSeconds: 600,
              phone: '+2010000000001',
            ),
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SignupTrackScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final cta = ctaWrapping(tester, find.byType(FilledButton));
      expect(cta.tone, CtaTone.primary);
      expect(cta.enabled, isFalse);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('ProfileConfirmDialog', () {
    Future<void> pump(
      WidgetTester tester, {
      required ProfileConfirmTone tone,
      bool confirmEnabled = true,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          child: app(
            Scaffold(
              body: ProfileConfirmDialog(
                title: 'title',
                body: 'body',
                confirmLabel: 'confirm',
                tone: tone,
                confirmEnabled: confirmEnabled,
                disabledReason: 'because',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Logout is the destructive tone — shadow, NO glow', (
      tester,
    ) async {
      await pump(tester, tone: ProfileConfirmTone.destructive);
      expect(
        ctaWrapping(tester, find.byType(FilledButton)).tone,
        CtaTone.destructive,
      );
    });

    testWidgets('Go to University is the primary tone — it DOES glow in dark', (
      tester,
    ) async {
      await pump(tester, tone: ProfileConfirmTone.primary);
      expect(
        ctaWrapping(tester, find.byType(FilledButton)).tone,
        CtaTone.primary,
      );
    });

    testWidgets('`enabled` mirrors `confirmEnabled`', (tester) async {
      await pump(tester, tone: ProfileConfirmTone.primary);
      expect(ctaWrapping(tester, find.byType(FilledButton)).enabled, isTrue);

      await pump(
        tester,
        tone: ProfileConfirmTone.primary,
        confirmEnabled: false,
      );
      expect(ctaWrapping(tester, find.byType(FilledButton)).enabled, isFalse);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('buttons with no Figma frame are deliberately NOT wrapped', () {
    testWidgets('the offline Retry on Login has no PrimaryCta', (tester) async {
      // Login's own error Retry lives in `_InlineMessage`'s sibling; the
      // simplest true statement is that the screen wraps exactly the two CTAs
      // the frames draw, and no more.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
            isOnlineProvider.overrideWith((ref) => Stream.value(false)),
          ],
          child: app(const LoginScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PrimaryCta), findsNWidgets(2));
    });
  });
}
