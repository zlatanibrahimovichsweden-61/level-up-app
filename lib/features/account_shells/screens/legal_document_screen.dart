import 'package:flutter/material.dart';

import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/shell_body.dart';

/// Which document a [LegalDocumentScreen] stands in for.
enum LegalDocument { privacy, terms }

/// Privacy & policy · Terms & Conditions — routed at `/legal/privacy` and
/// `/legal/terms`.
///
/// **The only screen in this cluster whose blocker is not the contract.**
/// Neither document needs an endpoint; both need TEXT, and nobody has supplied
/// any. So this carries a `TODO(content)` rather than a `TODO(contract)`, and
/// `seif_fight.md` **S30** records it as a milestone-1 blocker with no owner —
/// it is not Seif's to fix, which is exactly why it has been drifting.
///
/// TODO(content): the approved Arabic and English copy for both documents.
/// Until it exists this screen says so. **Do not write legal copy** — text that
/// binds a minor's guardian is not a thing an implementer invents, and a
/// plausible placeholder is far more dangerous here than an empty page, because
/// it looks like it has been reviewed.
///
/// One screen for both documents: they differ by title and by nothing else
/// until the copy lands. When it does, this becomes a body renderer and the
/// enum picks the source.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final title = switch (document) {
      LegalDocument.privacy => l10n.profilePrivacyPolicy,
      LegalDocument.terms => l10n.profileTermsConditions,
    };

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: title,
          backKey: const Key('legal_back'),
          child: ShellBody(
            key: const Key('legal_body'),
            icon: Icons.description_outlined,
            message: l10n.legalNotPublished,
          ),
        ),
      ),
    );
  }
}
