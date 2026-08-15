import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The standing rule that came out of Tier-0 finding C-2 — *"every provider
/// that can hold one student's data is either cleared on sign-out or is
/// explicitly and defensibly not session-scoped"* — as a test rather than a
/// review habit somebody has to remember.
///
/// It exists because C-2 was not a coding mistake. `meProvider` was deliberately
/// non-`autoDispose` for a good reason (tab switches must not re-flash a
/// skeleton), and the sign-out path was written before it existed. Nothing
/// connected the two, so the leak arrived by addition rather than by error —
/// and that is exactly the shape that recurs the moment a twelfth feature adds
/// a thirteenth notifier.
///
/// The check is deliberately shallow: it reads source, matches provider
/// declarations, and asserts each non-`autoDispose` stateful provider is named
/// somewhere in `session_scope.dart` or in the exemption list below. It cannot
/// tell whether a provider *should* be session-scoped — only that somebody made
/// the call and wrote it down.
void main() {
  /// Providers that hold state but are deliberately NOT cleared on sign-out.
  /// Adding to this list is a decision; the comment beside each is the record.
  const notSessionScoped = <String, String>{
    'authControllerProvider':
        'This IS the auth state. invalidateSessionScope runs from inside it; '
        'invalidating it mid-logout would tear down the notifier that is '
        'mid-teardown.',
    'localeProvider':
        'Device preference, persisted on purpose. Language survives a sign-out.',
    'themeModeProvider':
        'Device preference, persisted on purpose. preferences_store.dart: '
        '"a theme choice is not a secret, is not personal data".',
    'isOnlineProvider':
        'Global connectivity. Nothing to do with who signed in.',
    'deviceInfoProvider':
        'Device identity. forceLogout goes out of its way to preserve the '
        'device_id (Decisions_Log 2026-07-23) — clearing this would make the '
        'next login look like a new device and mis-fire session_superseded.',
    'countriesProvider': 'Global reference data — same for every student.',
    'governoratesProvider': 'Global reference data — same for every student.',
    'citiesProvider': 'Global reference data — same for every student.',
    'schoolsProvider': 'Global reference data — same for every student.',
    'educationSystemsProvider':
        'Global reference data — same for every student.',
    'universitiesProvider': 'Global reference data — same for every student.',
    'avatarsProvider': 'Global reference data — same for every student.',
  };

  /// Provider kinds that carry state worth clearing. Plain `Provider<T>` is
  /// stateless dependency injection (repositories, Dio, storage) and is not
  /// scanned.
  final statefulKind = RegExp(
    r'NotifierProvider|FutureProvider|StreamProvider',
  );

  /// `final xProvider = <everything up to the first semicolon>`.
  ///
  /// Known limitation, stated rather than hidden: a declaration carrying an
  /// explicit left-hand type (`final Provider<Dio> dioProvider = …`) does not
  /// match. Both current cases are plain `Provider<T>` DI roots, which this
  /// test does not want anyway — but a future *stateful* provider written that
  /// way would slip past.
  final declaration = RegExp(
    r'final\s+(\w+Provider)\s*=\s*([^;]+);',
    dotAll: true,
  );

  List<File> libSources() => Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.endsWith('.g.dart'))
      .where((f) => !f.path.endsWith('.freezed.dart'))
      .toList();

  /// Dart comments stripped, so a provider NAMED in prose is never mistaken for
  /// one that is actually cleared.
  ///
  /// This is not hypothetical tidiness. The first version of this test asked
  /// `scope.contains(name)`, and `session_scope.dart` names
  /// `authControllerProvider`, `localeProvider`, `themeModeProvider` and
  /// `deviceInfoProvider` in its "deliberately NOT here" doc comment — so the
  /// guard reported all four as cleared when none of them is. It happened to
  /// reach the right verdict because those four are also on the exemption list
  /// below, but the mechanism was wrong: a NEW session-scoped provider merely
  /// mentioned in a comment would have passed the guard silently, which is
  /// precisely the failure this test exists to prevent.
  String code(String path) => File(path)
      .readAsStringSync()
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
      .replaceAll(RegExp('//.*'), '');

  /// The providers `session_scope.dart` really invalidates — parsed from the
  /// calls themselves, not from anything a human wrote about them.
  Set<String> invalidatedProviders() {
    final calls = RegExp(r'ref\.invalidate\(\s*(\w+)\s*\)');
    final source = code('lib/core/session/session_scope.dart');
    return calls.allMatches(source).map((m) => m.group(1)!).toSet();
  }

  test('every session-scoped provider is cleared on sign-out', () {
    final invalidated = invalidatedProviders();
    final unclassified = <String>[];

    for (final file in libSources()) {
      final source = file.readAsStringSync();
      for (final match in declaration.allMatches(source)) {
        final name = match.group(1)!;
        final body = match.group(2)!;

        if (!statefulKind.hasMatch(body)) continue;
        // autoDispose providers drop their value with their last listener, so
        // they cannot outlive a sign-out in the way C-2 describes.
        if (body.contains('autoDispose')) continue;

        if (!invalidated.contains(name) &&
            !notSessionScoped.containsKey(name)) {
          unclassified.add('${file.path} — $name');
        }
      }
    }

    expect(
      unclassified,
      isEmpty,
      reason:
          'These providers hold state that survives a sign-out and have not '
          'been classified. Either invalidate them in '
          'lib/core/session/session_scope.dart, or add them to '
          'notSessionScoped in this test WITH the reason.\n\n'
          '${unclassified.join('\n')}',
    );
  });

  test('no provider is both invalidated and exempted', () {
    // A contradiction means somebody changed their mind in one place only. It
    // is a decision that has to be made once, not a harmless duplicate.
    final contradictions = invalidatedProviders()
        .where(notSessionScoped.containsKey)
        .toList();

    expect(
      contradictions,
      isEmpty,
      reason:
          'These are invalidated in session_scope.dart AND listed as not '
          'session-scoped in this test. Pick one: ${contradictions.join(', ')}',
    );
  });

  test('the exemption list has no stale entries', () {
    final declared = <String>{};
    for (final file in libSources()) {
      for (final match in declaration.allMatches(file.readAsStringSync())) {
        declared.add(match.group(1)!);
      }
    }

    final stale = notSessionScoped.keys
        .where((name) => !declared.contains(name))
        .toList();

    expect(
      stale,
      isEmpty,
      reason:
          'These providers are exempted here but no longer exist. Delete the '
          'entries so the list keeps meaning something: ${stale.join(', ')}',
    );
  });

  test('both sign-out paths call the invalidation', () {
    // Comments stripped for the same reason as above: `auth_controller.dart`
    // discusses `invalidateSessionScope` in its doc comment, and prose must not
    // be able to satisfy a guard about behaviour.
    final controller = code('lib/features/auth/notifier/auth_controller.dart');

    // The whole of C-2 was that one sign-out path cleared the session and the
    // other did not.
    final calls = RegExp(r'invalidateSessionScope\(').allMatches(controller);

    expect(
      calls.length,
      2,
      reason:
          'AuthController must invalidate the session scope in BOTH logout() '
          'and forceLogout(). Found ${calls.length} call(s).',
    );
  });

  test('forceLogout keeps its re-entry guard', () {
    // Load-bearing, and the least obvious line in the fix. Without it:
    //   forceLogout -> invalidateSessionScope -> a still-listened session
    //   provider rebuilds -> fetches with no token -> 401 ->
    //   AuthInterceptor._performRefresh finds no refresh token -> forceLogout
    // ...which is an unbounded loop. Deleting the guard looks like removing a
    // redundant early return, so it needs a test that says otherwise.
    final controller = code('lib/features/auth/notifier/auth_controller.dart');

    expect(
      controller.contains(RegExp(r'if\s*\(state is AuthUnauthenticated\)')),
      isTrue,
      reason:
          'forceLogout must return early when already signed out. Without the '
          'guard, invalidation triggers a refetch, the refetch 401s, and the '
          'interceptor calls forceLogout again — an unbounded loop.',
    );
  });
}
