import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
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
import 'package:pinput/pinput.dart';

/// OTP's three surfaces and its two CTAs · edit5 items #30, #31, #52 and
/// §7.11a.
///
/// Every number below is asserted against the `AppElevation` token AND against
/// the literal the Properties panel gave, for the reason edit1's own suite
/// gives: a test that only compares a widget to a token passes just as
/// happily when both are wrong.
class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

/// `resendAfterSeconds: 0` by default: anything above zero starts the
/// notifier's periodic ticker, and a widget test that ends with a live timer
/// fails on "pending timers" rather than on what it was asserting. The two
/// pill tests opt in to a countdown and then run it down to zero, which is
/// where the notifier cancels its own timer.
const _countdown = 21;

OtpArgs _argsWith(int resendAfterSeconds) => OtpArgs(
  phone: '+201021871999',
  resendAfterSeconds: resendAfterSeconds,
  expiresInSeconds: 300,
);
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _tokens = TokenPair(
  accessToken: 'access.jwt',
  accessExpiresInSeconds: 900,
  refreshToken: 'refresh.jwt',
  refreshExpiresInSeconds: 5184000,
);

/// `Color.fromRGBO(0, 0, 0, 0.25)`, not `Color(0x40000000)`: 0x40 is
/// 64/255 = 0.2510 and the palette's constant is 0.2500 exactly. The two are
/// not `==`, and the difference is invisible in a failure message.
const _black25 = Color.fromRGBO(0, 0, 0, 0.25);

