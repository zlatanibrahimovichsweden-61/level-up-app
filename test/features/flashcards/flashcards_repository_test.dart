import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/flashcards/models/flashcard.dart';
import 'package:level_up_app/features/flashcards/repository/flashcards_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// The Flashcards data layer.
///
/// The rules guarded here are the ones the contract states in PROSE and that a
/// client can silently get wrong:
/// - a short page is not the end of the list — branch on `hasMore`;
/// - an empty page means "no active cards", never "allowance exhausted";
/// - `imageUrl` and `selfGrade` are required keys whose value is normally null;
/// - the self-grade write is a `204` with nothing to decode.
void main() {
  late _MockDio dio;
  late FlashcardsRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = FlashcardsRepository(dio);
  });

  Response<T> response<T>(T data, {int status = 200, String path = '/x'}) =>
      Response<T>(
        requestOptions: RequestOptions(path: path),
        statusCode: status,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: '/x'),
    error: mapped,
  );

  Map<String, dynamic> card({
    String id = 'card-1',
    String front = 'What is the hamate?',
    String back = 'A carpal bone.\nIt carries the hook of hamate.',
    String? imageUrl,
    String? selfGrade,
  }) => {
    'id': id,
    'front': front,
    'back': back,
    'imageUrl': imageUrl,
    'selfGrade': selfGrade,
  };

  const path = '/flashcards/lectures/lec-1/cards';

  void stubPage(Map<String, dynamic> body) {
    when(
      () => dio.get<Map<String, dynamic>>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => response(body));
  }

  group('getFlashcardsForLecture', () {
    test('decodes a page, including the two null-by-default fields', () async {
      stubPage({
        'items': [card()],
        'nextCursor': null,
        'hasMore': false,
      });

      final page = await repo.getFlashcardsForLecture('lec-1');

      expect(page.items, hasLength(1));
      final c = page.items.single;
      expect(c.id, 'card-1');
      expect(c.front, 'What is the hamate?');
      // Free multi-line text that may hold several answers — kept verbatim.
      expect(c.back, contains('\n'));
      // `null` in every environment today: no card-image CDN is provisioned.
      // Not an error, and not a decode failure.
      expect(c.imageUrl, isNull);
      // Never graded.
      expect(c.selfGrade, isNull);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('decodes both self-grades', () async {
      stubPage({
        'items': [
          card(id: 'a', selfGrade: 'gotIt'),
          card(id: 'b', selfGrade: 'again'),
        ],
        'hasMore': false,
      });

      final page = await repo.getFlashcardsForLecture('lec-1');

      expect(page.items.map((c) => c.selfGrade), [
        FlashcardSelfGrade.gotIt,
        FlashcardSelfGrade.again,
      ]);
    });

    test('a THIRD self-grade throws rather than degrading', () async {
      // The contract calls this a CLOSED set: a third value "would render as
      // neither and decides product behaviour nobody has specified". Unlike
      // `EntitlementType`, it must not fall back to an `unknown` member.
      stubPage({
        'items': [card(selfGrade: 'sortOf')],
        'hasMore': false,
      });

      await expectLater(
        repo.getFlashcardsForLecture('lec-1'),
        throwsA(isA<UnknownException>()),
      );
    });

    test('a SHORT page with hasMore:true is not the end of the list', () async {
      // 🔴 The rule the whole envelope exists for. When the weekly allowance
      // cannot pay for a full page the server returns the prefix it can pay
      // for, sets hasMore:true and points nextCursor at the first card that
      // was NOT delivered. A client branching on items.length would truncate
      // the lecture for exactly the students who are most constrained.
      stubPage({
        'items': [card(id: 'a'), card(id: 'b')],
        'nextCursor': 'opaque-keyset-token',
        'hasMore': true,
      });

      final page = await repo.getFlashcardsForLecture('lec-1', pageSize: 20);

      expect(page.items, hasLength(2));
      expect(page.items.length, lessThan(20));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'opaque-keyset-token');
    });

    test(
      'an EMPTY page is a normal response, not an exhausted allowance',
      () async {
        // The contract is explicit: when zero cards can be delivered the answer
        // is 403 flashcard_subscription_required, NOT an empty page. So an
        // empty items array means the lecture genuinely has no active cards,
        // and must not be rendered as a failure.
        stubPage({'items': <dynamic>[], 'hasMore': false});

        final page = await repo.getFlashcardsForLecture('lec-1');

        expect(page.items, isEmpty);
        expect(page.hasMore, isFalse);
      },
    );

    test('forwards the opaque cursor and pageSize, and nothing else', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.getFlashcardsForLecture('lec-1', cursor: 'tok', pageSize: 50);

      final captured =
          verify(
                () => dio.get<Map<String, dynamic>>(
                  path,
                  queryParameters: captureAny(named: 'queryParameters'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured, {'cursor': 'tok', 'pageSize': 50});
    });

    test('omits both query parameters when neither was given', () async {
      stubPage({'items': <dynamic>[], 'hasMore': false});

      await repo.getFlashcardsForLecture('lec-1');

      final captured =
          verify(
                () => dio.get<Map<String, dynamic>>(
                  path,
                  queryParameters: captureAny(named: 'queryParameters'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      // Absent, not null: a `cursor: null` would be a malformed cursor (400).
      expect(captured, isEmpty);
    });

    test('surfaces the mapped 403 codes untouched', () async {
      for (final code in [
        'insufficient_scope',
        'flashcard_subscription_required',
        'account_pending_deletion',
      ]) {
        when(
          () => dio.get<Map<String, dynamic>>(
            path,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(failure(ApiException(status: 403, code: code)));

        await expectLater(
          repo.getFlashcardsForLecture('lec-1'),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', code)),
          reason: code,
        );
      }
    });
  });

  group('setSelfGrade', () {
    const gradePath = '/flashcards/cards/card-1/self-grade';

    test(
      'PUTs the grade by its contract spelling and returns nothing',
      () async {
        when(
          () => dio.put<void>(gradePath, data: any(named: 'data')),
        ).thenAnswer((_) async => response<void>(null, status: 204));

        await repo.setSelfGrade('card-1', FlashcardSelfGrade.gotIt);

        final captured = verify(
          () => dio.put<void>(gradePath, data: captureAny(named: 'data')),
        ).captured.single;
        // `gotIt` / `again` are the wire values, not a snake_case bridge.
        expect(captured, {'grade': 'gotIt'});
      },
    );

    test('again is spelled again', () async {
      when(
        () => dio.put<void>(gradePath, data: any(named: 'data')),
      ).thenAnswer((_) async => response<void>(null, status: 204));

      await repo.setSelfGrade('card-1', FlashcardSelfGrade.again);

      final captured = verify(
        () => dio.put<void>(gradePath, data: captureAny(named: 'data')),
      ).captured.single;
      expect(captured, {'grade': 'again'});
    });

    test(
      'surfaces insufficient_scope — there is no existence oracle',
      () async {
        // Grading a card that exists but was never shown to you is the SAME 403
        // as a card that does not exist. flashcard_subscription_required is
        // deliberately never returned here.
        when(
          () => dio.put<void>(gradePath, data: any(named: 'data')),
        ).thenThrow(
          failure(const ApiException(status: 403, code: 'insufficient_scope')),
        );

        await expectLater(
          repo.setSelfGrade('card-1', FlashcardSelfGrade.again),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              'insufficient_scope',
            ),
          ),
        );
      },
    );
  });
}
