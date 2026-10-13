import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/mistakes/models/mistakes_subject.dart';
import 'package:level_up_app/features/mistakes/notifier/mistakes_notifiers.dart';
import 'package:level_up_app/features/mistakes/repository/mistakes_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../features/mistakes/mistakes_fixtures.dart';

class _MockMistakesRepository extends Mock implements MistakesRepository {}

/// The Mistakes overview as a SESSION-scoped provider (E4-05).
///
/// It holds a named minor's per-subject wrong-answer counts. As a plain
/// provider `invalidateSessionScope` only rebuilt it (Riverpod 3 never disposes
/// an invalidated element that still has a listener), keeping the previous
/// value through the rebuild, so the next student on the handset read those
/// counts until their own request landed. It is autoDispose now: the sign-out
/// unmounts the shell and the last listener leaving drops it. A mounted screen
/// (the overview stays mounted below the tree screens) keeps it warm.
void main() {
  late _MockMistakesRepository repo;

  setUp(() => repo = _MockMistakesRepository());

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [mistakesRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('warm while a screen listens, gone with the last listener', () async {
    when(repo.getMistakes).thenAnswer((_) async => mistakesOverview());
    final container = makeContainer();
    final screen = container.listen(mistakesOverviewProvider, (_, _) {});
    expect(await container.read(mistakesOverviewProvider.future), hasLength(3));

    // The drill-down: tree screens push above the overview, which stays
    // mounted, so nothing is re-fetched.
    await pumpEventQueue();
    container.read(mistakesOverviewProvider);
    verify(repo.getMistakes).called(1);
    expect(container.exists(mistakesOverviewProvider), isTrue);

    screen.close();
    await pumpEventQueue();
    expect(container.exists(mistakesOverviewProvider), isFalse);
  });

  test('a new listener after the old one went starts from LOADING with no '
      'value (never the earlier student\'s counts)', () async {
    when(repo.getMistakes).thenAnswer((_) async => mistakesOverview());
    final container = makeContainer();
    final first = container.listen(mistakesOverviewProvider, (_, _) {});
    await container.read(mistakesOverviewProvider.future);
    first.close();
    await pumpEventQueue();

    final gate = Completer<List<MistakesSubject>>();
    when(repo.getMistakes).thenAnswer((_) => gate.future);
    container.listen(mistakesOverviewProvider, (_, _) {});

    final state = container.read(mistakesOverviewProvider);
    expect(state.isLoading, isTrue);
    expect(state.hasValue, isFalse);
    gate.complete(<MistakesSubject>[]);
    expect(await container.read(mistakesOverviewProvider.future), isEmpty);
  });

  test('a Retry still in flight when the provider is disposed raises no '
      'unhandled error', () async {
    when(repo.getMistakes).thenAnswer((_) async => mistakesOverview());
    final container = makeContainer();
    final screen = container.listen(mistakesOverviewProvider, (_, _) {});
    await container.read(mistakesOverviewProvider.future);

    final gate = Completer<List<MistakesSubject>>();
    when(repo.getMistakes).thenAnswer((_) => gate.future);
    final retry = container.read(mistakesOverviewProvider.notifier).refresh();
    screen.close(); // the session ended under the Retry
    await pumpEventQueue();
    expect(container.exists(mistakesOverviewProvider), isFalse);

    gate.complete(<MistakesSubject>[]);
    await retry; // writing to the dead notifier would throw here
  });

  test('a Retry still lands after the provider was rebuilt in use', () async {
    // Riverpod 3 keeps the notifier instance across a rebuild and runs its
    // dispose callbacks, so a disposal flag left set would swallow the next
    // Retry and leave the screen on its skeleton.
    when(repo.getMistakes).thenAnswer((_) async => mistakesOverview());
    final container = makeContainer();
    container.listen(mistakesOverviewProvider, (_, _) {});
    await container.read(mistakesOverviewProvider.future);

    container.invalidate(mistakesOverviewProvider);
    await container.read(mistakesOverviewProvider.future);

    when(repo.getMistakes).thenAnswer((_) async => <MistakesSubject>[]);
    await container.read(mistakesOverviewProvider.notifier).refresh();

    expect(container.read(mistakesOverviewProvider).value, isEmpty);
  });
}
