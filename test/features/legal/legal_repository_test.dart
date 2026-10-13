import 'dart:io';
import 'dart:ui' show Locale;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/legal/legal_error_copy.dart';
import 'package:level_up_app/features/legal/legal_links.dart';
import 'package:level_up_app/features/legal/models/legal_document.dart';
import 'package:level_up_app/features/legal/repository/legal_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// The legal data layer (CW04a): one stable, public operation,
/// `getLegalDocument`, decoded strictly, failures passed on as the typed
/// exceptions the interceptor made — plus the copy funnel and the link fence.
void main() {
  late _MockDio dio;
  late LegalRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = LegalRepository(dio);
  });

  const body = <String, dynamic>{
    'document': 'terms',
    'version': 'r4-2026-10-07',
    'language': 'ar',
    'title': 'Fixture title line',
    'contentMarkdown': '# Fixture title line\n\nA paragraph.\n',
  };

  void stubGet(Object answer) {
    final call = when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    );
    if (answer is Map<String, dynamic>) {
      call.thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 200,
          data: answer,
        ),
      );
    } else {
      call.thenThrow(answer);
    }
  }

  group('getLegalDocument', () {
    for (final document in LegalDocument.values) {
      for (final language in ['ar', 'en']) {
        test('${document.name} · $language: the path and the one query '
            'parameter', () async {
          stubGet({...body, 'document': document.wireValue});
          await repo.getLegalDocument(document, language: language);

          final captured = verify(
            () => dio.get<Map<String, dynamic>>(
              captureAny(),
              queryParameters: captureAny(named: 'queryParameters'),
            ),
          ).captured;
          expect(captured[0], '/reference/legal-documents/${document.name}');
          expect(captured[1], {'language': language});
        });
      }
    }

    test('decodes the five fields, the text verbatim', () async {
      stubGet(body);
      final content = await repo.getLegalDocument(
        LegalDocument.terms,
        language: 'ar',
      );

      expect(content.document, 'terms');
      expect(content.version, 'r4-2026-10-07');
      expect(content.language, 'ar');
      expect(content.title, 'Fixture title line');
      expect(content.contentMarkdown, body['contentMarkdown']);
    });

    for (final field in body.keys) {
      test('a body without `$field` is a typed failure, not a page', () {
        stubGet({...body}..remove(field));
        expect(
          repo.getLegalDocument(LegalDocument.terms, language: 'en'),
          throwsA(isA<UnknownException>()),
        );
      });
    }

    final mapped = <String, AppException>{
      '404 legal_document_unavailable': const ApiException(
        status: 404,
        code: 'legal_document_unavailable',
      ),
      '429 rate_limited': const RateLimitedException(
        retryAfter: Duration(seconds: 12),
      ),
      'offline': const NetworkException(detail: 'connection error'),
      '400 validation_failed': const ValidationException(
        errors: {
          'language': ['bad'],
        },
      ),
    };
    for (final MapEntry(key: label, value: error) in mapped.entries) {
      test('$label is passed on as the interceptor typed it', () {
        stubGet(
          DioException(
            requestOptions: RequestOptions(path: '/x'),
            error: error,
          ),
        );
        expect(
          repo.getLegalDocument(LegalDocument.privacy, language: 'en'),
          throwsA(same(error)),
        );
      });
    }

    test('a Dio failure the interceptor did not type is UnknownException', () {
      stubGet(DioException(requestOptions: RequestOptions(path: '/x')));
      expect(
        repo.getLegalDocument(LegalDocument.privacy, language: 'en'),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  test('the pinned contract still requires exactly the five modelled '
      'fields', () {
    final lines = File('contract/openapi.yaml').readAsLinesSync();
    final start = lines.indexOf('  /reference/legal-documents/{document}:');
    expect(start, isNot(-1));
    final operation = lines
        .skip(start)
        .takeWhile(
          (line) => line == lines[start] || !RegExp(r'^  /').hasMatch(line),
        );
    expect(operation.join('\n'), contains('operationId: getLegalDocument'));
    expect(operation.join('\n'), contains('x-stability: stable'));
    expect(operation.join('\n'), contains('security: []'));
    final required = operation
        .map((line) => RegExp(r'^\s+required: \[(.*)\]$').firstMatch(line))
        .whereType<RegExpMatch>()
        .single
        .group(1)!
        .split(',')
        .map((name) => name.trim())
        .toSet();
    expect(required, {
      'document',
      'version',
      'language',
      'title',
      'contentMarkdown',
    });
    // …and each is one the model will not do without (see the decode tests).
    expect(required, body.keys.toSet());
  });

  group('language', () {
    test('Arabic asks for ar; everything else for en', () {
      expect(legalLanguageFor(const Locale('ar')), 'ar');
      expect(legalLanguageFor(const Locale('ar', 'EG')), 'ar');
      expect(legalLanguageFor(const Locale('en')), 'en');
      expect(legalLanguageFor(const Locale('fr')), 'en');
    });
  });

  group('the copy funnel (existing approved lines only)', () {
    for (final language in ['en', 'ar']) {
      final l10n = lookupAppLocalizations(Locale(language));
      test(language, () {
        expect(
          legalFailureText(
            l10n,
            const ApiException(status: 404, code: 'legal_document_unavailable'),
          ),
          l10n.legalNotPublished,
        );
        expect(
          legalFailureText(
            l10n,
            const RateLimitedException(retryAfter: Duration(seconds: 7)),
          ),
          l10n.rateLimitedIn(7),
        );
        expect(
          legalFailureText(l10n, const RateLimitedException()),
          l10n.rateLimited,
        );
        expect(
          legalFailureText(
            l10n,
            const ApiException(status: 404, code: 'not_found'),
          ),
          l10n.genericError,
        );
        expect(
          legalFailureText(
            l10n,
            const ApiException(status: 500, code: 'internal_error'),
          ),
          l10n.genericError,
        );
        expect(
          legalFailureText(
            l10n,
            const ApiException(status: 500, code: 'unknown'),
          ),
          l10n.genericError,
        );
      });
    }

    test('Retry is withheld only for an unavailable document', () {
      expect(
        legalRetryAllowed(
          const ApiException(status: 404, code: 'legal_document_unavailable'),
        ),
        isFalse,
      );
      for (final error in <Object>[
        const RateLimitedException(),
        const NetworkException(),
        const ApiException(status: 404, code: 'not_found'),
        const ApiException(status: 500, code: 'internal_error'),
        const UnknownException(),
      ]) {
        expect(legalRetryAllowed(error), isTrue, reason: '$error');
      }
    });
  });

  group('the link fence', () {
    test('https with a host and mailto with an address pass', () {
      expect(
        safeLegalLink('https://levelup.test/terms'),
        Uri.parse('https://levelup.test/terms'),
      );
      expect(safeLegalLink(' HTTPS://levelup.test '), isNotNull);
      expect(
        safeLegalLink('mailto:privacy@levelup.test'),
        Uri.parse('mailto:privacy@levelup.test'),
      );
    });

    test('everything else is refused', () {
      for (final href in [
        null,
        '',
        'http://levelup.test',
        'https://',
        'mailto:',
        'javascript:alert(1)',
        'data:text/html,hi',
        'file:///etc/hosts',
        'intent://levelup.test#Intent;end',
        'tel:+2010000000001',
        '/legal/terms',
        'legal/terms',
        '//levelup.test/x',
        ':::',
      ]) {
        expect(safeLegalLink(href), isNull, reason: '$href');
      }
    });

    test(
      'a refused link opens nothing; a failing launcher is swallowed',
      () async {
        final opened = <Uri>[];
        Future<bool> launch(Uri uri) async {
          opened.add(uri);
          return true;
        }

        await openLegalLink(launch, 'javascript:alert(1)');
        expect(opened, isEmpty);
        await openLegalLink(launch, 'https://levelup.test/a');
        expect(opened, [Uri.parse('https://levelup.test/a')]);

        await openLegalLink(
          (_) async => throw Exception('no browser'),
          'https://levelup.test/a',
        );
      },
    );
  });
}
