import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/features/auth/auth_error_copy.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/notifier/otp_notifier.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

/// CW02 slice B — `403 account_banned` on `verifyOtp`.
///
/// The contract (`contract/error-codes.md:51`, `openapi.yaml:231`) returns it
/// only AFTER a correct code: the code is consumed and no tokens or session are
/// issued; the client rule is "do not retry; route to Support". Owner ruling:
/// show the contract's suggested copy inline in the OTP screen's existing error
/// line, lock entry and resend, and offer the existing "Back to login".
///
/// The copy strings below are the contract's own (the client owns the strings;
/// the em dash is part of them), asserted literally so a translation edit that
/// drifts from them fails here.

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

const _bannedEn = 'Account banned — contact Support';
const _bannedAr = 'تم حظر الحساب — تواصل مع الدعم';

// resendAfterSeconds: 0 → the Resend control is live before the ban, which is
// what makes "no resend afterwards" a real assertion; and no timer is pending.
const _args = OtpArgs(
  phone: '+2010000000001',
  resendAfterSeconds: 0,
  expiresInSeconds: 300,
);
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _banned = ApiException(status: 403, code: 'account_banned');

/// An [OtpNotifier] that starts [banned] (the default) or not, and whose
/// `verify` only records the call — it has no banned check of its own, unlike
/// the real one. That is the point: with the notifier's guard gone from the
/// picture, whether a completed code reaches `verify` is decided by the screen
/// alone. The not-banned variant is the positive control: it shows the same
/// programmatic change DOES reach `verify` when nothing is banned.
class _BannedRecorder extends OtpNotifier {
  _BannedRecorder(super.args, this.calls, {this.banned = true});

  /// One entry per `verify` call that got through.
  final List<String> calls;

  final bool banned;

  @override
  OtpUiState build() => OtpUiState(secondsRemaining: 0, isBanned: banned);

  @override
  Future<void> verify(String code) async => calls.add(code);
}

