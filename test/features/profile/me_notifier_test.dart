import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/profile/models/entitlement_state.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';

/// The notifier layer: what Home actually branches on. The widget picks its
/// Offline view by inspecting the exception TYPE inside `AsyncError`, so these
/// assert the type survives `AsyncValue.guard` rather than being flattened.
///
/// Failures are stubbed as failed FUTURES, not synchronous throws:
/// `ProfileRepository` methods are `async`, so that is how a real failure
/// arrives. Error states are then read off the STATE after pumping the event
/// queue rather than by awaiting `.future` — the repo's existing convention
/// (see `school_search_notifier_test.dart`), since a rejected `.future` races
/// container teardown.

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  // AppLifecycleListener (used by EntitlementsNotifier for the resume refetch)
  // needs a binding.
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockProfileRepository repo;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [profileRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  void stubMeFails(Object error) => when(repo.getMe).thenAnswer(
        (_) => Future<StudentProfile>.error(error),
      );

  setUp(() => repo = _MockProfileRepository());

  group('meProvider', () {
    test('success → AsyncData carrying the profile verbatim', () async {
      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      final container = makeContainer();

      // Initial read is loading; the fetch resolves into data.
      expect(container.read(meProvider), isA<AsyncLoading<StudentProfile>>());
      final profile = await container.read(meProvider.future);

      expect(profile.name, 'Ahmed Mohamed');
      // Display-only values, untouched by the notifier.
      expect(profile.level, 8);
      expect(profile.points.total, 2450);
      expect(container.read(meProvider), isA<AsyncData<StudentProfile>>());
    });

    test('server error → AsyncError holding the ApiException', () async {
      stubMeFails(const ApiException(status: 500, code: 'internal_error'));
      final container = makeContainer();

      container.listen(meProvider, (_, _) {});
      await pumpEventQueue();

      final state = container.read(meProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<ApiException>());
    });

    test('offline → AsyncError whose error is still recognisably offline',
        () async {
      // Home reads this exact signal to render the Offline view instead of the
      // generic error view.
      stubMeFails(const OfflineException());
      final container = makeContainer();

      container.listen(meProvider, (_, _) {});
      await pumpEventQueue();

      expect(isOffline(container.read(meProvider).error), isTrue);
    });

    test('refresh() re-calls the repository and replaces the error with data',
        () async {
      stubMeFails(const OfflineException());
      final container = makeContainer();
      container.listen(meProvider, (_, _) {});
      await pumpEventQueue();
      expect(container.read(meProvider).hasError, isTrue);

      // Connectivity comes back and the student taps Retry.
      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      await container.read(meProvider.notifier).refresh();

      expect(container.read(meProvider).value?.name, 'Ahmed Mohamed');
      verify(repo.getMe).called(2);
    });

    test('no silent auto-retry — one failed build makes exactly one call',
        () async {
      stubMeFails(const OfflineException());
      final container = makeContainer();

      container.listen(meProvider, (_, _) {});
      await pumpEventQueue();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      verify(repo.getMe).called(1);
    });
  });

  group('entitlementsProvider', () {
    test('success → the unwrapped item list', () async {
      when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
      final container = makeContainer();

      final items = await container.read(entitlementsProvider.future);

      expect(items.single.type, EntitlementType.baseSubscription);
      expect(items.single.active, isTrue);
    });

    test('offline → AsyncError, and the profile call is unaffected', () async {
      when(repo.getEntitlements).thenAnswer(
        (_) => Future<List<EntitlementState>>.error(const OfflineException()),
      );
      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      final container = makeContainer();

      container.listen(entitlementsProvider, (_, _) {});
      await pumpEventQueue();

      expect(isOffline(container.read(entitlementsProvider).error), isTrue);
      // A failed paywall check must not take the whole screen down: Home
      // renders from meProvider alone.
      expect((await container.read(meProvider.future)).level, 8);
    });

    test('refresh() keeps the previous value on screen while re-fetching',
        () async {
      when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
      final container = makeContainer();
      await container.read(entitlementsProvider.future);

      when(repo.getEntitlements).thenAnswer(
        (_) async => [
          const EntitlementState(
            type: EntitlementType.baseSubscription,
            active: false,
            inGrace: true,
          ),
        ],
      );
      await container.read(entitlementsProvider.notifier).refresh();

      // Never blanked to AsyncLoading in between — this runs unprompted on
      // resume, and a flicker the student didn't ask for is a bug.
      final state = container.read(entitlementsProvider);
      expect(state, isA<AsyncData<List<EntitlementState>>>());
      expect(state.value!.single.inGrace, isTrue);
    });
  });
}
