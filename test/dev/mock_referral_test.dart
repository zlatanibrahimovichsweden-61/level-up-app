import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/dev/mock_referral.dart';
import 'package:level_up_app/features/referral/repository/referral_repository.dart';

/// `GET /me/invite`, served by the on-device mock.
///
/// Driven through the REAL [ReferralRepository] and the REAL `ErrorInterceptor`
/// by a Dio whose only other piece is a tiny interceptor doing what
/// `mock_backend.dart`'s dispatch block does. So the fixture is proved to parse
/// into the REAL `MyInvite` - if the model changes and the mock stops parsing,
/// that is the harness doing its job.
void main() {
  late MockReferral mock;
  late ReferralRepository repo;

  setUp(() {
    mock = MockReferral();
    repo = ReferralRepository(_dioFor(mock));
  });

  test('the fixture parses into the real MyInvite', () async {
    final invite = await repo.getMyInvite();

    expect(invite.code, kMockInviteCode);
    expect(invite.friendsJoined, kMockInviteFriendsJoined);
    expect(invite.pointsEarned, kMockInvitePointsEarned);
  });

  test('the code satisfies the contract\'s own pattern', () {
    final contract = File('contract/openapi.yaml').readAsStringSync();
    final schema = contract.substring(contract.indexOf('\n    MyInvite:'));
    final match = RegExp(r"pattern:\s*'([^']+)'").firstMatch(schema);
    expect(match, isNotNull, reason: 'MyInvite.code lost its pattern');

    expect(RegExp(match!.group(1)!).hasMatch(kMockInviteCode), isTrue);
    expect(kMockInviteCode, hasLength(8));
  });

  test(
    'the counts obey the contract: non-negative, points not above 10 each',
    () {
      expect(kMockInviteFriendsJoined, greaterThanOrEqualTo(0));
      expect(kMockInvitePointsEarned, greaterThanOrEqualTo(0));
      expect(
        kMockInvitePointsEarned,
        lessThanOrEqualTo(10 * kMockInviteFriendsJoined),
      );
    },
  );

  test(
    'the points are deliberately NOT 10 x friends: the server figure is shown',
    () {
      expect(kMockInvitePointsEarned, isNot(10 * kMockInviteFriendsJoined));
    },
  );

  test('stateless: every call returns the same record', () async {
    final first = await repo.getMyInvite();
    final second = await repo.getMyInvite();

    expect(second, first);
  });

  group('only that one route is served', () {
    test('other methods fall through', () {
      for (final method in ['POST', 'PUT', 'PATCH', 'DELETE']) {
        expect(mock.handle(method, '/me/invite'), isNull, reason: method);
      }
    });

    test('other paths fall through', () {
      expect(mock.handle('GET', '/me'), isNull);
      expect(mock.handle('GET', '/me/invites'), isNull);
      expect(mock.handle('GET', '/me/invite/regenerate'), isNull);
    });

    test('an unserved route is a 404 through the harness', () async {
      final dio = _dioFor(mock);

      try {
        await dio.post<Object?>('/me/invite');
        fail('should have been rejected');
      } on DioException catch (e) {
        expect((e.error! as ApiException).status, 404);
      }
    });
  });

  test('the reply is a 200 with the three contract keys and nothing else', () {
    final reply = mock.handle('GET', '/me/invite');

    expect(reply, isA<MockReferralOk>());
    final ok = reply! as MockReferralOk;
    expect(ok.status, 200);
    expect((ok.data! as Map<String, dynamic>).keys.toSet(), {
      'code',
      'friendsJoined',
      'pointsEarned',
    });
  });
}

/// A Dio whose only behaviour is the mock: the same mapping
/// `mock_backend.dart` performs, then the real ErrorInterceptor.
Dio _dioFor(MockReferral mock) {
  final dio = Dio(BaseOptions(baseUrl: 'http://mock.local/api/v1'));
  dio.interceptors.addAll([_MockInterceptor(mock), ErrorInterceptor()]);
  return dio;
}

class _MockInterceptor extends Interceptor {
  _MockInterceptor(this.mock);

  final MockReferral mock;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final reply = mock.handle(options.method.toUpperCase(), options.path);
    switch (reply) {
      case MockReferralOk(:final status, :final data):
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: status,
            data: data,
          ),
        );
      case null:
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(
              requestOptions: options,
              statusCode: 404,
              data: <String, dynamic>{'status': 404, 'code': 'not_found'},
            ),
          ),
          true,
        );
    }
  }
}