void main() {
  setUpAll(() => registerFallbackValue(_device));

  late _MockAuthRepository repo;
  late _MockSecureStorage storage;

  setUp(() {
    repo = _MockAuthRepository();
    storage = _MockSecureStorage();
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
    ).thenThrow(_banned);
    when(() => repo.requestOtp(any())).thenAnswer(
      (_) async =>
          const OtpRequestResult(resendAfterSeconds: 0, expiresInSeconds: 300),
    );
  });

  ProviderContainer makeContainer({
    bool disposeInTearDown = true,
    List<Override> extraOverrides = const [],
  }) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        ...extraOverrides,
      ],
    );
    if (disposeInTearDown) addTearDown(container.dispose);
    return container;
  }

  void verifyNoTokenWrite() => verifyNever(
    () => storage.writeTokens(
      access: any(named: 'access'),
      refresh: any(named: 'refresh'),
    ),
  );

  group('isAccountBanned / authErrorMessage', () {
    test('the predicate matches the code, and only the code', () {
      expect(isAccountBanned(_banned), isTrue);
      expect(
        isAccountBanned(const ApiException(status: 400, code: 'otp_invalid')),
        isFalse,
      );
      expect(
        isAccountBanned(
          const ApiException(status: 403, code: 'account_pending_deletion'),
        ),
        isFalse,
      );
      expect(isAccountBanned(const NetworkException()), isFalse);
      expect(isAccountBanned(null), isFalse);
    });

    test('authErrorMessage returns the contract copy, EN and AR', () {
      expect(
        authErrorMessage(lookupAppLocalizations(const Locale('en')), _banned),
        _bannedEn,
      );
      expect(
        authErrorMessage(lookupAppLocalizations(const Locale('ar')), _banned),
        _bannedAr,
      );
    });

    test('it is NOT the red-box code (no otp_invalid styling)', () {
      expect(isInvalidOtp(_banned), isFalse);
    });
  });

  group('OtpNotifier', () {
    test(
      'a banned verify writes no tokens and never signs the student in',
      () async {
        final container = makeContainer();
        final statuses = <AuthStatus>[];
        container.listen(
          authControllerProvider,
          (_, next) => statuses.add(next),
          fireImmediately: true,
        );
        container.listen(otpProvider(_args), (_, _) {});

        await container.read(otpProvider(_args).notifier).verify('482913');
        // Let AuthController's async initial token read settle too.
        await Future<void>.delayed(Duration.zero);

        final state = container.read(otpProvider(_args));
        expect(state.isBanned, isTrue);
        expect(state.isInvalidCode, isFalse);
        expect(state.isVerifying, isFalse);
        expect(state.outcome, isNull);
        expect(isAccountBanned(state.error), isTrue);

        verifyNoTokenWrite();
        expect(statuses, isNotEmpty);
        expect(statuses.whereType<AuthAuthenticated>(), isEmpty);
        expect(
          container.read(authControllerProvider),
          isNot(isA<AuthAuthenticated>()),
        );
      },
    );

    test('a second verify and a resend make NO repository call; '
        'canResend is false', () async {
      final container = makeContainer();
      container.listen(otpProvider(_args), (_, _) {});
      final notifier = container.read(otpProvider(_args).notifier);

      // Before the ban the countdown is 0, so Resend would be live.
      expect(container.read(otpProvider(_args)).canResend, isTrue);

      await notifier.verify('482913');
      expect(container.read(otpProvider(_args)).isBanned, isTrue);
      expect(container.read(otpProvider(_args)).canResend, isFalse);

      await notifier.verify('111111');
      await notifier.resend();

      verify(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).called(1);
      verifyNever(() => repo.requestOtp(any()));
      // …and the banned state, with its error, survived both calls.
      final state = container.read(otpProvider(_args));
      expect(state.isBanned, isTrue);
      expect(isAccountBanned(state.error), isTrue);
      expect(state.isResending, isFalse);
    });

    test('a resend answer that lands AFTER the ban cannot restart the '
        'countdown or replace the banned error', () async {
      final container = makeContainer();
      container.listen(otpProvider(_args), (_, _) {});
      final notifier = container.read(otpProvider(_args).notifier);

      final inFlight = Completer<OtpRequestResult>();
      when(() => repo.requestOtp(any())).thenAnswer((_) => inFlight.future);

      final resending = notifier.resend(); // spinner up, request in flight
      expect(container.read(otpProvider(_args)).isResending, isTrue);

      await notifier.verify('482913'); // Verify is not disabled by the spinner
      expect(container.read(otpProvider(_args)).isBanned, isTrue);

      inFlight.complete(
        const OtpRequestResult(resendAfterSeconds: 30, expiresInSeconds: 300),
      );
      await resending;

      final state = container.read(otpProvider(_args));
      expect(state.isResending, isFalse);
      expect(state.isBanned, isTrue);
      expect(state.secondsRemaining, 0, reason: 'the 30 s must not be applied');
      expect(isAccountBanned(state.error), isTrue);
    });

    testWidgets('entering the banned state stops the resend countdown', (
      tester,
    ) async {
      const counting = OtpArgs(
        phone: '+2010000000001',
        resendAfterSeconds: 30,
        expiresInSeconds: 300,
      );
      // Disposed at the END OF THE BODY: the framework checks for pending
      // timers before tearDowns run.
      final container = makeContainer(disposeInTearDown: false);
      container.listen(otpProvider(counting), (_, _) {});

      await tester.pump(const Duration(seconds: 2));
      expect(container.read(otpProvider(counting)).secondsRemaining, 28);

      await container.read(otpProvider(counting).notifier).verify('482913');
      final atBan = container.read(otpProvider(counting)).secondsRemaining;
      expect(container.read(otpProvider(counting)).isBanned, isTrue);

      await tester.pump(const Duration(seconds: 5));
      expect(
        container.read(otpProvider(counting)).secondsRemaining,
        atBan,
        reason: 'the periodic timer must be cancelled once banned',
      );
      container.dispose();
    });
  });

  group('OtpScreen (real router)', () {
    const cases = <({String code, String copy, TextDirection dir})>[
      (code: 'en', copy: _bannedEn, dir: TextDirection.ltr),
      (code: 'ar', copy: _bannedAr, dir: TextDirection.rtl),
    ];

    for (final c in cases) {
      testWidgets(
        '${c.code}: banned → contract copy inline, entry + resend locked, '
        '"Back to login" lands on /login, never the success view',
        (tester) async {
          final semantics = tester.ensureSemantics();
          final l10n = lookupAppLocalizations(Locale(c.code));
          final container = makeContainer();
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp.router(
                locale: Locale(c.code),
                theme: AppTheme.light,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: container.read(routerProvider),
              ),
            ),
          );
          await tester.pumpAndSettle();

          Future<void> pumpFrames() async {
            for (var i = 0; i < 10; i++) {
              await tester.pump(const Duration(milliseconds: 100));
            }
          }

          String location() =>
              container.read(routerProvider).state.uri.toString();

          // Login → OTP exactly as LoginScreen does it (nested `go` + extra).
          container.read(routerProvider).go('/login/otp', extra: _args);
          await pumpFrames();
          expect(find.byType(OtpScreen), findsOneWidget);
          expect(
            Directionality.of(tester.element(find.byType(OtpScreen))),
            c.dir,
          );

          // Before the ban: Verify + Resend are there, no banned copy.
          expect(
            find.widgetWithText(FilledButton, l10n.verify),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(TextButton, l10n.resendOtp),
            findsOneWidget,
          );
          expect(find.text(c.copy), findsNothing);
          expect(
            find.widgetWithText(FilledButton, l10n.backToLogin),
            findsNothing,
          );
          expect(tester.widget<Pinput>(find.byType(Pinput)).enabled, isTrue);

          // The correct code → 403 account_banned.
          await tester.enterText(find.byType(Pinput), '482913');
          await pumpFrames();

          // The contract copy, in the one error line (readable by a screen
          // reader like every other error line on this screen).
          expect(find.text(c.copy), findsOneWidget);
          expect(find.bySemanticsLabel(c.copy), findsOneWidget);
          // …and announced when it appears: nothing else tells a screen-reader
          // user that the cells just locked for good.
          expect(
            tester.getSemantics(find.text(c.copy)).flagsCollection.isLiveRegion,
            isTrue,
            reason: 'the banned line must be a live region',
          );

          // Code entry is locked.
          final pinput = tester.widget<Pinput>(find.byType(Pinput));
          expect(pinput.enabled, isFalse);
          expect(pinput.focusNode!.canRequestFocus, isFalse);
          expect(pinput.focusNode!.hasFocus, isFalse);
          final editable = tester.widget<EditableText>(
            find.descendant(
              of: find.byType(Pinput),
              matching: find.byType(EditableText),
            ),
          );
          expect(editable.readOnly, isTrue);

          // Resend is gone; Verify is replaced by the existing primary CTA.
          expect(find.byType(TextButton), findsNothing);
          expect(find.text(l10n.resendOtp), findsNothing);
          expect(find.text(l10n.verify), findsNothing);
          final back = find.descendant(
            of: find.byType(PrimaryCta),
            matching: find.widgetWithText(FilledButton, l10n.backToLogin),
          );
          expect(back, findsOneWidget);
          expect(tester.widget<FilledButton>(back).onPressed, isNotNull);

          // No success view, no session.
          expect(find.text(l10n.otpSuccessTitle), findsNothing);
          expect(find.text(l10n.continueLabel), findsNothing);
          expect(
            container.read(authControllerProvider),
            isNot(isA<AuthAuthenticated>()),
          );
          verifyNoTokenWrite();

          // A fresh 6-digit value fires Pinput's onCompleted even while
          // disabled (programmatic change) — the auto-submit path must stay
          // shut. Either guard alone makes this pass — the screen's guard in
          // `_OtpScreenState._verify` returns first and the notifier's is never
          // reached while it is present — so this cannot tell which of the two
          // is there. The screen guard is pinned in isolation by "the SCREEN
          // guard alone…" below.
          pinput.controller!.text = '654321';
          await pumpFrames();
          verify(
            () => repo.verifyOtp(
              phone: any(named: 'phone'),
              code: any(named: 'code'),
              device: any(named: 'device'),
            ),
          ).called(1);
          expect(find.text(c.copy), findsOneWidget);

          // "Back to login" → /login (router state, not currentConfiguration).
          await tester.tap(back);
          await tester.pumpAndSettle();
          expect(location(), '/login');
          expect(find.byType(LoginScreen), findsOneWidget);
          expect(find.byType(OtpScreen), findsNothing);
          expect(find.text(l10n.otpSuccessTitle), findsNothing);
          verifyNoTokenWrite();
          expect(
            container.read(authControllerProvider),
            isNot(isA<AuthAuthenticated>()),
          );

          semantics.dispose();
        },
      );
    }

    testWidgets('the DARK theme renders the banned state without exceptions, '
        'with the same copy and controls', (tester) async {
      final l10n = lookupAppLocalizations(const Locale('en'));
      final container = makeContainer();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('en'),
            theme: AppTheme.dark,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: container.read(routerProvider),
          ),
        ),
      );
      await tester.pumpAndSettle();
      container.read(routerProvider).go('/login/otp', extra: _args);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(OtpScreen), findsOneWidget);
      expect(
        Theme.of(tester.element(find.byType(OtpScreen))).brightness,
        Brightness.dark,
      );

      await tester.enterText(find.byType(Pinput), '482913');
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(tester.takeException(), isNull);
      // The same copy and controls as the light theme.
      expect(find.text(_bannedEn), findsOneWidget);
      expect(tester.widget<Pinput>(find.byType(Pinput)).enabled, isFalse);
      expect(find.byType(TextButton), findsNothing);
      expect(find.text(l10n.resendOtp), findsNothing);
      expect(find.text(l10n.verify), findsNothing);
      expect(
        find.descendant(
          of: find.byType(PrimaryCta),
          matching: find.widgetWithText(FilledButton, l10n.backToLogin),
        ),
        findsOneWidget,
      );
    });

    /// The real OtpScreen over a [_BannedRecorder], opened as Login does it.
    Future<({ProviderContainer container, List<String> calls})> pumpRecorder(
      WidgetTester tester, {
      required bool banned,
    }) async {
      final calls = <String>[];
      final container = makeContainer(
        extraOverrides: [
          otpProvider.overrideWith2(
            (args) => _BannedRecorder(args, calls, banned: banned),
          ),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('en'),
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: container.read(routerProvider),
          ),
        ),
      );
      await tester.pumpAndSettle();
      container.read(routerProvider).go('/login/otp', extra: _args);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(OtpScreen), findsOneWidget);
      return (container: container, calls: calls);
    }

    testWidgets('the SCREEN guard alone keeps a completed code from reaching '
        'verify once banned (the notifier has no guard here)', (tester) async {
      // pinput 6.0.2 fires `onCompleted` on any controller text change, enabled
      // or not, so a programmatic 6-digit value reaches `_OtpScreenState._verify`
      // on a banned screen. With the real notifier its own guard no-ops first
      // and hides whether the screen's guard still exists; this notifier has
      // none, so a call that gets through is recorded. The positive control
      // below is what makes "recorded nothing" mean something.
      final (:container, :calls) = await pumpRecorder(tester, banned: true);
      expect(container.read(otpProvider(_args)).isBanned, isTrue);
      final pinput = tester.widget<Pinput>(find.byType(Pinput));
      expect(pinput.enabled, isFalse);

      pinput.controller!.text = '654321';
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(
        calls,
        isEmpty,
        reason: 'a banned screen must not hand a completed code to verify',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'positive control for the SCREEN-guard test: the same recorder, '
      'NOT banned, DOES receive the programmatic code',
      (tester) async {
        // Proves the programmatic change reaches `_verify` at this pinput
        // version, so the banned run above is a real isolation of the screen
        // guard rather than a change that never arrives.
        final (:container, :calls) = await pumpRecorder(tester, banned: false);
        expect(container.read(otpProvider(_args)).isBanned, isFalse);
        final pinput = tester.widget<Pinput>(find.byType(Pinput));
        expect(pinput.enabled, isTrue);

        pinput.controller!.text = '654321';
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        expect(calls, ['654321']);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('a wrong code is NOT the banned state (still red-box copy, '
        'Verify + Resend stay)', (tester) async {
      final semantics = tester.ensureSemantics();
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).thenThrow(const ApiException(status: 400, code: 'otp_invalid'));
      final l10n = lookupAppLocalizations(const Locale('en'));
      final container = makeContainer();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('en'),
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: container.read(routerProvider),
          ),
        ),
      );
      await tester.pumpAndSettle();
      container.read(routerProvider).go('/login/otp', extra: _args);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.enterText(find.byType(Pinput), '482913');
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text(l10n.errorOtpInvalid), findsOneWidget);
      // Only the banned line is a live region; this one is unchanged.
      expect(
        tester
            .getSemantics(find.text(l10n.errorOtpInvalid))
            .flagsCollection
            .isLiveRegion,
        isFalse,
      );
      expect(find.text(_bannedEn), findsNothing);
      expect(find.widgetWithText(FilledButton, l10n.verify), findsOneWidget);
      expect(find.widgetWithText(TextButton, l10n.resendOtp), findsOneWidget);
      expect(find.widgetWithText(FilledButton, l10n.backToLogin), findsNothing);
      expect(tester.widget<Pinput>(find.byType(Pinput)).enabled, isTrue);
      semantics.dispose();
    });
  });
}
