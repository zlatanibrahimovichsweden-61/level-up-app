import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/referral/repository/referral_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// `GET /me/invite` (`getMyInvite`): the call the app builds, the model it
/// decodes, and the typed errors it hands back.
void main() {
  late _MockDio dio;
  late ReferralRepository repo;

  // A sample in the contract's alphabet, nobody's real code.
  const sampleCode = 'K7M2Q9XD';

  setUp(() {
    dio = _MockDio();
    repo = ReferralRepository(dio);
  });

  Response<Map<String, dynamic>> ok(Map<String, dynamic>? data) =>
      Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/me/invite'),
        statusCode: 200,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: '/me/invite'),
    error: mapped,
  );

  void stubGet(Map<String, dynamic>? body) {
    when(
      () => dio.get<Map<String, dynamic>>('/me/invite'),
    ).thenAnswer((_) async => ok(body));
  }

  void stubGetThrows(Object error) {
    when(() => dio.get<Map<String, dynamic>>('/me/invite')).thenThrow(error);
  }

  test(
    'GETs /me/invite with no query and no body, and decodes MyInvite',
    () async {
      stubGet(<String, dynamic>{
        'code': sampleCode,
        'friendsJoined': 4,
        'pointsEarned': 30,
      });

      final invite = await repo.getMyInvite();

      expect(invite.code, sampleCode);
      expect(invite.friendsJoined, 4);
      expect(invite.pointsEarned, 30);
      // The call names the path and nothing else: the student comes from the
      // token (the contract: "Takes no id - always the caller's own").
      verify(() => dio.get<Map<String, dynamic>>('/me/invite')).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  group('failures arrive as the typed exception the interceptor mapped', () {
    final cases = <String, AppException>{
      '401 session_superseded': const UnauthorizedException(
        code: 'session_superseded',
      ),
      '401 authentication_required': const UnauthorizedException(
        code: 'authentication_required',
      ),
      '403 account_pending_deletion': const ApiException(
        status: 403,
        code: 'account_pending_deletion',
      ),
      'offline': const OfflineException(),
      'timeout': const NetworkException(detail: 'timeout'),
      '500': const ApiException(status: 500, code: 'internal_error'),
    };

    for (final entry in cases.entries) {
      test(entry.key, () async {
        stubGetThrows(failure(entry.value));

        await expectLater(repo.getMyInvite(), throwsA(same(entry.value)));
      });
    }

    test(
      'account_pending_deletion is surfaced untouched, for the cancel route',
      () async {
        stubGetThrows(
          failure(
            const ApiException(status: 403, code: 'account_pending_deletion'),
          ),
        );

        try {
          await repo.getMyInvite();
          fail('should have thrown');
        } on Object catch (e) {
          expect(isAccountPendingDeletion(e), isTrue);
        }
      },
    );

    test(
      'a DioException that bypassed the interceptor becomes UnknownException',
      () async {
        stubGetThrows(
          DioException(requestOptions: RequestOptions(path: '/me/invite')),
        );

        await expectLater(repo.getMyInvite(), throwsA(isA<UnknownException>()));
      },
    );
  });

  group('schema drift stays inside the typed boundary', () {
    test(
      'a response missing a required field is an UnknownException',
      () async {
        stubGet(<String, dynamic>{'code': sampleCode, 'friendsJoined': 4});

        await expectLater(repo.getMyInvite(), throwsA(isA<UnknownException>()));
      },
    );

    test('an empty body is an UnknownException', () async {
      stubGet(null);

      await expectLater(repo.getMyInvite(), throwsA(isA<UnknownException>()));
    });

    test(
      'the error detail carries the runtime type only, never the code',
      () async {
        // `code` is present and valid; `pointsEarned` is the wrong type, so the
        // decode fails with the code sitting in the response body.
        stubGet(<String, dynamic>{
          'code': sampleCode,
          'friendsJoined': 4,
          'pointsEarned': 'thirty',
        });

        try {
          await repo.getMyInvite();
          fail('should have thrown');
        } on UnknownException catch (e) {
          expect(e.detail, startsWith('parse: '));
          expect(e.detail, isNot(contains(sampleCode)));
          expect(e.toString(), isNot(contains(sampleCode)));
        }
      },
    );
  });

  test('nothing is printed on the success or failure path', () async {
    final printed = <String>[];
    await runZoned(
      () async {
        stubGet(<String, dynamic>{
          'code': sampleCode,
          'friendsJoined': 4,
          'pointsEarned': 30,
        });
        await repo.getMyInvite();
        stubGet(<String, dynamic>{'code': sampleCode});
        await repo.getMyInvite().then<void>((_) {}, onError: (Object _) {});
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => printed.add(line),
      ),
    );

    expect(printed, isEmpty);
  });
}
