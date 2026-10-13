import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/legal/models/legal_document.dart';
import 'package:level_up_app/features/legal/repository/legal_repository.dart';

/// The mock backend's `getLegalDocument` (CW04a), driven through the REAL
/// [LegalRepository] over `buildMockDio`, so the walk on a device sees what a
/// test sees.
///
/// The one rule that matters most here: the mock's text is a labelled layout
/// sample and must keep saying so — it is never legal text.
void main() {
  LegalRepository repo() =>
      LegalRepository(buildMockDio(latency: Duration.zero));

  for (final document in LegalDocument.values) {
    for (final language in ['ar', 'en']) {
      test('${document.name} · $language: a contract-shaped 200, labelled '
          'as a sample', () async {
        final content = await repo().getLegalDocument(
          document,
          language: language,
        );

        expect(content.document, document.wireValue);
        expect(content.language, language);
        expect(content.version, isNotEmpty);
        // Its own `# ` title line, and `title` is that heading's text.
        expect(content.contentMarkdown, startsWith('# ${content.title}\n'));
        expect(content.title, contains('not legal text'));
        expect(
          content.contentMarkdown,
          contains('none of its wording is approved'),
        );
        // Every construct the served documents use, so the walk covers them.
        for (final construct in [
          '\n## ',
          '\n---\n',
          '\n- ',
          '\n  - ',
          '\n1. ',
          '\n|---|',
        ]) {
          expect(
            content.contentMarkdown,
            contains(construct),
            reason: construct,
          );
        }
      });
    }
  }

  test('strict where the server is strict: anything outside the two enums is '
      '400 validation_failed', () async {
    final dio = buildMockDio(latency: Duration.zero);

    Future<Object?> rejection(String path, Map<String, dynamic> query) async {
      try {
        await dio.get<Map<String, dynamic>>(path, queryParameters: query);
        return null;
      } on Object catch (e) {
        return (e as dynamic).error;
      }
    }

    final badDocument = await rejection('/reference/legal-documents/cookies', {
      'language': 'en',
    });
    expect(badDocument, isA<ValidationException>());
    expect((badDocument! as ValidationException).fields, ['document']);

    final badLanguage = await rejection('/reference/legal-documents/terms', {
      'language': 'fr',
    });
    expect((badLanguage! as ValidationException).fields, ['language']);

    final noLanguage = await rejection('/reference/legal-documents/terms', {});
    expect((noLanguage! as ValidationException).fields, ['language']);
  });
}
