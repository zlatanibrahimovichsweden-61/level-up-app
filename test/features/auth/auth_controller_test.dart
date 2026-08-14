import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements SecureStorage {}

class _MockAuthRepository extends Mock implements AuthRepository {}

ProviderContainer _container(
  _MockStorage storage, {
  _MockAuthRepository? repo,
}) {
  final container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(storage),
      if (repo != null) authRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late _MockStorage storage;

  setUp(() {
    storage = _MockStorage();
    when(() => storage.clearTokens()).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
  });

  test('app start with no token → unauthenticated', () async {
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    final container = _container(storage);

    expect(container.read(authControllerProvider), isA<AuthUnknown>());
    await Future<void>.delayed(Duration.zero); // _resolveInitial settles
    expect(container.read(authControllerProvider), isA<AuthUnauthenticated>());
  });

  test('app start with a token → authenticated', () async {
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    final container = _container(storage);

    expect(
      container.read(authControllerProvider),
      isA<AuthUnknown>(),
    ); // builds
    await Future<void>.delayed(Duration.zero); // _resolveInitial settles
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  test(
    'forceLogout uses clearTokens (device_id preserved), NOT clear()',
    () async {
      when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
      final container = _container(storage);
      final controller = container.read(authControllerProvider.notifier);

      await controller.forceLogout(LogoutReason.supersededOtherDevice);

      verify(() => storage.clearTokens()).called(1);
      verifyNever(() => storage.clear());
      final status =
          container.read(authControllerProvider) as AuthUnauthenticated;
      expect(status.reason, LogoutReason.supersededOtherDevice);
    },
  );

  test(
    'logout swallows a failing server call and clears tokens anyway',
    () async {
      when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
      final repo = _MockAuthRepository();
      when(
        () => repo.logout(),
      ).thenThrow(const UnauthorizedException(code: 'authentication_required'));
      final container = _container(storage, repo: repo);
      final controller = container.read(authControllerProvider.notifier);

      await controller.logout();

      verify(() => storage.clearTokens()).called(1);
      final status =
          container.read(authControllerProvider) as AuthUnauthenticated;
      expect(status.reason, LogoutReason.userInitiated);
    },
  );

  test('clearReason drops the reason but stays unauthenticated', () async {
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    final container = _container(storage);
    final controller = container.read(authControllerProvider.notifier);

    await controller.forceLogout(LogoutReason.sessionExpired);
    controller.clearReason();

    final status =
        container.read(authControllerProvider) as AuthUnauthenticated;
    expect(status.reason, isNull);
  });
}
