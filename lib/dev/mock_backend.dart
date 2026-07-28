/// Throwaway on-device preview harness — NOT production code.
///
/// A hand-rolled Dio interceptor that answers the stable `/auth/*` and
/// `/reference/*` endpoints with contract-faithful canned JSON, so the whole
/// login → OTP → registration walk can be driven on a real device with no
/// server and no network at all (`AppConfig.baseUrl` is still TBD).
///
/// Deliberately hand-rolled rather than `http_mock_adapter`: adding a
/// dev_dependency would mean editing `pubspec.yaml`, and this harness is meant
/// to be 100% additive — two new files, zero edits to anything that ships.
///
/// Referenced ONLY by `lib/main_mock.dart`. Nothing under `lib/features` or
/// `lib/core` knows this file exists; injection happens through a single
/// `dioProvider` override in that entrypoint's `ProviderScope`.
///
/// Shapes are taken from `contract/openapi.yaml` (commit 23f0535) so the canned
/// JSON parses into the REAL freezed models — if a model changes and the mock
/// stops parsing, that is the harness doing its job.
library;

import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/interceptors/error_interceptor.dart';

/// Builds the Dio that replaces the real client for the mock run.
///
/// The chain is [MockBackendInterceptor] then the REAL [ErrorInterceptor], so
/// any non-2xx the mock produces still maps to the typed `AppException`
/// hierarchy exactly as it would in production.
///
/// There is no `AuthInterceptor`: the mock never answers 401, so the Bearer +
/// refresh/retry path is unreachable here anyway, and leaving it out keeps the
/// harness from depending on `AuthController`/`AuthRepository` wiring.
Dio buildMockDio({Duration latency = const Duration(milliseconds: 300)}) {
  final dio = Dio(
    BaseOptions(
      // Never resolved — the interceptor short-circuits every request before it
      // reaches a socket. Present only so Dio can build absolute URIs.
      baseUrl: 'http://mock.local/api/v1',
      headers: const {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.addAll([MockBackendInterceptor(latency: latency), ErrorInterceptor()]);
  return dio;
}

/// Short-circuits every request with a canned response.
///
/// [latency] is real (not zero) on purpose: the loading state of every picker
/// and button is part of what this harness exists to let you look at.
class MockBackendInterceptor extends Interceptor {
  MockBackendInterceptor({this.latency = const Duration(milliseconds: 300)});

  final Duration latency;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(latency);

    final path = options.path;
    final method = options.method.toUpperCase();
    final query = options.queryParameters;
    final body = options.data is Map ? Map<String, dynamic>.from(options.data as Map) : const <String, dynamic>{};

    // ---- auth -------------------------------------------------------------
    if (method == 'POST' && path == '/auth/otp/request') {
      return _ok(handler, options, 202, <String, dynamic>{
        'resendAfterSeconds': 60,
        'expiresInSeconds': 300,
      });
    }

    if (method == 'POST' && path == '/auth/otp/verify') {
      final code = body['code'] as String? ?? '';
      final phone = body['phone'] as String? ?? '+201001234567';
      // The magic code lands you straight on /home with a full session; every
      // other 6-digit code forks to registration so the wizard can be walked.
      if (code == _kAuthenticatedCode) {
        return _ok(handler, options, 200, <String, dynamic>{
          'result': 'authenticated',
          'tokens': _tokenPair(),
          'profile': _schoolProfile(phone: phone),
        });
      }
      return _ok(handler, options, 200, <String, dynamic>{
        'result': 'registrationRequired',
        'registrationToken': 'mock.registration.token',
        'expiresInSeconds': 600,
      });
    }

    if (method == 'POST' && path == '/auth/register') {
      return _ok(handler, options, 201, <String, dynamic>{
        'result': 'authenticated',
        'tokens': _tokenPair(),
        'profile': _profileFromRegistration(body),
      });
    }

    if (method == 'POST' && path == '/auth/refresh') {
      return _ok(handler, options, 200, _tokenPair());
    }

    if (method == 'POST' && path == '/auth/logout') {
      return _ok(handler, options, 204, null);
    }

    // ---- profile ----------------------------------------------------------
    // Home is powered entirely by GET /me, so without this the whole tab
    // renders its error state on device.
    if (method == 'GET' && path == '/me') {
      return _ok(handler, options, 200, _schoolProfile(phone: '+201021871999'));
    }

    if (method == 'GET' && path == '/me/entitlements') {
      return _ok(handler, options, 200, <String, dynamic>{
        'items': _entitlements,
      });
    }

    // ---- reference --------------------------------------------------------
    if (method == 'GET' && path == '/reference/countries') {
      return _ok(handler, options, 200, _countries);
    }

    final governorates = RegExp(r'^/reference/countries/([^/]+)/governorates$').firstMatch(path);
    if (method == 'GET' && governorates != null) {
      final code = governorates.group(1);
      // Contract: bare array, EMPTY for non-EG.
      return _ok(handler, options, 200, code == 'EG' ? _egGovernorates : <dynamic>[]);
    }

    if (method == 'GET' && path == '/reference/cities') {
      return _ok(handler, options, 200, _citiesFor(
        countryCode: query['countryCode'] as String?,
        governorateId: query['governorateId'] as String?,
      ));
    }

    if (method == 'GET' && path == '/reference/schools') {
      return _ok(handler, options, 200, _schoolPage(
        q: query['q'] as String?,
        cursor: query['cursor'] as String?,
        limit: query['limit'] as int? ?? 20,
      ));
    }

    if (method == 'GET' && path == '/reference/education-systems') {
      return _ok(handler, options, 200, _educationSystems);
    }

    if (method == 'GET' && path == '/reference/universities') {
      return _ok(handler, options, 200, _universities);
    }

    if (method == 'GET' && path == '/reference/avatars') {
      return _ok(handler, options, 200, _avatars);
    }

    // Anything not mocked fails loudly as a contract-shaped 404 rather than
    // hanging on a socket — an unmocked call should be obvious, not silent.
    return _problem(handler, options, 404, 'not_found', 'No mock for $method $path');
  }

  void _ok(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    Object? data,
  ) {
    handler.resolve(
      Response<dynamic>(requestOptions: options, statusCode: status, data: data),
    );
  }

  /// RFC 9457 ProblemDetails, rejected THROUGH the real ErrorInterceptor
  /// (`callFollowingErrorInterceptor: true`) so it arrives at the repository as
  /// a typed `AppException`, exactly as a real failure would.
  void _problem(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    String code,
    String detail,
  ) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: status,
          data: <String, dynamic>{
            'title': detail,
            'status': status,
            'code': code,
            'detail': detail,
          },
        ),
      ),
      true,
    );
  }
}

