import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a link outside the app. A provider so a test can see what would have
/// been opened without a platform channel.
typedef ExternalLinkLauncher = Future<bool> Function(Uri uri);

final legalLinkLauncherProvider = Provider<ExternalLinkLauncher>(
  (ref) =>
      (uri) => launchUrl(uri, mode: LaunchMode.externalApplication),
);

/// The target of a link inside a served legal document, if it may be opened.
///
/// The text is server-provided and treated as untrusted: only `https` with a
/// host and `mailto` with an address pass. `http`, `javascript:`, `data:`,
/// `file:`, `intent:`, relative paths and anything unparsable do not, and
/// nothing is ever opened inside the app (no WebView). The documents served
/// today carry no links at all (staging, 2026-10-08), so this is a fence for
/// later text, not a feature.
Uri? safeLegalLink(String? href) {
  if (href == null) return null;
  final uri = Uri.tryParse(href.trim());
  if (uri == null) return null;
  return switch (uri.scheme) {
    'https' when uri.host.isNotEmpty => uri,
    'mailto' when uri.path.isNotEmpty => uri,
    _ => null,
  };
}

/// Opens [href] in the browser or mail app if [safeLegalLink] lets it through;
/// otherwise the tap does nothing. A failure to open is swallowed: there is no
/// approved line to show for it, and the URL is never logged.
Future<void> openLegalLink(ExternalLinkLauncher launch, String? href) async {
  final uri = safeLegalLink(href);
  if (uri == null) return;
  try {
    await launch(uri);
  } on Object {
    // Nothing to show and nothing to log.
  }
}
