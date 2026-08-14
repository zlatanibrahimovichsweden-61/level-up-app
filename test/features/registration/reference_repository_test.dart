import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

Response<T> _ok<T>(T data) => Response<T>(
  requestOptions: RequestOptions(path: '/'),
  statusCode: 200,
  data: data,
);

DioException _dioError(Object mapped) => DioException(
  requestOptions: RequestOptions(path: '/'),
  error: mapped, // the ErrorInterceptor already put an AppException here
);

void main() {
  late MockDio dio;
  late ReferenceRepository repo;

  setUp(() {
    dio = MockDio();
    repo = ReferenceRepository(dio);
  });

  group('fromJson — payloads copied from the contract', () {
    test('countries parse code/names/requiresGovernorate', () async {
      when(() => dio.get<List<dynamic>>('/reference/countries')).thenAnswer(
        (_) async => _ok<List<dynamic>>([
          {
            'code': 'EG',
            'nameAr': 'مصر',
            'nameEn': 'Egypt',
            'requiresGovernorate': true,
          },
          {
            'code': 'AE',
            'nameAr': 'الإمارات',
            'nameEn': 'UAE',
            'requiresGovernorate': false,
          },
        ]),
      );

      final countries = await repo.getCountries();
      expect(countries, hasLength(2));
      expect(countries.first.code, 'EG');
      expect(countries.first.requiresGovernorate, isTrue);
      expect(countries[1].requiresGovernorate, isFalse);
    });

    test('governorates parse as NamedRef', () async {
      when(
        () => dio.get<List<dynamic>>('/reference/countries/EG/governorates'),
      ).thenAnswer(
        (_) async => _ok<List<dynamic>>([
          {'id': 'gov-1', 'nameAr': 'القاهرة', 'nameEn': 'Cairo'},
        ]),
      );

      final govs = await repo.getGovernorates('EG');
      expect(
        govs.single,
        const NamedRef(id: 'gov-1', nameAr: 'القاهرة', nameEn: 'Cairo'),
      );
    });

    test(
      'cities pass countryCode + governorateId and parse as NamedRef',
      () async {
        when(
          () => dio.get<List<dynamic>>(
            '/reference/cities',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => _ok<List<dynamic>>([
            {'id': 'city-1', 'nameAr': 'مدينة نصر', 'nameEn': 'Nasr City'},
          ]),
        );

        final cities = await repo.getCities(
          countryCode: 'EG',
          governorateId: 'gov-1',
        );
        expect(cities.single.nameEn, 'Nasr City');
        final captured =
            verify(
                  () => dio.get<List<dynamic>>(
                    '/reference/cities',
                    queryParameters: captureAny(named: 'queryParameters'),
                  ),
                ).captured.single
                as Map<String, dynamic>;
        expect(captured['countryCode'], 'EG');
        expect(captured['governorateId'], 'gov-1');
      },
    );

    test('schools parse the CursorPage<NamedRef> envelope', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/reference/schools',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => _ok<Map<String, dynamic>>({
          'items': [
            {'id': 'sch-1', 'nameAr': 'مدرسة', 'nameEn': 'A School'},
          ],
          'nextCursor': 'CURSOR_B64',
          'hasMore': true,
        }),
      );

      final page = await repo.searchSchools(q: 'sch', governorateId: 'gov-1');
      expect(page.items.single.id, 'sch-1');
      expect(page.nextCursor, 'CURSOR_B64');
      expect(page.hasMore, isTrue);
    });

    test('schools tolerate a null nextCursor (last page)', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/reference/schools',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => _ok<Map<String, dynamic>>({
          'items': <dynamic>[],
          'nextCursor': null,
          'hasMore': false,
        }),
      );

      final page = await repo.searchSchools();
      expect(page.items, isEmpty);
      expect(page.nextCursor, isNull);
      expect(page.hasMore, isFalse);
    });

    test('education systems parse code/names', () async {
      when(
        () => dio.get<List<dynamic>>('/reference/education-systems'),
      ).thenAnswer(
        (_) async => _ok<List<dynamic>>([
          {
            'code': 'nationalArabic',
            'nameAr': 'قومي عربي',
            'nameEn': 'National (Arabic)',
          },
          {'code': 'ig', 'nameAr': 'آي جي', 'nameEn': 'IG'},
        ]),
      );

      final systems = await repo.getEducationSystems();
      expect(systems.map((s) => s.code), ['nationalArabic', 'ig']);
    });

    test(
      'universities parse the nested university→faculty→year tree',
      () async {
        when(
          () => dio.get<List<dynamic>>('/reference/universities'),
        ).thenAnswer(
          (_) async => _ok<List<dynamic>>([
            {
              'id': 'uni-1',
              'nameAr': 'جامعة',
              'nameEn': 'A University',
              'faculties': [
                {
                  'id': 'fac-1',
                  'nameAr': 'طب',
                  'nameEn': 'Medicine',
                  'years': [
                    {'id': 'yr-1', 'yearNumber': 1, 'status': 'active'},
                    {'id': 'yr-2', 'yearNumber': 2, 'status': 'soon'},
                  ],
                },
              ],
            },
          ]),
        );

        final unis = await repo.getUniversities();
        final year = unis.single.faculties.single.years;
        expect(year.first.status, 'active');
        expect(year[1].status, 'soon');
        expect(year.first.yearNumber, 1);
      },
    );

    test('avatars parse id/url', () async {
      when(() => dio.get<List<dynamic>>('/reference/avatars')).thenAnswer(
        (_) async => _ok<List<dynamic>>([
          {'id': 'av-1', 'url': 'https://cdn.example/av1.png'},
        ]),
      );

      final avatars = await repo.getAvatars();
      expect(avatars.single.url, 'https://cdn.example/av1.png');
    });
  });

  group('fromJson — contract drift surfaces (required-missing throws)', () {
    test('Country without requiresGovernorate throws', () {
      expect(
        () => Country.fromJson({
          'code': 'EG',
          'nameAr': 'مصر',
          'nameEn': 'Egypt',
        }),
        throwsA(anything),
      );
    });

    test('NamedRef without id throws', () {
      expect(
        () => NamedRef.fromJson({'nameAr': 'x', 'nameEn': 'y'}),
        throwsA(anything),
      );
    });
  });

  group('error mapping — DioException.error surfaces as its AppException', () {
    test('offline maps to OfflineException', () async {
      when(
        () => dio.get<List<dynamic>>('/reference/countries'),
      ).thenThrow(_dioError(const OfflineException()));
      await expectLater(repo.getCountries(), throwsA(isA<OfflineException>()));
    });

    test(
      'a bare/unmapped DioException falls back to UnknownException',
      () async {
        when(
          () => dio.get<List<dynamic>>('/reference/avatars'),
        ).thenThrow(_dioError('not an AppException'));
        await expectLater(repo.getAvatars(), throwsA(isA<UnknownException>()));
      },
    );
  });
}
