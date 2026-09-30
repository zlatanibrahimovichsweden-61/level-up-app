import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/elevation/app_modal.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../models/profile_update.dart';
import '../models/student_profile.dart';
import '../notifier/edit_profile_notifier.dart';
import '../notifier/me_notifier.dart';
import '../profile_error_copy.dart';
import '../widgets/avatar_disc.dart';
import '../widgets/avatar_sheets.dart';
import '../widgets/read_only_field.dart';
import 'profile_screen.dart' show profileScreenState;

/// Edit Profile · Figma `176:1201` (school) / `180:6349` (university), dark
/// `337:7795` / `349:12688`, RTL `549:21413` / `549:26807`; routed at
/// `/profile/edit`.
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
/// Everything else the frame draws as an input — phone, city, school, and on
/// the university track faculty, academic year and university — is
/// **immutable after registration** in v1.1 and renders as a [ReadOnlyField].
/// Phone especially: it is the identity anchor (adr-019, phone-verify-first)
/// and cannot be a free edit. `seif_fight.md` **S20**. The rows and their order
/// are the frames' (owner ruling, API→UI Wave 20, `DESIGN_ISSUES.md` #105):
/// education system and grade are hidden layers there, so they are not built.
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

/// Where the content starts, under [EditProfileChrome]'s 8: together 25 under
/// the title bar, as every frame draws it (the bar ends at 95, the avatar disc
/// starts at 120). Shared by the form and the skeleton so the form does not
/// shift when the profile arrives. It was 8 (16 in all); API→UI Wave 20.
const double _underTitleBar = 17;

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
                  // One line, like `TitledChrome` (register SF-08).
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.h2.copyWith(color: ext.textPrimary),
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
      _nameErrorKey = (name.isEmpty || name.length > 100)
          ? l10n.invalidName
          : null;
    });
    if (_nameErrorKey != null) return;

    FocusScope.of(context).unfocus();
    final saved = await ref.read(editProfileProvider.notifier).save(_update);
    if (!saved || !mounted) return;
    // Straight back to the hub, which the invalidation has already repainted.
    context.pop();
  }

  /// The unsaved-changes guard, matching the quiz's confirm-on-exit dialog
  /// (`quiz_screen.dart:256`) — same two-button shape, same "leaving must be a
  /// decision, not an accident" reasoning, and now the same barrier.
  ///
  /// [showAppDialog] with `logoutDialogScrim` (edit2 §13 / edit5.md §7.11):
  /// there is no Figma frame for this dialog, so it borrows the app dialog
  /// scrim rather than inventing one. The `AlertDialog` inside is unchanged,
  /// and so are both result keys.
  Future<bool> _confirmDiscard() async {
    final l10n = AppLocalizations.of(context);
    final elevation = Theme.of(context).extension<AppElevation>()!;
    final discard = await showAppDialog<bool>(
      context: context,
      scrim: elevation.logoutDialogScrim,
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
          padding: const EdgeInsetsDirectional.fromSTEB(
            20,
            _underTitleBar,
            20,
            32,
          ),
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
              // The first label starts 1 under the badge (every frame: the
              // badge ends at 285, "Full Name" starts at 286).
              const SizedBox(height: 1),

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
              if (rejected.contains('email'))
                InlineFieldError(l10n.fieldRejected),
              // Emptying the box is a real instruction, not a no-op, so it is
              // stated rather than left to be discovered.
              const SizedBox(height: 8),
              Text(
                l10n.emailClearHelp,
                style: AppType.captionRegular.copyWith(
                  color: Theme.of(
                    context,
                  ).extension<AppColors>()!.textSecondary,
                ),
              ),
              const SizedBox(height: 25),

              // --- Read-only (conflict 1 / S20) -------------------------
              _ReadOnlySection(profile: profile),
              const SizedBox(height: 28),

              if (submit.hasError) ...[
                _SaveError(
                  message: profileSaveErrorMessage(l10n, submit.error),
                ),
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
    // A university student's `school` block is null and their academic facts
    // live in `university` instead (adr-010 — the two tracks have different
    // SHAPES). Same screen, driven by which block the payload carries.
    final showUniversity =
        university != null &&
        (school == null || profile.track == Track.university);

    final city = ReadOnlyField(
      key: const Key('edit_city_field'),
      label: l10n.cityLabel,
      // FIRST CALL SITE of the Day 7c `ProfileCity` union, and the reason it
      // is sealed. Under v1.0 this was a bare `NamedRef`, so a student whose
      // city was typed rather than picked (adr-028 §1) would have thrown on a
      // well-formed `GET /me`. Exhaustive `switch`: the coded arm has both
      // locales, the free-text arm has one plain string and no localization
      // to choose between.
      value: switch (profile.geography.city) {
        CodedCity(:final ref) => ar ? ref.nameAr : ref.nameEn,
        FreeTextCity(:final name) => name,
      },
      lockedHint: locked,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.fixedAfterRegistration,
          style: AppType.captionRegular.copyWith(color: ext.textSecondary),
        ),
        const SizedBox(height: 16),
        ReadOnlyField(
          key: const Key('edit_phone_field'),
          label: l10n.phoneLabel,
          value: profile.phone,
          lockedHint: locked,
          forceLtr: true,
        ),
        // The rows and their order are the frames' (owner ruling, API→UI Wave
        // 20, DESIGN_ISSUES #105). School `176:1201`: Phone, City, School name
        // (its Parent's Number is not built, above; Education System and Grade
        // are hidden layers). University `180:6349`: Phone, Faculty, Academic
        // Year, City, University name.
        // ONE block, never two: [city] is a single keyed widget, so it must
        // not land in the list twice. `GET /me` sends one track's block and
        // null for the other (adr-010), but the schema does not enforce it; a
        // payload carrying both follows its `track` instead of crashing on a
        // duplicate key. Neither block still shows the city: it is the
        // student's own data.
        if (showUniversity) ...[
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
          const SizedBox(height: 25),
          city,
          const SizedBox(height: 25),
          ReadOnlyField(
            key: const Key('edit_university_field'),
            label: l10n.universityLabel,
            value: ar
                ? university.university.nameAr
                : university.university.nameEn,
            lockedHint: locked,
          ),
        ] else if (school != null) ...[
          const SizedBox(height: 25),
          city,
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
        ] else ...[
          const SizedBox(height: 25),
          city,
        ],
      ],
    );
  }
}

