import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_up_app/features/legal/models/legal_document.dart';
import 'package:level_up_app/features/legal/notifier/legal_document_provider.dart';
import 'package:level_up_app/features/legal/repository/legal_repository.dart';

/// Shared fixtures for the legal viewer (CW04a).
///
/// **None of this is legal text.** The Markdown below is a structural fixture
/// with marker words, shaped like the served documents (a `# ` title line,
/// numbered `##` sections between rules, bold across a soft line break, nested
/// and numbered lists, a two-column table), so a test can prove each block is
/// rendered, whole and in order.

/// The fixture document's own `# ` title.
const fixtureTitle = 'Fixture title line';

/// Every block of [fixtureMarkdown] as the reader should see it, in order:
/// soft line breaks read as spaces and the Markdown markers are gone, but every
/// word is there.
const fixtureBlocks = [
  fixtureTitle,
  'Opening paragraph one wraps across two source lines with bold that also '
      'crosses the break and ends here.',
  '1. First section',
  'Bullet alpha',
  'Nested bullet beta',
  'Bullet gamma',
  'Ordered one',
  'Ordered two',
  '2. Second section',
  'Head A',
  'Head B',
  'Cell A1',
  'Cell B1 is long enough to wrap onto several lines on a narrow screen at a '
      'large text size',
  'Bold A2',
  'Cell B2',
];

const fixtureMarkdown =
    '''
# $fixtureTitle

Opening paragraph one wraps across
two source lines with **bold that also
crosses the break** and ends here.

---

## 1. First section

- Bullet alpha
  - Nested bullet beta
- Bullet gamma

1. Ordered one
2. Ordered two

---

## 2. Second section

| Head A | Head B |
|---|---|
| Cell A1 | Cell B1 is long enough to wrap onto several lines on a narrow screen at a large text size |
| **Bold A2** | Cell B2 |
''';

LegalDocumentContent fixtureDocument(
  LegalDocument document,
  String language, {
  String markdown = fixtureMarkdown,
}) => LegalDocumentContent(
  document: document.wireValue,
  version: 'fixture-1',
  language: language,
  title: fixtureTitle,
  contentMarkdown: markdown,
);

/// A repository that answers every document at once with the fixture, for
/// harnesses that may pass through the viewer without testing it.
class QuietLegalRepository implements LegalRepository {
  @override
  Future<LegalDocumentContent> getLegalDocument(
    LegalDocument document, {
    required String language,
  }) async => fixtureDocument(document, language);
}

/// A repository a test scripts call by call: each answer is taken from
/// [answers] in turn (a document, an exception to throw, or a [Completer]
/// whose future is returned), and every call is recorded.
class ScriptedLegalRepository implements LegalRepository {
  ScriptedLegalRepository(this.answers);

  final List<Object> answers;
  final calls = <({LegalDocument document, String language})>[];

  @override
  Future<LegalDocumentContent> getLegalDocument(
    LegalDocument document, {
    required String language,
  }) {
    calls.add((document: document, language: language));
    final answer = answers.length > 1 ? answers.removeAt(0) : answers.single;
    return switch (answer) {
      final Completer<LegalDocumentContent> pending => pending.future,
      final LegalDocumentContent content => Future.value(content),
      final Object error => Future.error(error),
    };
  }
}

/// Holds every document for the life of [container], for harnesses that pass
/// through the viewer without testing it.
///
/// The viewer watches an `autoDispose` provider. When the test binding tears
/// the tree down the flutter vsync is already gone, so Riverpod schedules the
/// disposal on a zero-length `Timer`, which the binding reports as pending. A
/// container-level listener keeps each document alive, so no disposal is
/// scheduled; `container.dispose()` in the tear-down releases them. (Same as
/// `holdBoards` in `leaderboard_fixtures.dart`.)
void holdLegalDocuments(ProviderContainer container) {
  for (final document in LegalDocument.values) {
    for (final language in const ['ar', 'en']) {
      container.listen(
        legalDocumentProvider((document: document, language: language)),
        (_, _) {},
      );
    }
  }
}