/// Enter this at the OTP screen to skip registration and land on `/home`.
const _kAuthenticatedCode = '000000';

// ---------------------------------------------------------------------------
// Canned data
// ---------------------------------------------------------------------------

Map<String, dynamic> _tokenPair() => <String, dynamic>{
      'accessToken': 'mock.access.token',
      'accessExpiresInSeconds': 900,
      'refreshToken': 'mock.refresh.token',
      'refreshExpiresInSeconds': 5184000,
    };

final _countries = <dynamic>[
  <String, dynamic>{
    'code': 'EG',
    'nameAr': 'مصر',
    'nameEn': 'Egypt',
    'requiresGovernorate': true,
  },
  <String, dynamic>{
    'code': 'AE',
    'nameAr': 'الإمارات العربية المتحدة',
    'nameEn': 'United Arab Emirates',
    'requiresGovernorate': false,
  },
];

Map<String, dynamic> _named(String id, String ar, String en) =>
    <String, dynamic>{'id': id, 'nameAr': ar, 'nameEn': en};

final _egGovernorates = <dynamic>[
  _named('0197b2f3-0001-7cc3-9b4e-000000000001', 'القاهرة', 'Cairo'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000002', 'الجيزة', 'Giza'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000003', 'الإسكندرية', 'Alexandria'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000004', 'الدقهلية', 'Dakahlia'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000005', 'أسيوط', 'Asyut'),
];

/// EG cities are keyed by governorate (the contract 400s on EG without one);
/// non-EG countries get a flat list keyed by country code.
List<dynamic> _citiesFor({String? countryCode, String? governorateId}) {
  if (countryCode == 'EG') {
    return switch (governorateId) {
      '0197b2f3-0001-7cc3-9b4e-000000000001' => <dynamic>[
          _named('0197b2f3-0002-7cc3-9b4e-000000000001', 'مدينة نصر', 'Nasr City'),
          _named('0197b2f3-0002-7cc3-9b4e-000000000002', 'المعادي', 'Maadi'),
          _named('0197b2f3-0002-7cc3-9b4e-000000000003', 'مصر الجديدة', 'Heliopolis'),
        ],
      '0197b2f3-0001-7cc3-9b4e-000000000002' => <dynamic>[
          _named('0197b2f3-0002-7cc3-9b4e-000000000004', 'الدقي', 'Dokki'),
          _named('0197b2f3-0002-7cc3-9b4e-000000000005', '٦ أكتوبر', '6th of October'),
        ],
      '0197b2f3-0001-7cc3-9b4e-000000000003' => <dynamic>[
          _named('0197b2f3-0002-7cc3-9b4e-000000000006', 'سموحة', 'Smouha'),
          _named('0197b2f3-0002-7cc3-9b4e-000000000007', 'ميامي', 'Miami'),
        ],
      // A governorate with no cities — the Empty state, on purpose.
      '0197b2f3-0001-7cc3-9b4e-000000000005' => <dynamic>[],
      _ => <dynamic>[
          _named('0197b2f3-0002-7cc3-9b4e-000000000008', 'المنصورة', 'Mansoura'),
          _named('0197b2f3-0002-7cc3-9b4e-000000000009', 'طلخا', 'Talkha'),
        ],
    };
  }
  return <dynamic>[
    _named('0197b2f3-0003-7cc3-9b4e-000000000001', 'دبي', 'Dubai'),
    _named('0197b2f3-0003-7cc3-9b4e-000000000002', 'أبو ظبي', 'Abu Dhabi'),
    _named('0197b2f3-0003-7cc3-9b4e-000000000003', 'الشارقة', 'Sharjah'),
  ];
}

