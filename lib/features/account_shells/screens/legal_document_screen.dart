import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../../legal/legal_error_copy.dart';
import '../../legal/models/legal_document.dart';
import '../../legal/notifier/legal_document_provider.dart';
import '../../legal/widgets/legal_markdown.dart';

// The router names the documents through this screen.
export '../../legal/models/legal_document.dart' show LegalDocument;

/// Privacy Policy · Terms of Use — routed at `/legal/privacy` and
/// `/legal/terms`, reachable signed in (Profile) and signed out (Login's
/// legal line; the routes are public, owner D2).
///
/// **CW04a.** The text is the server's: `getLegalDocument` serves the approved
/// document verbatim as Markdown, in the UI language, and this screen renders
/// all of it in order ([LegalMarkdown]). The app writes no legal copy — that is
/// still the rule this screen was a placeholder for (`seif_fight.md` S30).
///
/// **The title (owner C3).** Once the document is shown, its own `# ` heading
/// is the page's visible title, so the bar keeps only the back chip: the same
/// title twice would read as two. Until then — loading, or a failure — the bar
/// names the document, so the student knows what they opened.
///
/// States, each in Arabic and English:
/// - loading → a spinner;
/// - shown → the document;
/// - `404 legal_document_unavailable`, or a body with no text → "This document
///   hasn't been published yet." (the line this screen showed before), no Retry;
/// - offline → the offline line + Retry;
/// - `429` → the `/reference` rate-limit line + Retry;
/// - anything else → "Something went wrong" + Retry.
/// Retry is the student's tap and nothing else.
class LegalDocumentScreen extends ConsumerWidget {
  const LegalDocumentScreen({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = (
      document: document,
      language: legalLanguageFor(Localizations.localeOf(context)),
    );
    final served = ref.watch(legalDocumentProvider(query));
    void retry() => ref.invalidate(legalDocumentProvider(query));

    final ScreenState<LegalDocumentContent> state = served.when(
      // A Retry is a refresh of the same key: show it loading, not the old
      // failure with a live Retry under it while the new request runs.
      skipLoadingOnRefresh: false,
      data: (content) => content.contentMarkdown.trim().isEmpty
          // "Never an empty 200" — but if one came, it is not a document.
          ? const ScreenEmpty()
          : ScreenLoaded(content),
      loading: ScreenLoading.new,
      error: (error, _) => isOffline(error)
          ? const ScreenOffline()
          : ScreenError('genericError', cause: error),
    );

    final barTitle = switch (state) {
      ScreenLoaded() => '',
      _ => switch (document) {
        LegalDocument.privacy => l10n.profilePrivacyPolicy,
        LegalDocument.terms => l10n.profileTermsConditions,
      },
    };

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: barTitle,
          backKey: const Key('legal_back'),
          child: StateWidget<LegalDocumentContent>(
            state: state,
            loading: const Center(
              key: Key('legal_loading'),
              child: CircularProgressIndicator(),
            ),
            onLoaded: (content) => SingleChildScrollView(
              key: const Key('legal_body'),
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
              child: LegalMarkdown(data: content.contentMarkdown),
            ),
            empty: _LegalStateMessage(
              key: const Key('legal_unavailable'),
              icon: Icons.description_outlined,
              text: l10n.legalNotPublished,
            ),
            error: switch (state) {
              ScreenError(:final cause) => _LegalStateMessage(
                key: Key(
                  isLegalDocumentUnavailable(cause)
                      ? 'legal_unavailable'
                      : 'legal_error',
                ),
                icon: isLegalDocumentUnavailable(cause)
                    ? Icons.description_outlined
                    : Icons.error_outline,
                text: legalFailureText(l10n, cause),
                onRetry: legalRetryAllowed(cause) ? retry : null,
              ),
              _ => null,
            },
            offline: _LegalStateMessage(
              key: const Key('legal_offline'),
              icon: Icons.wifi_off,
              text: l10n.offline,
              onRetry: retry,
            ),
          ),
        ),
      ),
    );
  }
}

/// Centred icon + line + optional Retry for the states that are not the
/// document. It scrolls rather than overflow at a large text size.
class _LegalStateMessage extends StatelessWidget {
  const _LegalStateMessage({
    super.key,
    required this.icon,
    required this.text,
    this.onRetry,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 32,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48, color: ext.mutedText),
                  const SizedBox(height: 12),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppType.bodyMedium.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: 16),
                    // Retry re-asks the same request on a tap; never on its own.
                    FilledButton(
                      key: const Key('legal_retry'),
                      onPressed: onRetry,
                      child: Text(l10n.retry),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