void main() {
  setUpAll(() => registerFallbackValue(_device));

  late MockAuthRepository repo;
  late MockSecureStorage storage;

  setUp(() {
    repo = MockAuthRepository();
    storage = MockSecureStorage();
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Brightness brightness = Brightness.light,
    int resendAfterSeconds = 0,
    Locale locale = const Locale('en'),
  }) async {
    final container = makeContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: locale,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          // `MaterialApp` cross-fades a theme change over 200ms. Without this
          // a dark assertion made right after the pump reads LIGHT values
          // back, which looks exactly like a widget that ignores its canvas.
          themeAnimationDuration: Duration.zero,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OtpScreen(args: _argsWith(resendAfterSeconds)),
        ),
      ),
    );
    // `autofocus: true` resolves after the first frame, so without this the
    // first cell reads as unfocused and the resting-vs-focused assertions
    // below would all be measuring the same state.
    await tester.pump();
    return container;
  }

  /// Runs a countdown out so the notifier cancels its own periodic timer.
  /// Called at the END OF A TEST BODY, never from `addTearDown`: the binding
  /// asserts on pending timers before tearDowns run.
  Future<void> drain(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: _countdown));
    await tester.pump();
  }

  // The card is the only `ElevatedSurface` ABOVE the Pinput; the cells are the
  // only ones below it; the pill is the only stadium on the screen.
  ElevatedSurface cardOf(WidgetTester tester) => tester.widget<ElevatedSurface>(
    find.ancestor(
      of: find.byType(Pinput),
      matching: find.byType(ElevatedSurface),
    ),
  );

  Finder cellsFinder() => find.descendant(
    of: find.byType(Pinput),
    matching: find.byType(ElevatedSurface),
  );

  ElevatedSurface pillOf(WidgetTester tester) => tester.widget<ElevatedSurface>(
    find.byWidgetPredicate(
      (w) => w is ElevatedSurface && w.shape is StadiumBorder,
    ),
  );

  // -----------------------------------------------------------------------
  group('#30 the resend-timer pill', () {
    testWidgets('42 tall, 15 of padding, and a stadium', (tester) async {
      await pump(tester, resendAfterSeconds: _countdown);
      final pill = pillOf(tester);

      expect(pill.height, 42, reason: 'the build measured 36 off a screenshot');
      expect(
        pill.padding,
        const EdgeInsetsDirectional.symmetric(horizontal: 15),
        reason: 'the build measured 14',
      );
      expect(pill.shape, isA<StadiumBorder>());
      expect(pill.color, AppColors.light.otpTimerFill);
      expect(pill.color, const Color(0xFFFCFBF9), reason: '332:3391');
      await drain(tester);
    });

    // Which EDGE an inset lands on, measured off the rendered pill rather
    // than reasoned about (edit5.md §12, 2026-09-20). An inner shadow
    // behaves the way CSS's does: a NEGATIVE y puts the dark band along the
    // BOTTOM inside edge, not the top. Deltas from the page colour down the
    // pill's centre line: top -16, bottom **-37**; the two sides are -24 and
    // -24, symmetric because x is 0. A Pixel 8 reads -15 and -42 on the same
    // two edges, with no outer shadow on any of the four. `edit5.md` §12's checklist line calls
    // this "an inner top bevel", which its own §5 table (0, -1) contradicts;
    // the table is the Figma reading and the table is what is built.
    testWidgets('light: an INSET bevel along the BOTTOM edge, not a drop', (
      tester,
    ) async {
      await pump(tester, resendAfterSeconds: _countdown);
      final shadows = pillOf(tester).shadows;

      expect(shadows, AppElevation.light.otpTimerInsetShadows);
      expect(shadows, hasLength(1));
      expect(
        shadows.single.inset,
        isTrue,
        reason:
            'the build drew an OUTER shadow borrowed from the card frames; '
            '332:3391 draws an inner one (edit1.md R7)',
      );
      expect(shadows.single.color, _black25);
      expect(shadows.single.offset, const Offset(0, -1));
      expect(shadows.single.blur, 4);
      await drain(tester);
    });

    // Measured the same way, and in BOTH directions: +20 top / +19 right in
    // an LTR render, +30 top / +28 right on an RTL device (2026-09-20), +3 on
    // the other two edges either way. A negative x lands on the RIGHT edge
    // and a positive y on the TOP one, so (-0.5, 0.5) is a bevel in the
    // top-right corner - the opposite corner from the light canvas's, and
    // lighter instead of darker.
    //
    // RIGHT, not "end": the corner does not move in Arabic. Inset offsets are
    // physical, the same rule the drop shadows follow (edit1.md R9), and only
    // back-lights mirror.
    testWidgets('dark: a pale grey bevel in the TOP-RIGHT corner instead', (
      tester,
    ) async {
      await pump(
        tester,
        brightness: Brightness.dark,
        resendAfterSeconds: _countdown,
      );
      final pill = pillOf(tester);

      expect(pill.color, AppColors.dark.otpTimerFill);
      expect(pill.color, const Color(0xFF232428), reason: '337:19503');

      final shadow = pill.shadows.single;
      expect(shadow.inset, isTrue);
      expect(
        shadow.color,
        const Color.fromRGBO(198, 198, 198, 0.25),
        reason: 'the two canvases share NOTHING about this bevel',
      );
      expect(shadow.offset, const Offset(-0.5, 0.5));
      expect(shadow.blur, 1.2);
      expect(
        pill.glass,
        isNull,
        reason: 'the dark pill is opaque and elevates with the bevel alone',
      );
      await drain(tester);
    });
  });

  // -----------------------------------------------------------------------
  group('#31 the code card', () {
    testWidgets('r19, 15/10/15/15 padding, and the frame\'s fill', (
      tester,
    ) async {
      await pump(tester);
      final card = cardOf(tester);

      expect(
        card.shape,
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      );
      expect(
        card.padding,
        const EdgeInsetsDirectional.fromSTEB(10, 15, 10, 15),
        reason: 'read off `308:5114`; the build had no card at all',
      );
      expect(card.color, AppColors.light.otpCardFill);
      expect(card.color, const Color(0xFFFCFBF9));
    });

    testWidgets('it holds BOTH the digits and Verify — the whole finding', (
      tester,
    ) async {
      // `308:5114`'s variant has exactly two children, `Frame 427319511`
      // (320 x 61.01) and `Component 8` (334 x 60), and 15 + 61.01 + 20 + 60
      // + 15 is its hug height of 171.01 to the hundredth. The button being
      // inside is the reading this whole item turned on.
      await pump(tester);
      final card = find.ancestor(
        of: find.byType(Pinput),
        matching: find.byType(ElevatedSurface),
      );

      expect(
        find.descendant(of: card, matching: find.byType(PrimaryCta)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: card,
          matching: find.widgetWithText(FilledButton, 'Verify'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('light: the plain black drop', (tester) async {
      await pump(tester);
      final shadows = cardOf(tester).shadows;

      expect(shadows, AppElevation.light.otpCardShadows);
      expect(shadows.single.inset, isFalse);
      expect(shadows.single.color, _black25);
      expect(shadows.single.offset, const Offset(0.2, 0.2));
      expect(shadows.single.blur, 4);
    });

    testWidgets('dark: a LAVENDER glow, and it is the only one in the file', (
      tester,
    ) async {
      await pump(tester, brightness: Brightness.dark);
      final card = cardOf(tester);

      expect(card.color, AppColors.dark.otpCardFill);
      final glow = card.shadows.single;
      expect(glow.color, const Color.fromRGBO(174, 135, 231, 0.25));
      expect(
        [glow.color.r, glow.color.g, glow.color.b],
        isNot([0.0, 0.0, 0.0]),
        reason:
            'every other dark drop shadow in the file is black; this card is '
            'the documented exception (`337:19501`)',
      );
      expect(glow.offset, const Offset(0.2, 0.2));
      expect(glow.blur, 7.9, reason: 'nearly twice the light blur');
      expect(
        card.glass,
        isNull,
        reason: 'the card elevates in dark with the glow INSTEAD of Glass',
      );
    });
  });

  // -----------------------------------------------------------------------
  group('#52 the digit cells', () {
    testWidgets('six of them, still 48 x 56 at r16, still forced LTR', (
      tester,
    ) async {
      await pump(tester);

      expect(
        cellsFinder(),
        findsNWidgets(6),
        reason: 'the contract mandates 6 digits; Figma draws 4 (#5)',
      );
      final cell = tester.widget<ElevatedSurface>(cellsFinder().first);
      expect(cell.width, 48);
      expect(cell.height, 56);
      expect(
        cell.shape,
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

      // The boxes fill left-to-right whatever the UI locale does.
      final ltr = find.ancestor(
        of: find.byType(Pinput),
        matching: find.byType(Directionality),
      );
      expect(
        tester.widget<Directionality>(ltr.first).textDirection,
        TextDirection.ltr,
      );
    });

    // `edit5.md` §11.2 asks for this one in Arabic specifically, and the
    // assertion above does not cover it: the `Directionality` wrapper is the
    // MECHANISM, and reading it back under `en` proves only that the widget
    // tree contains the widget. An RTL page whose OTP boxes quietly filled
    // right-to-left would pass that and be wrong on the phone.
    testWidgets('in Arabic the page turns RTL and the cells still fill LEFT '
        'to right', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      // The page around it really is RTL — without this line the next one
      // proves nothing at all.
      expect(
        Directionality.of(tester.element(find.byType(OtpScreen))),
        TextDirection.rtl,
      );
      expect(
        Directionality.of(tester.element(find.byType(Pinput))),
        TextDirection.ltr,
      );

      expect(cellsFinder(), findsNWidgets(6));
      // Laid out, not just declared: cell 0 is the leftmost box on the
      // screen, which is what 'forced LTR' has to mean to be worth having.
      final lefts = [
        for (var i = 0; i < 6; i++) tester.getTopLeft(cellsFinder().at(i)).dx,
      ];
      for (var i = 1; i < 6; i++) {
        expect(
          lefts[i],
          greaterThan(lefts[i - 1]),
          reason: 'cell $i sits right of cell ${i - 1}, the same as in EN',
        );
      }
    });

    testWidgets('light: the 1.17333 hairline and no Glass', (tester) async {
      await pump(tester);
      // Cell 0 is the focused one under `autofocus: true`, so the resting
      // look is read off cell 1.
      final cell = tester.widget<ElevatedSurface>(cellsFinder().at(1));

      expect(cell.color, AppColors.light.otpDigitFill);
      expect(cell.color, const Color(0xFFFDFDFD));
      expect(cell.side!.color, AppColors.light.otpDigitBorder);
      expect(cell.side!.color, const Color(0xFFD1D1D1));
      expect(cell.side!.width, AppElevation.light.otpDigitBorderWidth);
      expect(cell.side!.width, 1.17333);
      expect(cell.glass, isNull);
    });

    testWidgets('dark: a 20% cell, a 0.5 hairline and G19', (tester) async {
      await pump(tester, brightness: Brightness.dark);
      final cell = tester.widget<ElevatedSurface>(cellsFinder().at(1));

      expect(cell.color, AppColors.dark.otpDigitFill);
      expect(
        cell.color!.a,
        closeTo(0.2, 0.005),
        reason: '`#232428` at 20% — the wash the Glass rim reads against',
      );
      expect(cell.side!.color, const Color(0xFFD1D1D1), reason: 'same in both');
      expect(cell.side!.width, 0.5, reason: 'not the light canvas\'s 1.17333');
      expect(cell.glass, AppElevation.dark.otpDigitGlass);
      expect(cell.glass!.frost, 56, reason: 'G19');
      expect(cell.glass!.depth, 100);
      expect(cell.glass!.dispersion, 0.65);
    });

    testWidgets('the focused cell keeps its 1.5 primary stroke', (
      tester,
    ) async {
      // This is now the ONLY "where am I typing" affordance: the blinking
      // caret went with `PinTheme` (owner ruling 2026-09-20, DESIGN_ISSUES
      // #49), because `Pinput.builder` hard-codes `showCursor = false`.
      await pump(tester);
      final focused = tester.widget<ElevatedSurface>(cellsFinder().first);
      final theme = AppTheme.light.colorScheme;

      expect(focused.side!.color, theme.primary);
      expect(focused.side!.width, 1.5);
    });

    testWidgets('an otp_invalid verify turns EVERY cell red', (tester) async {
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).thenThrow(const ApiException(status: 400, code: 'otp_invalid'));

      final container = await pump(tester);
      await container.read(otpProvider(_argsWith(0)).notifier).verify('000000');
      await tester.pump();

      final error = AppTheme.light.colorScheme.error;
      for (var i = 0; i < 6; i++) {
        final cell = tester.widget<ElevatedSurface>(cellsFinder().at(i));
        expect(cell.side!.color, error, reason: 'cell $i');
        expect(cell.side!.width, 1.5, reason: 'cell $i');
        expect(cell.color, error.withValues(alpha: 0.06), reason: 'cell $i');
      }
    });
  });

  // -----------------------------------------------------------------------
  group('§7.11a the two CTAs', () {
    testWidgets('Verify is wrapped, and DISABLED until six digits', (
      tester,
    ) async {
      await pump(tester);

      PrimaryCta verify() => tester.widget<PrimaryCta>(
        find.ancestor(
          of: find.widgetWithText(FilledButton, 'Verify'),
          matching: find.byType(PrimaryCta),
        ),
      );

      expect(verify().tone, CtaTone.primary);
      expect(
        verify().enabled,
        isFalse,
        reason: 'no digits entered — the halo dims with the button',
      );

      await tester.enterText(find.byType(Pinput), '482913');
      await tester.pump();
      expect(verify().enabled, isTrue);
    });

    testWidgets('the success screen\'s Continue is wrapped and enabled', (
      tester,
    ) async {
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).thenAnswer(
        (_) async =>
            const AuthResult.authenticated(tokens: _tokens, profile: {}),
      );

      final container = await pump(tester);
      await container.read(otpProvider(_argsWith(0)).notifier).verify('482913');
      await tester.pump();

      final cta = tester.widget<PrimaryCta>(
        find.ancestor(
          of: find.widgetWithText(FilledButton, 'Continue'),
          matching: find.byType(PrimaryCta),
        ),
      );
      expect(cta.tone, CtaTone.primary);
      expect(
        cta.enabled,
        isTrue,
        reason: 'the only way here is a stored session',
      );
    });
  });

  // -----------------------------------------------------------------------
  // The third surface named by `edit5.md` §12's text-scale line. Pumped at
  // the frame's own 402 with the countdown running, so the digit row, the
  // card, the Verify button AND the timer pill are all on screen at once -
  // the whole of what this wave changed here.
  group('the OTP screen at text scale 1.3', () {
    for (final locale in ['en', 'ar']) {
      testWidgets('nothing overflows in $locale', (tester) async {
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) => errors.add(details.toString());
        addTearDown(() => FlutterError.onError = previous);

        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.binding.setSurfaceSize(const Size(402, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await pump(
          tester,
          resendAfterSeconds: _countdown,
          locale: Locale(locale),
        );

        expect(cellsFinder(), findsNWidgets(6));
        expect(
          errors.where((e) => e.contains('overflowed')),
          isEmpty,
          reason: 'the six cells and the pill still fit at 1.3',
        );
        await drain(tester);
      });
    }
  });
}