/// 47 schools — enough that a 20-per-page cursor walk needs three pages, so
/// "load more" and the final "no more results" both render.
final _allSchools = <Map<String, dynamic>>[
  for (var i = 1; i <= 47; i++)
    _named(
      '0197b2f3-0004-7cc3-9b4e-${i.toString().padLeft(12, '0')}',
      'مدرسة رقم $i الرسمية',
      'Al Nasr Language School $i',
    ),
];

/// `CursorPage<NamedRef>`. The cursor is an opaque base64 offset — the client
/// only ever echoes it back, which is exactly the contract's contract.
Map<String, dynamic> _schoolPage({String? q, String? cursor, required int limit}) {
  final needle = (q ?? '').trim().toLowerCase();
  final matches = needle.isEmpty
      ? _allSchools
      : _allSchools.where((s) {
          final en = (s['nameEn']! as String).toLowerCase();
          final ar = s['nameAr']! as String;
          return en.contains(needle) || ar.contains(needle);
        }).toList();

  final offset = _decodeCursor(cursor);
  final end = (offset + limit).clamp(0, matches.length);
  final page = matches.sublist(offset.clamp(0, matches.length), end);
  final hasMore = end < matches.length;

  return <String, dynamic>{
    'items': <dynamic>[...page],
    'nextCursor': hasMore ? _encodeCursor(end) : null,
    'hasMore': hasMore,
  };
}

String _encodeCursor(int offset) => base64Url.encode(utf8.encode('offset:$offset'));

int _decodeCursor(String? cursor) {
  if (cursor == null || cursor.isEmpty) return 0;
  try {
    final decoded = utf8.decode(base64Url.decode(cursor));
    return int.tryParse(decoded.split(':').last) ?? 0;
  } on FormatException {
    return 0;
  }
}

final _educationSystems = <dynamic>[
  <String, dynamic>{'code': 'nationalArabic', 'nameAr': 'الوطني عربي', 'nameEn': 'National (Arabic)'},
  <String, dynamic>{'code': 'nationalLanguages', 'nameAr': 'الوطني لغات', 'nameEn': 'National (Languages)'},
  <String, dynamic>{'code': 'ig', 'nameAr': 'آي جي', 'nameEn': 'IG'},
  <String, dynamic>{'code': 'american', 'nameAr': 'أمريكي', 'nameEn': 'American'},
  <String, dynamic>{'code': 'ib', 'nameAr': 'البكالوريا الدولية', 'nameEn': 'IB'},
];

Map<String, dynamic> _year(String id, int number, String status) =>
    <String, dynamic>{'id': id, 'yearNumber': number, 'status': status};

/// Two universities → Human Medicine + Pharmacy → data-driven years carrying
/// BOTH `active` and `soon`, so the year filtering is visible.
final _universities = <dynamic>[
  <String, dynamic>{
    'id': '0197b2f3-0005-7cc3-9b4e-000000000001',
    'nameAr': 'جامعة القاهرة',
    'nameEn': 'Cairo University',
    'faculties': <dynamic>[
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000001',
        'nameAr': 'كلية الطب البشري',
        'nameEn': 'Faculty of Human Medicine',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000001', 1, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000002', 2, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000003', 3, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000004', 4, 'soon'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000005', 5, 'soon'),
        ],
      },
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000002',
        'nameAr': 'كلية الصيدلة',
        'nameEn': 'Faculty of Pharmacy',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000006', 1, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000007', 2, 'soon'),
        ],
      },
    ],
  },
  <String, dynamic>{
    'id': '0197b2f3-0005-7cc3-9b4e-000000000002',
    'nameAr': 'جامعة عين شمس',
    'nameEn': 'Ain Shams University',
    'faculties': <dynamic>[
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000003',
        'nameAr': 'كلية الطب البشري',
        'nameEn': 'Faculty of Human Medicine',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000008', 1, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000009', 2, 'soon'),
        ],
      },
      // A faculty whose years are ALL `soon` — the Empty year list.
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000004',
        'nameAr': 'كلية الصيدلة',
        'nameEn': 'Faculty of Pharmacy',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000010', 1, 'soon'),
        ],
      },
    ],
  },
];

