import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/profile_error_copy.dart' show rejectedFields;
import '../models/support_models.dart';
import '../notifier/create_ticket_notifier.dart';
import '../repository/support_repository.dart';
import '../support_error_copy.dart';
import '../widgets/support_field_section.dart';

/// Create Ticket · routed at `/support/new`, pushed from the support list's
/// create card and from a closed thread. Figma `178:3222`.
///
/// A text ticket only: a subject and the details, `POST /support/tickets`. The
/// frame's Attach box, camera and microphone are photos and voice, which are
/// CW12b / not in the contract, and are not drawn (CW12a_PLAN §1).
///
/// **Validation is the server's, with one pre-flight.** A trimmed-empty field
/// shows `fieldRequired` under it and no request is made (the contract refuses
/// an empty `subject` / `details` after trimming); every other rule is the
/// server's. A `400 validation_failed` field map shows `fieldRejected` under
/// the field it names. Only the field NAMES cross into the UI, never the
/// server's strings.
///
/// **Failure is Edit Profile's pattern**: the text stays in the fields and a
/// banner above the button names the failure (offline, rate limited with the
/// `Retry-After` when known, pending deletion, otherwise the generic line).
///
/// **One submit at a time.** While a request is in flight the fields and the
/// button are disabled and the button shows a spinner: five creates are allowed
/// a day, so a second tap must be impossible, not merely ignored.
///
/// **On success** the list is refetched (the notifier invalidates it) and this
/// route is REPLACED by the new ticket's thread, so Back from the thread lands
/// on the list rather than on a form the student has already sent.
class CreateSupportTicketScreen extends ConsumerStatefulWidget {
  const CreateSupportTicketScreen({super.key});

  @override
  ConsumerState<CreateSupportTicketScreen> createState() =>
      _CreateSupportTicketScreenState();
}

class _CreateSupportTicketScreenState
    extends ConsumerState<CreateSupportTicketScreen> {
  final _subject = TextEditingController();
  final _details = TextEditingController();

  bool _subjectRequired = false;
  bool _detailsRequired = false;

  /// A request is in flight. Local rather than read from the provider: the
  /// provider's own first state is a brief `AsyncLoading` before its build
  /// resolves, which must not look like a submit.
  bool _busy = false;

  /// The frame's heading block sits 25 under the title bar's row, and the form
  /// 25 under the heading; the bar itself keeps 8 of the first.
  static const _top = 17.0;
  static const _afterHeading = 25.0;
  static const _fieldGap = 20.0;

  @override
  void dispose() {
    _subject.dispose();
    _details.dispose();
    super.dispose();
  }

  /// Clears a stale failure the moment the student acts on it, so an old error
  /// never sits under a field that has since been fixed.
  void _onEdited({bool subject = false, bool details = false}) {
    if (_subjectRequired && subject || _detailsRequired && details) {
      setState(() {
        if (subject) _subjectRequired = false;
        if (details) _detailsRequired = false;
      });
    }
    if (ref.read(createSupportTicketProvider).hasError) {
      ref.invalidate(createSupportTicketProvider);
    }
  }

  Future<void> _submit() async {
    if (_busy) return;

    final subject = _subject.text.trim();
    final details = _details.text.trim();
    setState(() {
      _subjectRequired = subject.isEmpty;
      _detailsRequired = details.isEmpty;
    });
    if (subject.isEmpty || details.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    await ref
        .read(createSupportTicketProvider.notifier)
        .submit(subject, details);
    // On success the route has been replaced and this State is gone.
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    // Success: replace this route with the new ticket's thread. A listener,
    // not a build-time side effect, and never `initState` (BUG-001).
    ref.listen<AsyncValue<SupportTicket?>>(createSupportTicketProvider, (
      previous,
      next,
    ) {
      final ticket = next.value;
      if (next is AsyncData<SupportTicket?> && ticket != null) {
        context.pushReplacement(
          '/support/tickets/${Uri.encodeComponent(ticket.ticketId)}',
        );
      }
    });

    final submit = ref.watch(createSupportTicketProvider);
    final rejected = rejectedFields(submit.error);

    final subjectError = _subjectRequired
        ? l10n.fieldRequired
        : rejected.contains('subject')
        ? l10n.fieldRejected
        : null;
    final detailsError = _detailsRequired
        ? l10n.fieldRequired
        : rejected.contains('details')
        ? l10n.fieldRejected
        : null;

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: l10n.supportNewTicketTitle,
          backKey: const Key('support_new_back'),
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(20, _top, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Heading block · 178:3342 / 178:3343, 8 apart. The frame's
                // Bold 22 and Regular 20 go to the nearest styles on the scale
                // (h1 and bodyLarge); logged for the designer.
                Semantics(
                  header: true,
                  child: Text(
                    l10n.createTicket,
                    style: AppType.h1.copyWith(color: ext.textPrimary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.supportCreateTicketSubtitle,
                  style: AppType.bodyLarge.copyWith(
                    color: ext.supportHeadingSubtitle,
                  ),
                ),
                const SizedBox(height: _afterHeading),
                SupportFieldSection(
                  key: const Key('support_create_subject_section'),
                  fieldKey: const Key('support_subject_field'),
                  label: l10n.supportSubjectLabel,
                  controller: _subject,
                  maxLength: SupportRepository.maxSubjectLength,
                  minInputHeight: 43,
                  enabled: !_busy,
                  errorText: subjectError,
                  onChanged: (_) => _onEdited(subject: true),
                ),
                const SizedBox(height: _fieldGap),
                SupportFieldSection(
                  key: const Key('support_create_details_section'),
                  fieldKey: const Key('support_details_field'),
                  label: l10n.supportDetailsLabel,
                  hint: l10n.supportDetailsHint,
                  controller: _details,
                  maxLength: SupportRepository.maxDetailsLength,
                  minInputHeight: 94,
                  multiline: true,
                  enabled: !_busy,
                  errorText: detailsError,
                  onChanged: (_) => _onEdited(details: true),
                ),
                const SizedBox(height: _fieldGap),
                if (submit.hasError) ...[
                  _SubmitError(
                    message: supportActionFailureText(l10n, submit.error),
                  ),
                  const SizedBox(height: 16),
                ],
                _SubmitButton(
                  busy: _busy,
                  label: l10n.supportSubmitTicket,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Submit Ticket · Figma `178:3374`: 60 high, radius 20, `#384F47`, in the
/// shared [PrimaryCta] so it carries the CTA's elevation on both canvases.
///
/// The label is the scale's `buttonLarge`; the frame's SemiBold 22 has no
/// counterpart (the app's other 60 high CTAs, Save changes among them, use the
/// same style). The button is `null` in flight: the guard against a double
/// submit is the absence of a tap target, not a flag checked after the fact.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.busy,
    required this.label,
    required this.onPressed,
  });

  final bool busy;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: PrimaryCta(
        enabled: !busy,
        child: FilledButton(
          key: const Key('support_submit'),
          onPressed: busy ? null : onPressed,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: busy
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(label, style: AppType.buttonLarge),
        ),
      ),
    );
  }
}

/// Banner-level failure copy, above the button that caused it. The same shape
/// as Edit Profile's.
class _SubmitError extends StatelessWidget {
  const _SubmitError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // A live region: the failure appears after a tap on the button above which
    // it sits, so a screen reader has to be told it happened.
    return Semantics(
      liveRegion: true,
      child: Row(
        key: const Key('support_create_error'),
        children: [
          Icon(Icons.error_outline, size: 18, color: cs.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: AppType.bodyMedium.copyWith(color: cs.error),
            ),
          ),
        ],
      ),
    );
  }
}
