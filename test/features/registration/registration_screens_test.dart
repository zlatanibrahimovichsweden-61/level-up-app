import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/screens/signup_identity_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

const _args = RegistrationArgs(
  registrationToken: 'reg.token',
  expiresInSeconds: 600,
  phone: '+201021871999',
);

Widget _marker(String text) =>
    Scaffold(body: Center(child: Text(text)));

/// A standalone router for the wizard front — no auth redirect, so the screens
/// are exercised in isolation. Day-3 sub-flows are simple markers.
GoRouter _router(String initial) => GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: '/register',
          builder: (_, state) =>
              SignupIdentityScreen(args: state.extra as RegistrationArgs?),
        ),
        GoRoute(
          path: '/register/track',
          builder: (_, _) => const SignupTrackScreen(),
        ),
        GoRoute(path: '/register/school', builder: (_, _) => _marker('SCHOOL FLOW')),
        GoRoute(
          path: '/register/university',
          builder: (_, _) => _marker('UNIVERSITY FLOW'),
        ),
        GoRoute(path: '/login', builder: (_, _) => _marker('LOGIN')),
      ],
    );

Future<void> _tapContinue(WidgetTester tester) async {
  final finder = find.widgetWithText(FilledButton, 'Continue');
  await tester.ensureVisible(finder); // form can exceed the viewport
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  String initial, {
  bool seed = true,
  Locale locale = const Locale('en'),
}) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  if (seed) {
    container.read(registrationControllerProvider.notifier).start(_args);
  }
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        locale: locale,
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router(initial),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  group('Sign Up_1 (identity)', () {
    testWidgets('shows the proven phone read-only (not an editable field)',
        (tester) async {
      await _pump(tester, '/register');

      expect(find.text('+201021871999'), findsOneWidget);
      // Name, Parent's Number, Referral are the only editable fields — the phone
      // is a read-only Text, so exactly three TextFields exist.
      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets('empty name blocks Continue with an inline error', (tester) async {
      final container = await _pump(tester, '/register');

      await _tapContinue(tester);

      expect(find.text('Please enter your name'), findsOneWidget);
      // No navigation and nothing stored.
      expect(container.read(registrationControllerProvider)!.name, isNull);
    });

    testWidgets('invalid parent phone blocks Continue', (tester) async {
      final container = await _pump(tester, '/register');

      await tester.enterText(find.byType(TextField).at(0), 'Mostafa');
      await tester.enterText(find.byType(TextField).at(1), '123'); // invalid
      await _tapContinue(tester);

      expect(find.text('Please enter a valid phone number'), findsOneWidget);
      expect(container.read(registrationControllerProvider)!.parentPhone, isNull);
    });

    testWidgets(
        'valid input stores identity (referral collected) and routes to track',
        (tester) async {
      final container = await _pump(tester, '/register');

      await tester.enterText(find.byType(TextField).at(0), 'Mostafa');
      await tester.enterText(find.byType(TextField).at(1), '01000000000');
      await tester.enterText(find.byType(TextField).at(2), 'FRIEND10');
      await _tapContinue(tester);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.name, 'Mostafa');
      expect(draft.parentPhone, '+201000000000'); // normalized E.164
      expect(draft.referralCode, 'FRIEND10'); // collected, not submitted
      // Landed on the track picker.
      expect(find.text('Choose Your Track'), findsOneWidget);
    });

    testWidgets('renders Arabic with RTL directionality', (tester) async {
      await _pump(tester, '/register', locale: const Locale('ar'));

      expect(find.text('إنشاء حساب'), findsOneWidget); // createAccountTitle (AR)
      expect(
        Directionality.of(tester.element(find.text('إنشاء حساب'))),
        TextDirection.rtl,
      );
    });

    testWidgets('no draft → expiry guard, Back to login routes to /login',
        (tester) async {
      await _pump(tester, '/register', seed: false);

      expect(
        find.text('Your registration session expired. Please start again.'),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Back to login'));
      await tester.pumpAndSettle();
      expect(find.text('LOGIN'), findsOneWidget);
    });
  });

  group('Sign Up_2 (track picker)', () {
    testWidgets('Continue is disabled until a track is selected', (tester) async {
      await _pump(tester, '/register/track');

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Continue'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('selecting School sets the discriminator and routes to /school',
        (tester) async {
      final container = await _pump(tester, '/register/track');

      await tester.tap(find.text('School Student'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(container.read(registrationControllerProvider)!.track,
          RegTrack.school);
      expect(find.text('SCHOOL FLOW'), findsOneWidget);
    });

    testWidgets('selecting University routes to /university', (tester) async {
      final container = await _pump(tester, '/register/track');

      await tester.tap(find.text('University Student'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(container.read(registrationControllerProvider)!.track,
          RegTrack.university);
      expect(find.text('UNIVERSITY FLOW'), findsOneWidget);
    });
  });
}
