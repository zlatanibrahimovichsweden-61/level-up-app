import 'package:flutter/widgets.dart';

/// Which legal document — the `document` path parameter of `getLegalDocument`
/// (`GET /reference/legal-documents/{document}`), whose contract enum is
/// exactly `terms | privacy`. The names ARE the wire values.
///
/// There is no third document: Login's "User Agreement" opens [terms] (owner
/// C1, 2026-10-10) and the Cookie Policy has no document behind it (owner C2).
enum LegalDocument {
  privacy,
  terms;

  String get wireValue => name;
}

/// The `language` query parameter (`ar | en`, required) for the app's current
/// UI language. The app ships only those two, so anything that is not Arabic
/// reads English — the same fallback the app's own copy uses.
String legalLanguageFor(Locale locale) =>
    locale.languageCode == 'ar' ? 'ar' : 'en';

/// One served document — the `getLegalDocument` 200 body:
/// `{document, version, language, title, contentMarkdown}`, all five required.
///
/// [contentMarkdown] is "the approved text verbatim (Markdown, including its own
/// `# ` title line)", and [title] is that heading's text. Nothing here edits,
/// trims or reorders either: the viewer renders exactly what was served.
/// [version] is the server's current Terms version; the viewer does not show it
/// (recording acceptance of it is CW04b, `acceptTerms`).
///
/// Hand-written rather than generated, like the notifications models, and
/// strict: every field is required by the contract, so a missing or mistyped
/// one throws here and the repository turns that into an `UnknownException`
/// instead of an empty page.
@immutable
class LegalDocumentContent {
  const LegalDocumentContent({
    required this.document,
    required this.version,
    required this.language,
    required this.title,
    required this.contentMarkdown,
  });

  factory LegalDocumentContent.fromJson(Map<String, dynamic> json) =>
      LegalDocumentContent(
        document: json['document'] as String,
        version: json['version'] as String,
        language: json['language'] as String,
        title: json['title'] as String,
        contentMarkdown: json['contentMarkdown'] as String,
      );

  final String document;
  final String version;
  final String language;
  final String title;
  final String contentMarkdown;

  @override
  bool operator ==(Object other) =>
      other is LegalDocumentContent &&
      other.document == document &&
      other.version == version &&
      other.language == language &&
      other.title == title &&
      other.contentMarkdown == contentMarkdown;

  @override
  int get hashCode =>
      Object.hash(document, version, language, title, contentMarkdown);
}
