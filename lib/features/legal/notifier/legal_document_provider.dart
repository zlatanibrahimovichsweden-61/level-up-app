import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/legal_document.dart';
import '../repository/legal_repository.dart';

/// One served document, keyed by which one and in which language.
typedef LegalDocumentQuery = ({LegalDocument document, String language});

/// The document the viewer shows. Fetch-on-watch, read-only.
///
/// `autoDispose`: it lives only while a viewer is open, so leaving and coming
/// back asks again — a `404 legal_document_unavailable` must not be cached
/// (`error-codes.md`), and a newly published version shows on the next visit.
/// A language toggle while the viewer is open is a different key, so the
/// document is fetched again in the new language.
///
/// `retry:` returns null: Riverpod 3 would otherwise retry a failure on its
/// own and hold the loading state, so the error view would never show. A retry
/// is the student's own tap (`ref.invalidate`).
final legalDocumentProvider = FutureProvider.autoDispose
    .family<LegalDocumentContent, LegalDocumentQuery>(
      (ref, query) => ref
          .watch(legalRepositoryProvider)
          .getLegalDocument(query.document, language: query.language),
      retry: _noRetry,
    );

Duration? _noRetry(int retryCount, Object error) => null;
