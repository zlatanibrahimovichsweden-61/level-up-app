/// Throwaway on-device preview data for the legal documents - NOT production
/// code.
///
/// Answers `GET /reference/legal-documents/{document}?language=ar|en`
/// (`getLegalDocument`, `contract/openapi.yaml:811`, `x-stability: stable`) for
/// `lib/dev/mock_backend.dart`, which owns the request plumbing (CW04a).
///
/// **The text below is NOT legal text.** It is a labelled layout sample: a
/// title line, numbered sections between rules, bold across a soft line break,
/// a nested bullet list, a numbered list and a two-column table — the
/// constructs the served documents use (staging, 2026-10-08) — so the viewer
/// can be walked on a device. It is not, and must never be copied into, the
/// Terms of Use or the Privacy Policy: those are the server's, approved by
/// legal, and the app writes none (`seif_fight.md` S30). It is English in both
/// languages, because the app writes no Arabic it was not given; an Arabic walk
/// checks the right-to-left layout around it.
///
/// Strict where the server is strict: a `document` other than `terms` or
/// `privacy`, or a `language` other than `ar` or `en`, is `400
/// validation_failed`. The errors the viewer handles (`404
/// legal_document_unavailable`, `429`, offline) are covered by its widget
/// tests, not served here.
library;

/// What the mock answers, mapped by the interceptor onto its own `_ok` and
/// `_validationFailed` helpers.
sealed class MockLegalReply {
  const MockLegalReply();
}

/// A `200` with the document body.
final class MockLegalOk extends MockLegalReply {
  const MockLegalOk(this.data);

  final Map<String, Object?> data;
}

/// A `400 validation_failed` with its field map.
final class MockLegalValidation extends MockLegalReply {
  const MockLegalValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// The mock's documents. Stateless: every request gets the same answer.
class MockLegalDocuments {
  const MockLegalDocuments();

  static final _path = RegExp(r'^/reference/legal-documents/([^/]+)$');

  /// The reply for a legal-document route, or `null` when [method] + [path]
  /// is not one (so the interceptor keeps looking).
  MockLegalReply? handle(
    String method,
    String path,
    Map<String, dynamic> query,
  ) {
    final match = _path.firstMatch(path);
    if (method != 'GET' || match == null) return null;

    final document = Uri.decodeComponent(match.group(1)!);
    final language = query['language'];
    final errors = <String, List<String>>{
      if (document != 'terms' && document != 'privacy')
        'document': ['must be terms or privacy'],
      if (language != 'ar' && language != 'en')
        'language': ['must be ar or en'],
    };
    if (errors.isNotEmpty) return MockLegalValidation(errors);

    final title = 'Mock sample ($document) - not legal text';
    return MockLegalOk(<String, Object?>{
      'document': document,
      'version': 'mock-sample-1',
      'language': language,
      'title': title,
      'contentMarkdown': '# $title\n\n$_sampleBody',
    });
  }
}

const _sampleBody = '''
This page comes from the mock backend (`main_mock`). It is a layout sample, **not** a
Level Up document, and none of its wording is approved.

---

## 1. Paragraphs

A paragraph wrapped across two source lines, with **a bold span that also crosses
the line break**, reads as one paragraph.

---

## 2. Lists

- A bullet item
  - A nested bullet item
- Another bullet item

1. A first numbered item
2. A second numbered item

---

## 3. A table

| Column A | Column B |
|---|---|
| A short cell | A longer cell that wraps onto more than one line on a narrow phone screen |
| **A bold cell** | A plain cell |
''';
