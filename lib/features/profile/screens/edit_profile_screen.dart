import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../models/profile_update.dart';
import '../models/student_profile.dart';
import '../notifier/edit_profile_notifier.dart';
import '../notifier/me_notifier.dart';
import '../profile_error_copy.dart';
import '../widgets/avatar_sheets.dart';
import '../widgets/read_only_field.dart';
import 'profile_screen.dart' show profileScreenState;

/// Edit Profile · Figma `180:3989`, routed at `/profile/edit`.
///
/// **The last unconsumed stable endpoint in the contract lives here.** After
/// this screen, coverage is 21/21 stable; every remaining path is
/// `x-stability: draft`.
///
/// ## What is editable, and why the rest is not
///
/// The frame draws nine controls. `PATCH /me` accepts five things
/// (`openapi.yaml:614-624`) and three of them are on this screen:
///
/// - **Full Name** — `name`, `maxLength: 100`.
/// - **E-Mail** — `email`, and the one field in the app where an explicit JSON
///   `null` is the correct thing to send. See [ProfileUpdate].
/// - **Avatar** — `avatarId`, from the existing `GET /reference/avatars`
///   picker. Uploading a photo needs `PUT /me/avatar`, which is draft and
///   moderated, so that half of the sheet renders disabled (`seif_fight.md`
///   S29).
///
/// Everything else the frame draws as an input — phone, city, education
/// system, grade, school — is **immutable after registration** in v1.1 and
/// renders as a [ReadOnlyField]. Phone especially: it is the identity anchor
/// (adr-019, phone-verify-first) and cannot be a free edit. `seif_fight.md`
/// **S20**.
///
/// **The frame's "Parent's Number" row is not built at all.** `GET /me` does
/// not return `parentPhone` — the field exists only on the two registration
/// request bodies (`openapi.yaml:1277`, `:1302`), so there is no value to put
/// in the row. Same treatment as Profile's "Rank" card: no source, no render.
/// Reported for Step 3's partner-notice reconciliation rather than filled with
/// an em-dash that invites someone to guess.
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // The SAME `/me` the hub and Home already hold. This screen adds no fetch
    // of its own; it seeds a form from the profile that is already in memory.
    final me = ref.watch(meProvider);
    final offline = ref.watch(isOnlineProvider).value == false;

    void retry() => ref.read(meProvider.notifier).refresh();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: StateWidget<StudentProfile>(
                state: profileScreenState(me),
                onRetry: retry,
                loading: const EditProfileChrome(child: _Skeleton()),
                error: EditProfileChrome(
                  child: _Message(
                    icon: Icons.error_outline,
                    text: l10n.genericError,
                    onRetry: retry,
                  ),
                ),
                offline: EditProfileChrome(
                  child: _Message(
                    icon: Icons.wifi_off,
                    text: l10n.offline,
                    onRetry: retry,
                  ),
                ),
                onLoaded: (profile) => _Form(profile: profile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The frame's title bar (`180:4012`) plus whatever sits under it.
///
/// Shared by the form and by the loading/error/offline views so the back chip
/// exists in every state — a student who arrives while `/me` is failing must
/// still be able to leave.
///
/// [onBack] is null in the non-loaded states, where a plain pop is correct;
/// the form passes its unsaved-changes guard instead.
class EditProfileChrome extends StatelessWidget {
  const EditProfileChrome({super.key, required this.child, this.onBack});

  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 8),
          child: SizedBox(
            height: 35,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Text(
                  l10n.editProfile,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: ext.textPrimary,
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  child: CircleBackButton(
                    key: const Key('edit_profile_back'),
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// The form itself, seeded once from [profile].
///
/// Stateful because a form is state: two text controllers, the avatar the
/// student picked this session, and whichever field the server last rejected.
class _Form extends ConsumerStatefulWidget {
  const _Form({required this.profile});

  final StudentProfile profile;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late final TextEditingController _name;
  late final TextEditingController _email;

  /// Set only when the picker returns something. Null means "the account's
  /// current avatar", which is not a change and never reaches the wire.
  String? _pickedAvatarId;
  String? _pickedAvatarUrl;

  String? _nameErrorKey;

  @override
  void initState() {
    super.initState();
    // READ ONLY — seeded from the widget's own field, never from a provider.
    // `initState` runs inside element mount, and mutating a provider there is
    // the build-phase assertion this repo has already been bitten by (BUG-001).
    _name = TextEditingController(text: widget.profile.name);
    _email = TextEditingController(text: widget.profile.email ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  /// What would be sent right now. Recomputed rather than cached so "is this
  /// dirty" and "what do we send" can never disagree.
  ProfileUpdate get _update => ProfileUpdate.diff(
        current: widget.profile,
        name: _name.text,
        email: _email.text,
        avatarId: _pickedAvatarId,
      );

  bool get _dirty => !_update.isEmpty;

  /// Clears a stale failure the moment the student acts on it, so an old error
  /// never sits under a field that has since been fixed.
  void _onEdited() {
    setState(() => _nameErrorKey = null);
    ref.read(editProfileProvider.notifier).clearError();
  }

  Future<void> _chooseAvatar() async {
    final action = await AvatarActionSheet.show(context);
    if (action != AvatarAction.useDefault || !mounted) return;

    final picked = await ChooseAvatarSheet.show(
      context,
      selectedId: _pickedAvatarId ?? widget.profile.avatar.id,
    );
    if (picked == null) return;
    setState(() {
      _pickedAvatarId = picked.id;
      _pickedAvatarUrl = picked.url;
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();

    // Client pre-flight only. The server stays authoritative; this just avoids
    // a doomed round trip on the one rule the contract states outright.
    setState(() {
      _nameErrorKey = (name.isEmpty || name.length > 100) ? l10n.invalidName : null;
    });
    if (_nameErrorKey != null) return;

    FocusScope.of(context).unfocus();
    final saved = await ref.read(editProfileProvider.notifier).save(_update);
    if (!saved || !mounted) return;
    // Straight back to the hub, which the invalidation has already repainted.
    context.pop();
  }

  /// The unsaved-changes guard, matching the quiz's confirm-on-exit dialog
  /// (`quiz_screen.dart:230`) — same two-button shape, same "leaving must be a
  /// decision, not an accident" reasoning.
  Future<bool> _confirmDiscard() async {
    final l10n = AppLocalizations.of(context);
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.discardChangesTitle),
        content: Text(l10n.discardChangesBody),
        actions: [
          TextButton(
            key: const Key('discard_keep_editing'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.discardChangesStay),
          ),
          TextButton(
            key: const Key('discard_confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.discardChangesLeave),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  Future<void> _guardedBack() async {
    if (!_dirty) {
      context.pop();
      return;
    }
    if (await _confirmDiscard() && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = widget.profile;
    final submit = ref.watch(editProfileProvider);
    final rejected = rejectedFields(submit.error);

    return PopScope(
      // A clean form pops normally; a dirty one has to be answered for.
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // `context.mounted`, not the State's `mounted`: inside `build` the name
        // `context` is the build parameter, so the two are not the same check.
        if (await _confirmDiscard() && context.mounted) context.pop();
      },
      child: EditProfileChrome(
        onBack: _guardedBack,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: _AvatarEditor(
                  url: _pickedAvatarUrl ?? profile.avatar.url,
                  label: l10n.changeAvatarTitle,
                  onTap: _chooseAvatar,
                ),
              ),
              const SizedBox(height: 28),

              // --- Editable ---------------------------------------------
              FieldLabel(l10n.fullNameLabel),
              const SizedBox(height: 10),
              PlainTextField(
                key: const Key('edit_name_field'),
                controller: _name,
                hint: l10n.fullNameHint,
                keyboardType: TextInputType.name,
                // The contract's own cap, enforced as a formatter so the field
                // cannot hold a value the server would reject.
                maxLength: 100,
                hasError: _nameErrorKey != null || rejected.contains('name'),
                onChanged: (_) => _onEdited(),
              ),
              if (_nameErrorKey != null)
                InlineFieldError(_nameErrorKey!)
              else if (rejected.contains('name'))
                InlineFieldError(l10n.fieldRejected),
              const SizedBox(height: 25),

              FieldLabel(l10n.emailLabel),
              const SizedBox(height: 10),
              PlainTextField(
                key: const Key('edit_email_field'),
                controller: _email,
                hint: l10n.emailHint,
                keyboardType: TextInputType.emailAddress,
                hasError: rejected.contains('email'),
                onChanged: (_) => _onEdited(),
              ),
              if (rejected.contains('email')) InlineFieldError(l10n.fieldRejected),
              // Emptying the box is a real instruction, not a no-op, so it is
              // stated rather than left to be discovered.
              const SizedBox(height: 8),
              Text(
                l10n.emailClearHelp,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).extension<AppColors>()!.textSecondary,
                ),
              ),
              const SizedBox(height: 25),

              // --- Read-only (conflict 1 / S20) -------------------------
              _ReadOnlySection(profile: profile),
              const SizedBox(height: 28),

              if (submit.hasError) ...[
                _SaveError(message: profileSaveErrorMessage(l10n, submit.error)),
                const SizedBox(height: 16),
              ],
              _SaveButton(
                busy: submit.isLoading,
                label: l10n.saveChanges,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Everything `GET /me` knows about the student that `PATCH /me` cannot change.
///
/// Rendered, not hidden: this is the student's own data, and a screen that
/// silently drops half of it is answering "why can't I edit my city?" by
/// pretending the city does not exist.
class _ReadOnlySection extends StatelessWidget {
  const _ReadOnlySection({required this.profile});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    // The locale decision is made HERE, out loud, at the call site — see the
    // `ProfileCity` doc and DECISIONS.md D-004.
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    final locked = l10n.fieldLockedHint;

    final school = profile.school;
    final university = profile.university;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.fixedAfterRegistration,
          style: TextStyle(fontSize: 13, color: ext.textSecondary),
        ),
        const SizedBox(height: 16),
        ReadOnlyField(
          key: const Key('edit_phone_field'),
          label: l10n.phoneLabel,
          value: profile.phone,
          lockedHint: locked,
          forceLtr: true,
        ),
        const SizedBox(height: 25),
        ReadOnlyField(
          key: const Key('edit_city_field'),
          label: l10n.cityLabel,
          // FIRST CALL SITE of the Day 7c `ProfileCity` union, and the reason
          // it is sealed. Under v1.0 this was a bare `NamedRef`, so a student
          // whose city was typed rather than picked (adr-028 §1) would have
          // thrown on a well-formed `GET /me`. Exhaustive `switch`: the coded
          // arm has both locales, the free-text arm has one plain string and
          // no localization to choose between.
          value: switch (profile.geography.city) {
            CodedCity(:final ref) => ar ? ref.nameAr : ref.nameEn,
            FreeTextCity(:final name) => name,
          },
          lockedHint: locked,
        ),
        if (school != null) ...[
          const SizedBox(height: 25),
          ReadOnlyField(
            key: const Key('edit_education_system_field'),
            label: l10n.educationSystemLabel,
            // The wire code, verbatim. `EducationSystem` is documented as
            // EXTENSIBLE, so there is no closed set to translate against and
            // `GET /me` carries no display name — mapping it to copy here
            // would go stale the day Seif adds a system. Reported rather than
            // guessed.
            value: school.educationSystem,
            lockedHint: locked,
          ),
          const SizedBox(height: 25),
          ReadOnlyField(
            key: const Key('edit_stage_field'),
            label: l10n.stageLabel,
            value: school.stage,
            lockedHint: locked,
          ),
          const SizedBox(height: 25),
          ReadOnlyField(
            key: const Key('edit_school_field'),
            label: l10n.schoolLabel,
            // adr-028 §2 made `schoolId` optional for EVERY school student and
            // v1.1 removed free-text `schoolName` outright, so "no school" is
            // a real, valid answer rather than missing data.
            value: school.school == null
                ? l10n.schoolSkipped
                : (ar ? school.school!.nameAr : school.school!.nameEn),
            lockedHint: locked,
          ),
        ],
        // A university student's `school` block is null and their academic
        // facts live here instead (adr-010 — the two tracks have different
        // SHAPES). Same screen, driven by which block the payload carries.
        if (university != null) ...[
          const SizedBox(height: 25),
          ReadOnlyField(
            key: const Key('edit_university_field'),
            label: l10n.universityLabel,
            value: ar
                ? university.university.nameAr
                : university.university.nameEn,
            lockedHint: locked,
          ),
          const SizedBox(height: 25),
          ReadOnlyField(
            key: const Key('edit_faculty_field'),
            label: l10n.facultyLabel,
            value: ar ? university.faculty.nameAr : university.faculty.nameEn,
            lockedHint: locked,
          ),
          const SizedBox(height: 25),
          ReadOnlyField(
            key: const Key('edit_study_year_field'),
            label: l10n.studyYearLabel,
            // The server's integer, formatted for display only.
            value: l10n.studyYearNumber(university.yearNumber),
            lockedHint: locked,
          ),
        ],
      ],
    );
  }
}

/// The 151pt avatar with the frame's edit badge (`180:4079`) on its lower edge.
class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.url,
    required this.label,
    required this.onTap,
  });

  final String url;
  final String label;
  final VoidCallback onTap;

  static const _size = 151.0;
  static const _badge = 34.0;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        key: const Key('edit_avatar_button'),
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: _size,
          height: _size + 8,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: _size,
                  height: _size,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => _AvatarFallback(colour: ext.progressTrack),
                  errorWidget: (_, _, _) =>
                      _AvatarFallback(colour: ext.progressTrack),
                ),
              ),
              PositionedDirectional(
                bottom: 0,
                child: Container(
                  width: _badge,
                  height: _badge,
                  decoration: BoxDecoration(
                    color: ext.cardFill,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // Depth from the frame, colour from the canvas.
                        color: ext.elevationShadow.withValues(alpha: 0.25),
                        offset: const Offset(0.5, 0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  // TODO(design-asset): the frame uses `fluent:edit-16-filled`
                  // (`170:4669`), already listed in docs/ASSET_MANIFEST.md.
                  // Material stands in until the designer exports it.
                  child: Icon(Icons.edit, size: 18, color: ext.homeAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.colour});
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: _AvatarEditor._size,
      height: _AvatarEditor._size,
      color: colour,
      child: Icon(
        Icons.person,
        size: _AvatarEditor._size * 0.6,
        color: ext.mutedText,
      ),
    );
  }
}

/// "Save Change" · Figma `180:4081` — 60pt tall, 20pt radius, primary fill.
class _SaveButton extends StatelessWidget {
  const _SaveButton({
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
      child: FilledButton(
        key: const Key('edit_save_button'),
        // Null while in flight: the guard against a double submit is the
        // absence of a tap target, not a flag checked after the fact.
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
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// Banner-level failure copy, above the button that caused it.
class _SaveError extends StatelessWidget {
  const _SaveError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      key: const Key('edit_save_error'),
      children: [
        Icon(Icons.error_outline, size: 18, color: cs.error),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: cs.error, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// Loading — blocks in the shape of the avatar and the first fields.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    Widget block(double height, double radius) => Container(
          height: height,
          decoration: BoxDecoration(
            color: ext.progressTrack,
            borderRadius: BorderRadius.circular(radius),
          ),
        );

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 151,
              height: 151,
              decoration: BoxDecoration(
                color: ext.progressTrack,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 28),
          for (var i = 0; i < 3; i++) ...[
            block(22, 6),
            const SizedBox(height: 10),
            block(60, 20),
            const SizedBox(height: 25),
          ],
        ],
      ),
    );
  }
}

/// Centred icon + localized line + a USER-TAPPED retry. Same shape as the
/// hub's, so the two states never drift apart visually.
class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: ext.mutedText),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: ext.textSecondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}