/// NOTE: these are remote URLs — the only thing in this harness that is not
/// offline. Nothing renders them today (the avatar grid was deliberately not
/// built), so the mock is still fully usable on a plane.
final _avatars = <dynamic>[
  for (var i = 1; i <= 6; i++)
    <String, dynamic>{
      'id': '0197b2f3-0008-7cc3-9b4e-${i.toString().padLeft(12, '0')}',
      'url': 'https://picsum.photos/seed/levelup$i/200',
    },
];

// ---------------------------------------------------------------------------
// StudentProfile
// ---------------------------------------------------------------------------

/// Echoes the submitted registration back as a `StudentProfile`, so what lands
/// on `/home` reflects what you actually typed.
Map<String, dynamic> _profileFromRegistration(Map<String, dynamic> body) {
  final isUniversity = body['track'] == 'university';
  return _profile(
    track: isUniversity ? 'university' : 'school',
    name: body['name'] as String? ?? 'Mock Student',
    phone: '+201001234567',
    dateOfBirth: body['dateOfBirth'] as String? ?? '2008-01-01',
    countryCode: isUniversity ? 'EG' : (body['countryCode'] as String? ?? 'EG'),
    school: isUniversity
        ? null
        : <String, dynamic>{
            'school': body['schoolId'] == null
                ? null
                : _named(body['schoolId']! as String, 'مدرسة مختارة', 'Selected School'),
            'schoolName': body['schoolName'],
            'stage': body['stage'] ?? 'secondary1',
            'educationSystem': body['educationSystem'] ?? 'nationalLanguages',
          },
    university: !isUniversity
        ? null
        : <String, dynamic>{
            'university': _named(
              body['universityId']! as String,
              'جامعة مختارة',
              'Selected University',
            ),
            'faculty': _named(
              body['facultyId']! as String,
              'كلية مختارة',
              'Selected Faculty',
            ),
            'yearNumber': 1,
          },
  );
}

Map<String, dynamic> _schoolProfile({required String phone}) => _profile(
      track: 'school',
      name: 'طالب تجريبي',
      phone: phone,
      dateOfBirth: '2008-05-14',
      countryCode: 'EG',
      school: <String, dynamic>{
        'school': _named('0197b2f3-0004-7cc3-9b4e-000000000001', 'مدرسة رقم ١', 'Al Nasr Language School 1'),
        'schoolName': null,
        'stage': 'secondary2',
        'educationSystem': 'nationalLanguages',
      },
      university: null,
    );

Map<String, dynamic> _profile({
  required String track,
  required String name,
  required String phone,
  required String dateOfBirth,
  required String countryCode,
  required Map<String, dynamic>? school,
  required Map<String, dynamic>? university,
}) {
  return <String, dynamic>{
    'id': '0197b2f3-9999-7cc3-9b4e-000000000001',
    'track': track,
    'name': name,
    'phone': phone,
    'email': null,
    'dateOfBirth': dateOfBirth,
    'avatar': <String, dynamic>{
      'type': 'default',
      'id': '0197b2f3-0008-7cc3-9b4e-000000000001',
      'url': 'https://picsum.photos/seed/levelup1/200',
    },
    'geography': <String, dynamic>{
      'countryCode': countryCode,
      'governorate': countryCode == 'EG' ? _egGovernorates.first : null,
      'city': _named('0197b2f3-0002-7cc3-9b4e-000000000001', 'مدينة نصر', 'Nasr City'),
    },
    'school': school,
    'university': university,
    // Server-authoritative — the app must display these, never recompute them.
    'points': <String, dynamic>{'school': 1250, 'university': 0, 'total': 1250},
    'level': 3,
    'badges': 0,
    'privacy': <String, dynamic>{'leaderboardVisible': true, 'scoreHidden': false},
    'entitlements': _entitlements,
    'createdAt': '2026-07-26T10:00:00Z',
  };
}

/// Shared by the `/me` embed and `GET /me/entitlements` — the same student can't
/// have two different subscription truths depending on which call you made.
final _entitlements = <dynamic>[
  <String, dynamic>{
    'type': 'baseSubscription',
    'active': false,
    'expiresAt': null,
    'inGrace': false,
    'graceEndsAt': null,
  },
];
