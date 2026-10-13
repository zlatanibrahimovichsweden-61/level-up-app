import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/otp_notifier.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../goldens/golden_harness.dart' show loadAppFonts;

/// The OTP sign-in SUCCESS view, from two angles that both come from the E1
/// journey sweep:
///
///  1. It scrolls. Its Continue button is the only way forward and sits at the
///     bottom of a Column; when the view was taller than the screen (a phone on
///     its side, the largest text on a 568 dp screen) the button was DRAWN
///     outside the Column's bounds, where a tap does not reach it.
///  2. The OS Back is Continue. It used to pop to the Login form while the
///     student was signed in. Both exits end at the one return-target rule
///     (owner decision O-10), so the spy below sees a single `consume` per exit
///     with the signed-in student's id.
///
/// The router here is the smallest that has the shape of the real one: Login,
/// with the OTP route nested under it, plus the places Continue may land.
class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

/// Records every `consume`. Single-use like the real one: the first call hands
/// the remembered place over, and a later call finds it spent and answers the
/// fallback (Home).
class _SpyTarget extends ReturnTarget {
  _SpyTarget(this.answer);

  final String answer;
  final calls = <String?>[];

  @override
  String consume({required String? studentId, String fallback = '/home'}) {
    calls.add(studentId);
    return calls.length == 1 ? answer : fallback;
  }
}

const _args = OtpArgs(
  phone: '+2010000000001',
  resendAfterSeconds: 0,
  expiresInSeconds: 300,
);
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _tokens = TokenPair(
  accessToken: 'access.jwt',
  accessExpiresInSeconds: 900,
  refreshToken: 'refresh.jwt',
  refreshExpiresInSeconds: 5184000,
);

/// A server student id; only equality is ever checked.
const _studentId = 'stu-1';

/// Where the spy sends the student: a remembered place, not the Home fallback,
/// so "went to the target" and "went to the default" cannot be confused.
const _remembered = '/remembered';

class _Rig {
  _Rig(this.router, this.container, this.spy, this.exits);

  final GoRouter router;
  final ProviderContainer container;
  final _SpyTarget spy;
  final List<String> exits;

  String get location => router.state.uri.toString();
}

