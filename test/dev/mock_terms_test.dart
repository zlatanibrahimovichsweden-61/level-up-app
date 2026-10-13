import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_terms.dart';
import 'package:level_up_app/features/legal/models/terms_acceptance.dart';
import 'package:level_up_app/features/legal/repository/terms_repository.dart';

/// The mock's Terms acceptance (CW04b): `mock_terms.dart`, the module that
/// `mock_backend.dart` dispatches to. Its state and its contract rules are
/// tested here directly; the end-to-end group at the bottom drives the same
/// module THROUGH `buildMockDio` and the real [TermsRepository], so it fails if
/// the dispatch hook is ever dropped from `mock_backend.dart`.
void main() {
  final fixedNow = DateTime.utc(2026, 10, 12, 8, 15, 30);

  MockTermsAcceptance mock({
    String? currentVersion = kMockTermsVersion,
    String? acceptedVersion,
    DateTime? acceptedAt,
  }) => MockTermsAcceptance(
    currentVersion: currentVersion,
    acceptedVersion: acceptedVersion,
    acceptedAt: acceptedAt,
    clock: () => fixedNow,
  );

  TermsAcceptance read(MockTermsAcceptance m) {
    final reply = m.handle('GET', '/me/terms-acceptance', const {});
    expect(reply, isA<MockTermsOk>());
    final ok = reply! as MockTermsOk;
    expect(ok.status, 200);
    // Parsed by the REAL model: if a model changes and the mock stops parsing,
    // this is the harness doing its job.
    return TermsAcceptance.fromJson(ok.data!);
  }

  MockTermsReply? post(MockTermsAcceptance m, Object? termsVersion) =>
      m.handle('POST', '/me/terms-acceptance', {'termsVersion': ?termsVersion});

  group('GET - the states of the contract', () {
    test('starts not accepted, with a version configured', () {
      final t = read(mock());
      expect(t.currentVersion, kMockTermsVersion);
      expect(t.acceptedVersion, isNull);
      expect(t.acceptedAtUtc, isNull);
      expect(t.isCurrent, isFalse);
    });

    test(
      'nothing configured: currentVersion null, isCurrent false (inert)',
      () {
        final t = read(mock(currentVersion: null));
        expect(t.isInert, isTrue);
        expect(t.isCurrent, isFalse);
      },
    );

    test('accepted and current', () {
      final at = DateTime.utc(2026, 10, 1, 7);
      final t = read(mock(acceptedVersion: kMockTermsVersion, acceptedAt: at));
      expect(t.isCurrent, isTrue);
      expect(t.acceptedAtUtc, at);
    });

    test('an older acceptance does not make the student current', () {
      final t = read(mock(acceptedVersion: 'older', acceptedAt: fixedNow));
      expect(t.acceptedVersion, 'older');
      expect(t.currentVersion, kMockTermsVersion);
      expect(t.isCurrent, isFalse);
    });
  });

  group('POST - acceptTerms', () {
    test('the current version is recorded: 204, then the GET agrees', () {
      final m = mock();
      final reply = post(m, kMockTermsVersion);

      expect(reply, isA<MockTermsOk>());
      final ok = reply! as MockTermsOk;
      expect(ok.status, 204);
      expect(ok.data, isNull);

      final t = read(m);
      expect(t.isCurrent, isTrue);
      expect(t.acceptedVersion, kMockTermsVersion);
      // The server records the time (here: the mock's clock), in UTC.
      expect(t.acceptedAtUtc, fixedNow);
    });

    test(
      'idempotent: a repeat is 204 and the FIRST acceptance time stands',
      () {
        var now = fixedNow;
        final m = MockTermsAcceptance(clock: () => now);
        expect((post(m, kMockTermsVersion)! as MockTermsOk).status, 204);

        now = fixedNow.add(const Duration(days: 3));
        expect((post(m, kMockTermsVersion)! as MockTermsOk).status, 204);

        expect(read(m).acceptedAtUtc, fixedNow);
      },
    );

    test('a later version is a new record; the earlier one is replaced as '
        '"most recent" and the student is not current until they accept', () {
      var now = fixedNow;
      final m = MockTermsAcceptance(clock: () => now);
      post(m, kMockTermsVersion);

      m.requireVersion('mock-sample-2');
      var t = read(m);
      expect(t.currentVersion, 'mock-sample-2');
      expect(t.acceptedVersion, kMockTermsVersion);
      expect(t.isCurrent, isFalse);

      now = fixedNow.add(const Duration(days: 40));
      post(m, 'mock-sample-2');
      t = read(m);
      expect(t.isCurrent, isTrue);
      expect(t.acceptedVersion, 'mock-sample-2');
      expect(t.acceptedAtUtc, now);
    });

    final rejected = <String, Object?>{
      'a different version': 'not-the-current-one',
      'an empty version': '',
      'a number': 4,
      'null': null,
    };
    for (final MapEntry(key: label, value: sent) in rejected.entries) {
      test('$label is 400 validation_failed on termsVersion, and nothing is '
          'recorded', () {
        final m = mock();
        final reply = m.handle('POST', '/me/terms-acceptance', {
          'termsVersion': sent,
        });

        expect(reply, isA<MockTermsValidation>());
        expect((reply! as MockTermsValidation).errors.keys, ['termsVersion']);
        expect(read(m).acceptedVersion, isNull);
      });
    }

    test('an absent termsVersion is 400 validation_failed', () {
      final reply = mock().handle('POST', '/me/terms-acceptance', const {});
      expect((reply! as MockTermsValidation).errors.keys, ['termsVersion']);
    });

    test('the refusal never names the required version', () {
      final reply = post(mock(), 'wrong')! as MockTermsValidation;
      final messages = reply.errors.values.expand((m) => m).join(' ');
      expect(messages, isNot(contains(kMockTermsVersion)));
    });

    test('with no version configured, ANY version is refused', () {
      final m = mock(currentVersion: null);
      for (final sent in [kMockTermsVersion, 'x', '']) {
        expect(post(m, sent), isA<MockTermsValidation>(), reason: sent);
      }
      expect(read(m).acceptedVersion, isNull);
    });
  });

  group('routing', () {
    test('only the one path, only GET and POST', () {
      final m = mock();
      expect(m.handle('GET', '/me', const {}), isNull);
      expect(m.handle('GET', '/me/terms-acceptance/x', const {}), isNull);
      expect(m.handle('PUT', '/me/terms-acceptance', const {}), isNull);
      expect(m.handle('DELETE', '/me/terms-acceptance', const {}), isNull);
    });
  });

  group('through buildMockDio and the real repository', () {
    TermsRepository repo() =>
        TermsRepository(buildMockDio(latency: Duration.zero));

    test('read, accept, read again; a stale version is a typed 400', () async {
      final repository = repo();

      var t = await repository.getTermsAcceptance();
      expect(t.isCurrent, isFalse);
      expect(t.currentVersion, isNotNull);

      await expectLater(
        repository.acceptTerms('not-the-current-one'),
        throwsA(isA<ValidationException>()),
      );

      await repository.acceptTerms(t.currentVersion!);
      t = await repository.getTermsAcceptance();
      expect(t.isCurrent, isTrue);
      expect(t.acceptedAtUtc!.isUtc, isTrue);
    });
  });

  // Kept apart from the legal mock's code on purpose: this file imports nothing
  // from the document-viewer change set (`MockLegalDocuments`,
  // `LegalRepository`), so it compiles and runs without it. The document is
  // read as raw JSON through `buildMockDio`, so the test fails if
  // `mock_backend.dart` stops serving the document.
  group('the Terms document and the acceptance agree on the version', () {
    test('both mocks name the same Terms version', () async {
      final res = await buildMockDio(latency: Duration.zero)
          .get<Map<String, dynamic>>(
            '/reference/legal-documents/terms',
            queryParameters: {'language': 'en'},
          );

      expect(res.data!['version'], kMockTermsVersion);
    });
  });
}