/// The 151pt avatar with the frame's edit badge (`176:1346`) on its lower edge.
///
/// **The badge's shadow is much tighter than the one that shipped.** It was
/// drawn at (0.5, 0.5) blur 2 — borrowed from the profile header — against the
/// frame's own (0.0240833, 0.0240833) blur 1.105 (`180:3989`). Dark keeps the
/// same black shadow and adds **G5** over a 20% cream wash (`337:7925`); both
/// are `AppElevation` tokens now, so the difference between the canvases is a
/// reading rather than a call-site decision.
///
/// API→UI Wave 20: the badge overhangs the disc by the frame's 14 (it spans
/// 251–285 under a disc ending at 271; it was 8), carries the frame's own
/// `fluent:edit-16-filled` glyph, 17 x 17, in [AppColors.avatarBadgeGlyph]
/// (it was `Icons.edit` in the purple `homeAccent` on both canvases), and the
/// disc wears the frame's radial gradient under the image ([AvatarDisc]).
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

  /// How far the badge hangs below the disc (`176:1346`: 285 − 271).
  static const _badgeOverhang = 14.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        key: const Key('edit_avatar_button'),
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: _size,
          height: _size + _badgeOverhang,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              AvatarDisc(
                key: const Key('edit_avatar_disc'),
                size: _size,
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: _size,
                  height: _size,
                  fit: BoxFit.cover,
                  // See home_header.dart. 151dp is the largest avatar in the
                  // app, so the saving is smaller here than on the 51dp header
                  // — but the cap still keeps an oversized source in check.
                  memCacheWidth:
                      (_size * MediaQuery.devicePixelRatioOf(context)).round(),
                  placeholder: (_, _) =>
                      _AvatarFallback(colour: ext.progressTrack),
                  errorWidget: (_, _, _) =>
                      _AvatarFallback(colour: ext.progressTrack),
                ),
              ),
              PositionedDirectional(
                bottom: 0,
                child: ElevatedSurface(
                  shape: const CircleBorder(),
                  width: _badge,
                  height: _badge,
                  color: ext.avatarBadgeFill,
                  shadows: elevation.avatarBadgeShadows,
                  glass: elevation.avatarBadgeGlass,
                  child: Center(
                    // The frame's `fluent:edit-16-filled` (`176:1347`, 17 x 17
                    // centred in the 34 chip), exported over the Figma MCP.
                    child: SvgPicture.asset(
                      'assets/icons/edit_pencil.svg',
                      key: const Key('edit_avatar_badge_glyph'),
                      width: 17,
                      height: 17,
                      // The button's label names it; the glyph's own image
                      // semantics would add a second, empty node (W11-7).
                      excludeFromSemantics: true,
                      colorFilter: ColorFilter.mode(
                        ext.avatarBadgeGlyph,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
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
///
/// Wrapped in [PrimaryCta] (edit5.md §7.11a, design item #12): light draws the
/// CTA's (0.5, 0.5) blur-4 black shadow (`348:8911`), dark adds the `#AE87E7`
/// glow layer over it (`348:8909`). The wrapper's `enabled` mirrors
/// `onPressed != null`, so an in-flight save dims the halo with the button
/// instead of leaving a lit shadow under a dead control.
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
      child: PrimaryCta(
        enabled: !busy,
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
              : Text(label, style: AppType.buttonLarge),
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
            // bodyMedium, matching `_SectionMessage` in settings_screen.dart:
            // same shape (18px glyph + one line of failure copy), so the two
            // must not drift. It also preserves this row's original 14px --
            // captionRegular would have shrunk a failure message to 12.
            style: AppType.bodyMedium.copyWith(color: cs.error),
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
      padding: const EdgeInsetsDirectional.fromSTEB(20, _underTitleBar, 20, 32),
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
          // The avatar block's badge overhang plus the 1 under it, so the
          // first label sits where the form's does.
          const SizedBox(height: _AvatarEditor._badgeOverhang + 1),
          for (var i = 0; i < 3; i++) ...[
            // 18, not 22: a FieldLabel is one labelLarge line (14 x 18/14)
            // since the type scale; the block stands in for exactly that, so
            // the form does not shift when the profile arrives. SF-09.
            block(18, 6),
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
              style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
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
