import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/notifier/login_notifier.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

/// Send OTP sends ONE request at a time, whatever reaches it (wave R2b, E1).
///
/// The screen disables the button while a request is out, but that only takes
/// hold on the NEXT frame. Two taps delivered in the same frame - input queued
/// behind a janky frame on a low-end handset, assistive tap automation - both
/// reached `LoginNotifier.sendOtp`, and each sent an SMS. The notifier is the
/// guard now, as `EditProfileNotifier.save` is for Save; the disabled button is
/// the cue.
class _MockAuthRepository extends Mock implements AuthRepository {}

const _phone = '+2010000000001';
const _result = OtpRequestResult(resendAfterSeconds: 60, expiresInSeconds: 300);

void main() {
  group('LoginNotifier.sendOtp', () {
    late _MockAuthRepository repo;
    late ProviderContainer container;

    setUp(() {
      repo = _MockAuthRepository();
      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
    });

    test(
      'a second call while one is in flight sends nothing and says so',
      () async {
        await container.read(loginProvider.future);
        final gate = Completer<OtpRequestResult>();
        when(() => repo.requestOtp(any())).thenAnswer((_) => gate.future);
        final notifier = container.read(loginProvider.notifier);

        final first = notifier.sendOtp(_phone);
        final second = notifier.sendOtp(_phone);

        expect(await second, isNull, reason: 'nothing to navigate on');
        verify(() => repo.requestOtp(any())).called(1);
        expect(container.read(loginProvider).isLoading, isTrue);

        gate.complete(_result);
        expect(await first, _result);
        expect(container.read(loginProvider).value, _result);
        verifyNoMoreInteractions(repo);
      },
    );

    test('once the first has answered, the next call sends again', () async {
      await container.read(loginProvider.future);
      when(() => repo.requestOtp(any())).thenAnswer((_) async => _result);
      final notifier = container.read(loginProvider.notifier);

      expect(await notifier.sendOtp(_phone), _result);
      expect(await notifier.sendOtp(_phone), _result);

      verify(() => repo.requestOtp(any())).called(2);
    });

    test('a failed request does not wedge the guard', () async {
      await container.read(loginProvider.future);
      var calls = 0;
      when(() => repo.requestOtp(any())).thenAnswer((_) async {
        calls++;
        if (calls == 1) throw StateError('network down');
        return _result;
      });
      final notifier = container.read(loginProvider.notifier);

      expect(await notifier.sendOtp(_phone), isNull);
      expect(container.read(loginProvider).hasError, isTrue);
      expect(await notifier.sendOtp(_phone), _result, reason: 'retry is open');
    });
  });

  group('the Login screen', () {
    Future<void> pumpLogin(
      WidgetTester tester,
      _MockAuthRepository repo,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(repo),
            isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: GoRouter(
              initialLocation: '/login',
              routes: [
                GoRoute(
                  path: '/login',
                  builder: (_, _) => const LoginScreen(),
                  routes: [
                    GoRoute(
                      path: 'otp',
                      builder: (_, _) => const Scaffold(
                        body: Center(child: Text('OTP SCREEN')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('two taps in the same frame request ONE code', (tester) async {
      final repo = _MockAuthRepository();
      final gate = Completer<OtpRequestResult>();
      when(() => repo.requestOtp(any())).thenAnswer((_) => gate.future);
      await pumpLogin(tester, repo);
      await tester.enterText(find.byType(TextField), '010000000001');
      await tester.pumpAndSettle();

      // The same spot twice with NO frame between: the button has not been
      // rebuilt as a spinner yet, so only the notifier can refuse the second.
      final spot = tester.getCenter(
        find.widgetWithText(FilledButton, 'Send OTP'),
      );
      await tester.tapAt(spot);
      await tester.tapAt(spot);

      verify(() => repo.requestOtp(_phone)).called(1);

      gate.complete(_result);
      await tester.pumpAndSettle();
      expect(find.text('OTP SCREEN'), findsOneWidget);
      verifyNoMoreInteractions(repo);
    });

    testWidgets(
      'one tap a frame later is still one (the button is a spinner)',
      (tester) async {
        final repo = _MockAuthRepository();
        final gate = Completer<OtpRequestResult>();
        when(() => repo.requestOtp(any())).thenAnswer((_) => gate.future);
        await pumpLogin(tester, repo);
        await tester.enterText(find.byType(TextField), '010000000001');
        await tester.pumpAndSettle();

        final spot = tester.getCenter(
          find.widgetWithText(FilledButton, 'Send OTP'),
        );
        await tester.tapAt(spot);
        await tester.pump(const Duration(milliseconds: 16));
        await tester.tapAt(spot);

        verify(() => repo.requestOtp(_phone)).called(1);
        gate.complete(_result);
        await tester.pumpAndSettle();
      },
    );
  });
}
