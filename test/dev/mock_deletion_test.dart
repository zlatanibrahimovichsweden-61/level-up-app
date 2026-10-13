import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_deletion.dart';
import 'package:level_up_app/features/deletion/models/deletion_window.dart';
import 'package:level_up_app/features/deletion/repository/deletion_repository.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';

/// The mock's account deletion (CW05): `mock_deletion.dart`, the module that
/// `mock_backend.dart` dispatches to. Its state and the contract's rules -
/// including the DEFAULT-DENY rule, which must stay dormant until a request is
/// recorded - are tested here directly; the end-to-end group at the bottom
/// drives the same module THROUGH `buildMockDio` and the real repository, so it
/// fails if the dispatch hook is ever dropped from `mock_backend.dart`.
void main() {
  final fixedNow = DateTime.utc(2026, 10, 12, 8);

  MockAccountDeletion mock() => MockAccountDeletion(clock: () => fixedNow);

  MockDeletionOk ok(MockDeletionReply? reply) {
    expect(reply, isA<MockDeletionOk>());
    return reply! as MockDeletionOk;
  }

  MockDeletionProblem problem(MockDeletionReply? reply) {
    expect(reply, isA<MockDeletionProblem>());
    return reply! as MockDeletionProblem;
  }

  /// The mock after a successful request.
  MockAccountDeletion requested() {
    final m = mock();
    ok(m.handle('POST', '/me/deletion-request'));
    return m;
  }

  group('dormant until a request is recorded - nothing changes before it', () {
    test('no pending state, and the profile comes back untouched', () {
      final m = mock();
      expect(m.isPending, isFalse);
      expect(m.pendingDeletion, isNull);

      final profile = <String, dynamic>{'id': 'x', 'name': 'n'};
      expect(identical(m.decorateProfile(profile), profile), isTrue);
      expect(profile.containsKey('pendingDeletion'), isFalse);
    });

    test('NO route is denied: every method and path falls through', () {
      final m = mock();
      for (final (method, path) in const [
        ('GET', '/me'),
        ('GET', '/me/entitlements'),
        ('GET', '/me/mistakes'),
        ('PATCH', '/me'),
        ('GET', '/leaderboard'),
        ('POST', '/quizzes'),
        ('GET', '/catalog/subjects'),
        ('GET', '/me/notifications'),
        ('GET', '/support/tickets'),
        ('POST', '/auth/logout'),
        ('POST', '/auth/otp/verify'),
        ('GET', '/reference/countries'),
      ]) {
        expect(m.handle(method, path), isNull, reason: '$method $path');
      }
    });
  });

  group('POST - requestAccountDeletion', () {
    test('202 with {requestedAt, effectiveAt}, effectiveAt = requestedAt + 30 '
        'days, both UTC', () {
      final reply = ok(mock().handle('POST', '/me/deletion-request'));

      expect(reply.status, 202);
      // Parsed by the REAL model.
      final window = DeletionWindow.fromJson(reply.data!);
      expect(window.requestedAt, fixedNow);
      expect(window.effectiveAt, fixedNow.add(const Duration(days: 30)));
      expect(reply.data!['requestedAt'], endsWith('Z'));
      expect(reply.data!['effectiveAt'], endsWith('Z'));
      expect(kMockDeletionGraceDays, 30);
    });

    test('a second request is 409 deletion_already_requested and moves '
        'nothing', () {
      var now = fixedNow;
      final m = MockAccountDeletion(clock: () => now);
      m.handle('POST', '/me/deletion-request');
      final first = m.pendingDeletion!['effectiveAt'];

      now = fixedNow.add(const Duration(days: 9));
      final again = problem(m.handle('POST', '/me/deletion-request'));

      expect(again.status, 409);
      expect(again.code, 'deletion_already_requested');
      expect(m.pendingDeletion!['effectiveAt'], first);
    });
  });

  group('DELETE - cancelAccountDeletion', () {
    test('204 with no body, and the account is not pending any more', () {
      final m = requested();
      final reply = ok(m.handle('DELETE', '/me/deletion-request'));

      expect(reply.status, 204);
      expect(reply.data, isNull);
      expect(m.isPending, isFalse);
      expect(m.pendingDeletion, isNull);
    });

    test('with nothing pending it is 404 no_pending_deletion', () {
      final reply = problem(mock().handle('DELETE', '/me/deletion-request'));
      expect(reply.status, 404);
      expect(reply.code, 'no_pending_deletion');
    });

    test('cancelling twice: 204 then 404', () {
      final m = requested();
      ok(m.handle('DELETE', '/me/deletion-request'));
      expect(
        problem(m.handle('DELETE', '/me/deletion-request')).code,
        'no_pending_deletion',
      );
    });

    test('a new request after a cancel opens a fresh window', () {
      var now = fixedNow;
      final m = MockAccountDeletion(clock: () => now);
      m.handle('POST', '/me/deletion-request');
      m.handle('DELETE', '/me/deletion-request');

      now = fixedNow.add(const Duration(days: 2));
      final reply = ok(m.handle('POST', '/me/deletion-request'));
      expect(DeletionWindow.fromJson(reply.data!).requestedAt, now);
    });
  });

  group('GET /me carries pendingDeletion only while pending', () {
    test('present as {effectiveAt} - parsed by the real PendingDeletion', () {
      final m = requested();
      final decorated = m.decorateProfile(<String, dynamic>{'id': 'x'});

      expect(decorated['id'], 'x');
      final pending = PendingDeletion.fromJson(
        decorated['pendingDeletion'] as Map<String, dynamic>,
      );
      expect(pending.effectiveAt, fixedNow.add(const Duration(days: 30)));
    });

    test('the key is ABSENT again after a cancel - never null', () {
      final m = requested();
      m.handle('DELETE', '/me/deletion-request');
      final decorated = m.decorateProfile(<String, dynamic>{'id': 'x'});
      expect(decorated.containsKey('pendingDeletion'), isFalse);
    });

    test('decorating does not mutate the profile it was given', () {
      final m = requested();
      final profile = <String, dynamic>{'id': 'x'};
      m.decorateProfile(profile);
      expect(profile.containsKey('pendingDeletion'), isFalse);
    });
  });

  group('default-deny while pending (openapi.yaml:63-83)', () {
    test('the allowlist is exactly the contract\'s four', () {
      expect(MockAccountDeletion.allowlist, {
        'GET /me',
        'POST /me/deletion-request',
        'DELETE /me/deletion-request',
        'POST /auth/logout',
      });
    });

    test('the four allowlisted calls are never denied', () {
      final m = requested();
      expect(m.handle('GET', '/me'), isNull);
      expect(m.handle('POST', '/auth/logout'), isNull);
      // The two deletion operations answer for themselves, never with the 403.
      expect(
        problem(m.handle('POST', '/me/deletion-request')).code,
        'deletion_already_requested',
      );
      ok(m.handle('DELETE', '/me/deletion-request'));
    });

    test('every other authenticated call is 403 account_pending_deletion', () {
      final m = requested();
      for (final (method, path) in const [
        ('PATCH', '/me'),
        ('GET', '/me/entitlements'),
        ('GET', '/me/mistakes'),
        ('GET', '/me/mistakes/subjects/abc'),
        ('GET', '/me/notifications'),
        ('POST', '/me/notifications/abc/read'),
        ('GET', '/me/terms-acceptance'),
        ('POST', '/me/terms-acceptance'),
        ('GET', '/leaderboard'),
        ('GET', '/leaderboard/me'),
        ('POST', '/quizzes'),
        ('GET', '/catalog/subjects'),
        ('GET', '/support/tickets'),
        ('POST', '/support/tickets'),
        ('GET', '/flashcards/lectures/abc/cards'),
        // Same path, a method the allowlist does not name.
        ('PUT', '/me'),
        ('DELETE', '/me'),
      ]) {
        final reply = problem(m.handle(method, path));
        expect(reply.status, 403, reason: '$method $path');
        expect(reply.code, 'account_pending_deletion', reason: '$method $path');
      }
    });

    test('the anonymous ladder and the public reads are outside the rule', () {
      final m = requested();
      for (final (method, path) in const [
        ('POST', '/auth/otp/request'),
        ('POST', '/auth/otp/verify'),
        ('POST', '/auth/register'),
        ('POST', '/auth/refresh'),
        ('POST', '/auth/recovery/start'),
        ('POST', '/auth/recovery/verify-parent'),
        ('POST', '/auth/recovery/new-phone'),
        ('POST', '/auth/recovery/confirm'),
        ('GET', '/reference/countries'),
        ('GET', '/reference/legal-documents/terms'),
      ]) {
        expect(m.handle(method, path), isNull, reason: '$method $path');
      }
    });

    test('lifted by a cancel: the same call is let through again', () {
      final m = requested();
      expect(problem(m.handle('GET', '/me/entitlements')).status, 403);
      m.handle('DELETE', '/me/deletion-request');
      expect(m.handle('GET', '/me/entitlements'), isNull);
    });

    test('the denial is recognised by the app\'s one predicate', () {
      final reply = problem(requested().handle('GET', '/leaderboard'));
      expect(
        isAccountPendingDeletion(
          ApiException(status: reply.status, code: reply.code),
        ),
        isTrue,
      );
    });
  });

  group('routing', () {
    test('only POST and DELETE answer on the deletion path - other methods '
        'there are not deletion operations, pending or not', () {
      final m = mock();
      final pending = requested();
      for (final each in [m, pending]) {
        expect(each.handle('GET', '/me/deletion-request'), isNull);
        expect(each.handle('PUT', '/me/deletion-request'), isNull);
        expect(each.handle('PATCH', '/me/deletion-request'), isNull);
      }
    });
  });

  group('through buildMockDio and the real repository', () {
    test(
      'request, then default-deny, then cancel - on one mock session',
      () async {
        final dio = buildMockDio(latency: Duration.zero);
        final repo = DeletionRepository(dio);

        // Before any request, the mock behaves exactly as it always did.
        final before = await dio.get<Map<String, dynamic>>('/me');
        expect(before.data!.containsKey('pendingDeletion'), isFalse);
        await dio.get<dynamic>('/me/entitlements');

        final window = await repo.requestAccountDeletion();
        expect(window.effectiveAt.difference(window.requestedAt).inDays, 30);

        final during = await dio.get<Map<String, dynamic>>('/me');
        expect(
          PendingDeletion.fromJson(
            during.data!['pendingDeletion'] as Map<String, dynamic>,
          ).effectiveAt,
          window.effectiveAt,
        );
        await expectLater(
          dio.get<dynamic>('/me/entitlements'),
          throwsA(
            isA<DioException>().having(
              (e) => isAccountPendingDeletion(e.error),
              'is account_pending_deletion',
              isTrue,
            ),
          ),
        );

        await repo.cancelAccountDeletion();
        final after = await dio.get<Map<String, dynamic>>('/me');
        expect(after.data!.containsKey('pendingDeletion'), isFalse);
        await dio.get<dynamic>('/me/entitlements');
      },
    );
  });
}
