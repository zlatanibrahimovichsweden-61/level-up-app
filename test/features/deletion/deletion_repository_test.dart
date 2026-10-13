import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/features/deletion/deletion_errors.dart';
import 'package:level_up_app/features/deletion/models/deletion_window.dart';
import 'package:level_up_app/features/deletion/repository/deletion_repository.dart';

import '../../dev/contract_inline.dart';
import '../../dev/fake_api.dart';

/// The account-deletion data layer (CW05): the two stable, authenticated
/// operations on `/me/deletion-request`, driven through a real [Dio] with the
/// REAL `ErrorInterceptor`.
void main() {
  const accepted = <String, Object?>{
    'requestedAt': '2026-10-12T08:00:00Z',
    'effectiveAt': '2026-11-11T08:00:00Z',
  };

  DeletionRepository repoFor(FakeApiAdapter adapter) =>
      DeletionRepository(buildFakeApiDio(adapter));

  group('requestAccountDeletion', () {
    test(
      'POST /me/deletion-request with no body, no query and no id',
      () async {
        final adapter = FakeApiAdapter((_) => jsonBody(202, accepted));

        final window = await repoFor(adapter).requestAccountDeletion();

        final request = adapter.only;
        expect(request.method, 'POST');
        expect(request.uri.path, '/api/v1/me/deletion-request');
        expect(request.uri.hasQuery, isFalse);
        expect(request.data, isNull);
        expect(window, isA<DeletionWindow>());
        expect(window.requestedAt, DateTime.utc(2026, 10, 12, 8));
        expect(window.effectiveAt, DateTime.utc(2026, 11, 11, 8));
      },
    );

    test('409 deletion_already_requested is the typed ApiException the '
        'predicate recognises', () async {
      final adapter = FakeApiAdapter(
        (_) => problemBody(409, 'deletion_already_requested'),
      );

      await expectLater(
        repoFor(adapter).requestAccountDeletion(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 409)
              .having(
                isDeletionAlreadyRequested,
                'isDeletionAlreadyRequested',
                isTrue,
              )
              .having(isNoPendingDeletion, 'isNoPendingDeletion', isFalse),
        ),
      );
    });

    test('401 is passed on typed (the interceptor refreshes or signs out '
        'first)', () async {
      for (final code in ['authentication_required', 'session_superseded']) {
        await expectLater(
          repoFor(
            FakeApiAdapter((_) => problemBody(401, code)),
          ).requestAccountDeletion(),
          throwsA(
            isA<UnauthorizedException>().having((e) => e.code, 'code', code),
          ),
        );
      }
    });

    test('offline is a NetworkException', () {
      final dio = buildFakeApiDio(
        FakeApiAdapter(
          (options) => throw DioException.connectionError(
            requestOptions: options,
            reason: 'offline',
          ),
        ),
      );
      expect(
        DeletionRepository(dio).requestAccountDeletion(),
        throwsA(isA<NetworkException>()),
      );
    });

    test(
      'a 202 whose body breaks the contract is UnknownException with the '
      'runtime type only - the request may still have been recorded',
      () async {
        for (final body in <Object?>[
          <String, Object?>{'requestedAt': '2026-10-12T08:00:00Z'},
          <String, Object?>{...accepted, 'effectiveAt': 7},
          <String, Object?>{...accepted, 'effectiveAt': 'soon'},
        ]) {
          await expectLater(
            repoFor(
              FakeApiAdapter((_) => jsonBody(202, body)),
            ).requestAccountDeletion(),
            throwsA(
              isA<UnknownException>().having(
                (e) => e.detail,
                'detail',
                allOf(startsWith('parse: '), isNot(contains('2026'))),
              ),
            ),
          );
        }
      },
    );

    test('a 202 whose body is not even an object is UnknownException, with '
        'nothing of the body in it', () async {
      await expectLater(
        repoFor(
          FakeApiAdapter((_) => jsonBody(202, ['2026-10-12T08:00:00Z'])),
        ).requestAccountDeletion(),
        throwsA(
          isA<UnknownException>().having(
            (e) => e.detail ?? '',
            'detail',
            isNot(contains('2026')),
          ),
        ),
      );
    });

    test('a 202 with no body at all is UnknownException too', () {
      expect(
        repoFor(FakeApiAdapter((_) => emptyBody(202))).requestAccountDeletion(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('cancelAccountDeletion', () {
    test(
      'DELETE /me/deletion-request, nothing to send, nothing returned',
      () async {
        final adapter = FakeApiAdapter((_) => emptyBody(204));

        await repoFor(adapter).cancelAccountDeletion();

        final request = adapter.only;
        expect(request.method, 'DELETE');
        expect(request.uri.path, '/api/v1/me/deletion-request');
        expect(request.uri.hasQuery, isFalse);
        expect(request.data, isNull);
      },
    );

    test('404 no_pending_deletion is surfaced typed, not swallowed', () async {
      await expectLater(
        repoFor(
          FakeApiAdapter((_) => problemBody(404, 'no_pending_deletion')),
        ).cancelAccountDeletion(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 404)
              .having(isNoPendingDeletion, 'isNoPendingDeletion', isTrue)
              .having(
                isDeletionAlreadyRequested,
                'isDeletionAlreadyRequested',
                isFalse,
              ),
        ),
      );
    });

    test('401 is passed on typed', () {
      expect(
        repoFor(
          FakeApiAdapter((_) => problemBody(401, 'session_superseded')),
        ).cancelAccountDeletion(),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('a failure the interceptor did not type is UnknownException', () {
      final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
        ..httpClientAdapter = FakeApiAdapter(
          (options) => throw DioException(requestOptions: options),
        );
      expect(
        DeletionRepository(dio).cancelAccountDeletion(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('the repository stays out of the session', () {
    test('it takes only a Dio: no storage, no auth controller, no router', () {
      final source = File(
        'lib/features/deletion/repository/deletion_repository.dart',
      ).readAsStringSync();
      final imports = RegExp(
        r"^import '([^']+)';",
        multiLine: true,
      ).allMatches(source).map((m) => m.group(1)!).toList();

      expect(
        imports.where(
          (i) =>
              i.contains('secure_storage') ||
              i.contains('auth_controller') ||
              i.contains('session_scope') ||
              i.contains('app_router') ||
              i.contains('return_target'),
        ),
        isEmpty,
        reason: 'purging tokens and ending the session is the caller\'s job',
      );
    });
  });

  group('the cancel-then-request cycle on the wire', () {
    test('request, repeat (409), cancel, repeat cancel (404)', () async {
      var pending = false;
      final adapter = FakeApiAdapter((options) {
        if (options.method == 'POST') {
          if (pending) return problemBody(409, 'deletion_already_requested');
          pending = true;
          return jsonBody(202, accepted);
        }
        if (!pending) return problemBody(404, 'no_pending_deletion');
        pending = false;
        return emptyBody(204);
      });
      final repo = repoFor(adapter);

      await repo.requestAccountDeletion();
      await expectLater(
        repo.requestAccountDeletion(),
        throwsA(predicate<Object?>(isDeletionAlreadyRequested)),
      );
      await repo.cancelAccountDeletion();
      await expectLater(
        repo.cancelAccountDeletion(),
        throwsA(predicate<Object?>(isNoPendingDeletion)),
      );
    });
  });

  test('deletionRepositoryProvider builds the repository over dioProvider', () {
    final adapter = FakeApiAdapter((_) => jsonBody(202, accepted));
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(buildFakeApiDio(adapter))],
    );
    addTearDown(container.dispose);

    final repo = container.read(deletionRepositoryProvider);

    expect(repo, isA<DeletionRepository>());
    expect(repo.requestAccountDeletion(), completion(isA<DeletionWindow>()));
  });

  group('the pinned contract', () {
    late ContractOperation post;
    late ContractOperation delete;

    setUpAll(() {
      final yaml = File('contract/openapi.yaml').readAsStringSync();
      post = ContractOperation.find(
        yaml,
        path: '/me/deletion-request',
        method: 'post',
      );
      delete = ContractOperation.find(
        yaml,
        path: '/me/deletion-request',
        method: 'delete',
      );
    });

    test('both operations are stable and authenticated', () {
      expect(post.isStable && delete.isStable, isTrue);
      expect(post.isAnonymous || delete.isAnonymous, isFalse);
      expect(delete.operationId, 'cancelAccountDeletion');
    });

    test('the cancel answers 204 and 404, with nothing to decode', () {
      expect(delete.hasResponse('204'), isTrue);
      expect(delete.hasResponse('404'), isTrue);
      expect(delete.hasResponse('200'), isFalse);
      expect(delete.text, contains('no_pending_deletion'));
    });

    test('neither takes a body: the account is the caller\'s own', () {
      expect(post.text, isNot(contains('requestBody')));
      expect(delete.text, isNot(contains('requestBody')));
    });
  });
}
