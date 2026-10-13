import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/features/legal/models/terms_acceptance.dart';
import 'package:level_up_app/features/legal/repository/terms_repository.dart';
import 'package:level_up_app/features/legal/terms_errors.dart';

import '../../dev/contract_inline.dart';
import '../../dev/fake_api.dart';

/// The Terms-acceptance data layer (CW04b): two stable, authenticated
/// operations on `/me/terms-acceptance`, driven through a real [Dio] with the
/// REAL `ErrorInterceptor`, so what is asserted is what goes out on the wire
/// and what the app's typed boundary makes of what comes back.
void main() {
  const served = <String, Object?>{
    'currentVersion': 'r4-2026-10-07',
    'acceptedVersion': null,
    'acceptedAtUtc': null,
    'isCurrent': false,
  };

  TermsRepository repoFor(FakeApiAdapter adapter) =>
      TermsRepository(buildFakeApiDio(adapter));

  group('getTermsAcceptance', () {
    test(
      'GET /me/terms-acceptance, with no query, no body and no id',
      () async {
        final adapter = FakeApiAdapter((_) => jsonBody(200, served));

        final result = await repoFor(adapter).getTermsAcceptance();

        final request = adapter.only;
        expect(request.method, 'GET');
        expect(request.uri.path, '/api/v1/me/terms-acceptance');
        expect(request.uri.hasQuery, isFalse);
        expect(request.data, isNull);
        expect(result, isA<TermsAcceptance>());
        expect(result.currentVersion, 'r4-2026-10-07');
        expect(result.acceptedVersion, isNull);
        expect(result.isCurrent, isFalse);
      },
    );

    test('decodes the accepted and the inert states', () async {
      final accepted = await repoFor(
        FakeApiAdapter(
          (_) => jsonBody(200, {
            ...served,
            'acceptedVersion': 'r4-2026-10-07',
            'acceptedAtUtc': '2026-10-08T09:30:00Z',
            'isCurrent': true,
          }),
        ),
      ).getTermsAcceptance();
      expect(accepted.isCurrent, isTrue);
      expect(accepted.acceptedAtUtc, DateTime.utc(2026, 10, 8, 9, 30));

      final inert = await repoFor(
        FakeApiAdapter(
          (_) => jsonBody(200, {...served, 'currentVersion': null}),
        ),
      ).getTermsAcceptance();
      expect(inert.isInert, isTrue);
    });

    test('a body that breaks the contract is UnknownException, naming the '
        'runtime type and never the body', () async {
      for (final body in <Object?>[
        {...served}..remove('isCurrent'),
        {...served, 'isCurrent': 'yes'},
        {...served, 'currentVersion': 5},
      ]) {
        final adapter = FakeApiAdapter((_) => jsonBody(200, body));
        await expectLater(
          repoFor(adapter).getTermsAcceptance(),
          throwsA(
            isA<UnknownException>().having(
              (e) => e.detail,
              'detail',
              allOf(startsWith('parse: '), isNot(contains('r4-2026-10-07'))),
            ),
          ),
        );
      }
    });

    final failures = <String, (ResponseBody Function(RequestOptions), Matcher)>{
      '401 authentication_required': (
        (_) => problemBody(401, 'authentication_required'),
        isA<UnauthorizedException>().having(
          (e) => e.code,
          'code',
          'authentication_required',
        ),
      ),
      '401 session_superseded': (
        (_) => problemBody(401, 'session_superseded'),
        isA<UnauthorizedException>().having(
          (e) => e.code,
          'code',
          'session_superseded',
        ),
      ),
      '403 account_pending_deletion': (
        (_) => problemBody(403, 'account_pending_deletion'),
        predicate<Object?>(
          isAccountPendingDeletion,
          'account_pending_deletion',
        ),
      ),
      '500 internal_error': (
        (_) => problemBody(500, 'internal_error'),
        isA<ApiException>().having((e) => e.status, 'status', 500),
      ),
    };
    for (final MapEntry(key: label, value: (answer, matcher))
        in failures.entries) {
      test('$label is passed on as the interceptor typed it', () {
        final adapter = FakeApiAdapter(answer);
        expect(repoFor(adapter).getTermsAcceptance(), throwsA(matcher));
      });
    }

    test('offline is a NetworkException, not an unknown failure', () {
      final dio = buildFakeApiDio(
        FakeApiAdapter(
          (options) => throw DioException.connectionError(
            requestOptions: options,
            reason: 'offline',
          ),
        ),
      );
      expect(
        TermsRepository(dio).getTermsAcceptance(),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('acceptTerms', () {
    test('POST /me/terms-acceptance with exactly {termsVersion} - no time, '
        'no id - and nothing to decode on 204', () async {
      final adapter = FakeApiAdapter((_) => emptyBody(204));

      await repoFor(adapter).acceptTerms('r4-2026-10-07');

      final request = adapter.only;
      expect(request.method, 'POST');
      expect(request.uri.path, '/api/v1/me/terms-acceptance');
      expect(request.uri.hasQuery, isFalse);
      // The server records the time: the contract accepts none from the client.
      expect(request.data, <String, dynamic>{'termsVersion': 'r4-2026-10-07'});
    });

    test(
      'sends the version it was given verbatim, whatever it looks like',
      () async {
        final adapter = FakeApiAdapter((_) => emptyBody(204));
        final repo = repoFor(adapter);
        const maxLength = 'v123456789012345678901234567890-';
        expect(maxLength.length, TermsRepository.maxVersionLength);

        await repo.acceptTerms(maxLength);
        await repo.acceptTerms('  odd/Version ا ');

        expect(adapter.requests.map((r) => (r.data as Map)['termsVersion']), [
          maxLength,
          '  odd/Version ا ',
        ]);
      },
    );

    test(
      'idempotent on the wire: a repeat is sent again and is a 204 again',
      () async {
        final adapter = FakeApiAdapter((_) => emptyBody(204));
        final repo = repoFor(adapter);

        await repo.acceptTerms('r4-2026-10-07');
        await repo.acceptTerms('r4-2026-10-07');

        // No client-side de-duplication: whether it is a repeat is the server's
        // call ("the first acceptance time stands").
        expect(adapter.requests, hasLength(2));
      },
    );

    test('400 validation_failed on termsVersion keeps its field map and is '
        'recognised', () async {
      final adapter = FakeApiAdapter(
        (_) => problemBody(
          400,
          'validation_failed',
          errors: {
            'termsVersion': ['not the current version'],
          },
        ),
      );

      await expectLater(
        repoFor(adapter).acceptTerms('stale'),
        throwsA(
          isA<ValidationException>()
              .having((e) => e.fields, 'fields', ['termsVersion'])
              .having(isTermsVersionRejected, 'isTermsVersionRejected', isTrue),
        ),
      );
    });

    test(
      '401 and 403 account_pending_deletion are passed on untouched',
      () async {
        await expectLater(
          repoFor(
            FakeApiAdapter((_) => problemBody(401, 'session_superseded')),
          ).acceptTerms('r4-2026-10-07'),
          throwsA(isA<UnauthorizedException>()),
        );
        await expectLater(
          repoFor(
            FakeApiAdapter((_) => problemBody(403, 'account_pending_deletion')),
          ).acceptTerms('r4-2026-10-07'),
          throwsA(predicate<Object?>(isAccountPendingDeletion)),
        );
      },
    );

    test('a failure the interceptor did not type is UnknownException', () {
      final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
        ..httpClientAdapter = FakeApiAdapter(
          (options) => throw DioException(requestOptions: options),
        );
      expect(
        TermsRepository(dio).acceptTerms('r4-2026-10-07'),
        throwsA(isA<UnknownException>()),
      );
    });

    test('a version outside the contract bound never leaves the device '
        '(debug assert)', () {
      final adapter = FakeApiAdapter((_) => emptyBody(204));
      final repo = repoFor(adapter);
      expect(() => repo.acceptTerms(''), throwsA(isA<AssertionError>()));
      expect(
        () => repo.acceptTerms('x' * (TermsRepository.maxVersionLength + 1)),
        throwsA(isA<AssertionError>()),
      );
      expect(adapter.requests, isEmpty);
    });
  });

  group('the pinned contract', () {
    late ContractOperation accept;
    late String contract;

    setUpAll(() {
      contract = File('contract/openapi.yaml').readAsStringSync();
      accept = ContractOperation.find(
        contract,
        path: '/me/terms-acceptance',
        method: 'post',
      );
    });

    test('acceptTerms is stable and authenticated, and takes exactly '
        '{termsVersion}', () {
      expect(accept.operationId, 'acceptTerms');
      expect(accept.isStable, isTrue);
      expect(accept.isAnonymous, isFalse);
      expect(accept.requestRequired(), ['termsVersion']);
      expect(accept.requestProperties(), ['termsVersion']);
    });

    test('it answers 204 with no body to decode, and 400 for a rejected '
        'version', () {
      expect(accept.hasResponse('204'), isTrue);
      expect(accept.hasResponse('400'), isTrue);
      expect(accept.hasResponse('200'), isFalse);
    });

    test('maxVersionLength is the maxLength the contract gives termsVersion', () {
      expect(
        contract,
        contains(
          'termsVersion: { type: string, maxLength: ${TermsRepository.maxVersionLength} }',
        ),
      );
    });
  });

  test('termsRepositoryProvider builds the repository over dioProvider', () {
    final adapter = FakeApiAdapter((_) => jsonBody(200, served));
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(buildFakeApiDio(adapter))],
    );
    addTearDown(container.dispose);

    final repo = container.read(termsRepositoryProvider);

    expect(repo, isA<TermsRepository>());
    expect(repo.getTermsAcceptance(), completion(isA<TermsAcceptance>()));
  });
}