void main() {
  setUpAll(() async {
    registerFallbackValue(_device);
    await loadAppFonts();
  });

  Future<_Rig> pumpSuccess(
    WidgetTester tester, {
    Size size = const Size(412, 915),
    double textScale = 1.0,
    String locale = 'en',
    bool signedIn = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    if (textScale != 1.0) {
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }

    final repo = _MockAuthRepository();
    final storage = _MockSecureStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenAnswer(
      (_) async => const AuthResult.authenticated(
        tokens: _tokens,
        profile: {'id': _studentId},
      ),
    );

    final spy = _SpyTarget(_remembered);
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        returnTargetProvider.overrideWithValue(spy),
      ],
    );
    addTearDown(container.dispose);

    // `SystemNavigator.pop` is what a Back nothing handled asks the OS for.
    final exits = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.pop') exits.add(call.method);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    Widget marker(String text) => Scaffold(body: Center(child: Text(text)));
    final router = GoRouter(
      initialLocation: '/login/otp',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, _) => marker('LOGIN FORM'),
          routes: [
            GoRoute(
              path: 'otp',
              builder: (_, _) => const OtpScreen(args: _args),
            ),
          ],
        ),
        GoRoute(path: '/home', builder: (_, _) => marker('HOME')),
        GoRoute(path: _remembered, builder: (_, _) => marker('REMEMBERED')),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(locale),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(OtpScreen), findsOneWidget);

    if (signedIn) {
      await container.read(otpProvider(_args).notifier).verify('482913');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(_title(locale)), findsOneWidget);
    }
    return _Rig(router, container, spy, exits);
  }

  Finder continueButton(String locale) => find.widgetWithText(
    FilledButton,
    lookupAppLocalizations(Locale(locale)).continueLabel,
  );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  // ---------------------------------------------------------------------------
  // 1. It scrolls
  // ---------------------------------------------------------------------------

  // Landscape phones (neither platform forbids them) and the smallest portrait
  // phone at the OS's largest text. The Arabic title wraps differently and the
  // view just fits at 568 dp high: there it is only required to stay reachable.
  const tall = <(String, Size, double, bool)>[
    ('landscape 915x412', Size(915, 412), 1.0, true),
    ('landscape 640x360', Size(640, 360), 1.0, true),
    ('320x568 at 2.0x text', Size(320, 568), 2.0, false),
    ('360x568 at 2.0x text', Size(360, 568), 2.0, false),
  ];
  for (final (tag, size, scale, scrollsInArabic) in tall) {
    for (final locale in ['en', 'ar']) {
      testWidgets('Continue can be reached and tapped on $tag ($locale)', (
        tester,
      ) async {
        final rig = await pumpSuccess(
          tester,
          size: size,
          textScale: scale,
          locale: locale,
        );
        expect(tester.takeException(), isNull, reason: 'layout overflow');

        // Taller than the screen, it scrolls...
        final scrollable = find.descendant(
          of: find.byType(OtpScreen),
          matching: find.byType(Scrollable),
        );
        if (locale == 'en' || scrollsInArabic) {
          expect(
            tester.state<ScrollableState>(scrollable).position.maxScrollExtent,
            greaterThan(0),
          );
        }

        // ...and the button a student scrolls to is on screen and answers.
        await tester.ensureVisible(continueButton(locale));
        await tester.pump();
        final rect = tester.getRect(continueButton(locale));
        expect(rect.bottom, lessThanOrEqualTo(size.height));
        expect(rect.top, greaterThanOrEqualTo(0));

        await tester.tap(continueButton(locale));
        await settle(tester);
        expect(rig.location, _remembered);
        expect(rig.spy.calls, [_studentId]);
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final locale in ['en', 'ar']) {
    testWidgets('a view that fits does not scroll and stays centred ($locale)', (
      tester,
    ) async {
      await pumpSuccess(tester, locale: locale);
      expect(tester.takeException(), isNull);

      final scrollable = find.descendant(
        of: find.byType(OtpScreen),
        matching: find.byType(Scrollable),
      );
      expect(
        tester.state<ScrollableState>(scrollable).position.maxScrollExtent,
        0,
      );

      // The block is centred in the room under the header row: what sits above
      // the badge (past the 8 of padding) equals what sits under the button
      // (past the 24).
      final viewport = tester.getRect(scrollable);
      final badge = tester.getRect(_successBadge);
      final button = tester.getRect(continueButton(locale));
      expect(viewport.height, greaterThan(button.bottom - badge.top));
      expect(
        badge.top - viewport.top - 8,
        moreOrLessEquals(viewport.bottom - button.bottom - 24, epsilon: 0.5),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // 2. The OS Back is Continue
  // ---------------------------------------------------------------------------

  for (final locale in ['en', 'ar']) {
    testWidgets('OS Back from the success view goes where Continue goes, not '
        'to the Login form ($locale)', (tester) async {
      final rig = await pumpSuccess(tester, locale: locale);

      await tester.binding.handlePopRoute();
      await settle(tester);

      expect(rig.location, _remembered);
      expect(find.text('LOGIN FORM'), findsNothing);
      expect(find.byType(OtpScreen), findsNothing);
      expect(rig.exits, isEmpty, reason: 'the app handled the Back itself');
      // The return target was consumed exactly as Continue consumes it: once,
      // for the student who just signed in.
      expect(rig.spy.calls, [_studentId]);
    });

    testWidgets('Continue consumes the target once, for the student who '
        'signed in ($locale)', (tester) async {
      final rig = await pumpSuccess(tester, locale: locale);

      await tester.tap(continueButton(locale));
      await settle(tester);

      expect(rig.location, _remembered);
      expect(rig.spy.calls, [_studentId]);
      expect(rig.exits, isEmpty);
    });
  }

  // ---------------------------------------------------------------------------
  // 3. The exit runs once
  //
  // A janky handset can deliver two exits before the first navigation has been
  // built: the same Back twice, Back and Continue, Continue twice. The return
  // target is single-use, so a second consume finds it spent and answers Home -
  // and the student, who was going to the place their session ended at, lands
  // on Home instead.
  // ---------------------------------------------------------------------------

  for (final locale in ['en', 'ar']) {
    testWidgets('two OS Backs in one frame leave once, for the remembered '
        'place ($locale)', (tester) async {
      final rig = await pumpSuccess(tester, locale: locale);

      final first = tester.binding.handlePopRoute();
      final second = tester.binding.handlePopRoute();
      await Future.wait([first, second]);
      await settle(tester);

      expect(rig.spy.calls, [_studentId], reason: 'one consume, not two');
      expect(rig.location, _remembered, reason: 'not overridden by Home');
      expect(rig.exits, isEmpty);
    });

    testWidgets('OS Back and Continue in one frame leave once ($locale)', (
      tester,
    ) async {
      final rig = await pumpSuccess(tester, locale: locale);

      final back = tester.binding.handlePopRoute();
      await tester.tap(continueButton(locale));
      await back;
      await settle(tester);

      expect(rig.spy.calls, [_studentId]);
      expect(rig.location, _remembered);
    });

    testWidgets('two Continue taps in one frame leave once ($locale)', (
      tester,
    ) async {
      final rig = await pumpSuccess(tester, locale: locale);

      await tester.tap(continueButton(locale));
      await tester.tap(continueButton(locale));
      await settle(tester);

      expect(rig.spy.calls, [_studentId]);
      expect(rig.location, _remembered);
    });
  }

  testWidgets('before a code is accepted, OS Back still pops to Login', (
    tester,
  ) async {
    final rig = await pumpSuccess(tester, signedIn: false);

    await tester.binding.handlePopRoute();
    await settle(tester);

    expect(rig.location, '/login');
    expect(find.text('LOGIN FORM'), findsOneWidget);
    expect(rig.spy.calls, isEmpty, reason: 'nobody signed in');
    expect(rig.exits, isEmpty);
  });
}

/// The success badge, matched by ASSET: the screen carries other SVGs.
final _successBadge = find.byWidgetPredicate(
  (w) =>
      w is SvgPicture &&
      w.bytesLoader is SvgAssetLoader &&
      (w.bytesLoader as SvgAssetLoader).assetName ==
          'assets/images/success_badge.svg',
);

String _title(String locale) =>
    lookupAppLocalizations(Locale(locale)).otpSuccessTitle;
