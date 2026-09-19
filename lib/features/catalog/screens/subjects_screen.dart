import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/subject.dart';
import '../notifier/subjects_notifier.dart';
import '../widgets/catalog_scaffold.dart';
import '../widgets/catalog_states.dart';
import '../widgets/subject_card.dart';

/// Subjects — the Learn tab's landing screen · Figma `337:5702`.
///
/// Powered by ONE call, `GET /catalog/subjects`, which the server scopes to the
/// authenticated student (adr-013) — this screen sends no scope parameters and
/// must never start.
///
/// Tapping a card opens `/learn/subject/{id}`, which triggers the single tree
/// fetch that the whole drill-down then reads from.
class SubjectsScreen extends ConsumerStatefulWidget {
  const SubjectsScreen({super.key});

  @override
  ConsumerState<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends ConsumerState<SubjectsScreen> {
  /// Ephemeral local UI only — the query never leaves the device. `setState` is
  /// correct here precisely because there is no network state involved.
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subjects = ref.watch(subjectsProvider);
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    return CatalogScaffold(
      title: l10n.subjectsTitle,
      action: const _MistakesButton(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 25),
            child: _SearchField(
              controller: _controller,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: CatalogAsyncView<List<Subject>>(
              value: subjects,
              isEmpty: (data) => data.isEmpty,
              emptyMessage: l10n.noSubjects,
              onRetry: () => ref.read(subjectsProvider.notifier).refresh(),
              skeleton: const _SubjectsSkeleton(),
              onLoaded: (data) => _SubjectsGrid(
                subjects: filterSubjects(data, _query),
                // The list has rows but the FILTER matched none — a different
                // message from "you have no subjects", and not an error.
                noMatchMessage: l10n.noSubjectsMatch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The Subjects header's one action, and the entry point to the Mistakes flow
/// (Figma `337:5702` → `404:6292`).
///
/// It was a coming-soon snackbar from Day 6 until 2026-09-12, deferred four
/// times for one reason: no endpoint. `GET /me/mistakes` shipped `stable` at
/// contract 3.10.0-m1 and the reason expired, so the stub is gone.
///
/// `push`, not `go`: the overview is a push onto the Learn branch's own
/// Navigator, which is what makes `CatalogHeader.canPop()` true and draws the
/// back chevron the frame shows. `go` would replace this screen and leave the
/// student with no way back short of the nav bar.
///
/// **Its styling is NOT unchanged**, as this doc used to claim (`Frame
/// 427319504`, 63.67 × 35, r9). Five things moved on 2026-09-19: the pill has a
/// FILL where the `OutlinedButton` was transparent; the hairline is 0.266667,
/// not 0.5; its colour is [AppColors.mistakesPillAccent] rather than
/// `cs.error`, because `ColorScheme.fromSeed` does not resolve `error` to the
/// frame's `#EF4444`; it carries the frame's small black drop shadow on both
/// canvases; and the dark pill is a 20% `#565656` wash lit with Glass **G5**.
/// Only the destination and the 35 dp geometry are as they were.
class _MistakesButton extends StatelessWidget {
  const _MistakesButton();

  /// 🔴 **The tap target is 35, not the 48 the guideline asks for, and it
  /// cannot be fixed from this widget.**
  ///
  /// edit3.md §7.5 asks for a >= 48 dp target under the drawn 35 dp pill. The
  /// `OutlinedButton` this replaced appeared to have one — Material's default
  /// `tapTargetSize: padded` draws a 35 dp button inside a 48 dp hit box — but
  /// it never actually did, and neither can anything else in this header.
  ///
  /// `CatalogHeader` is a `SizedBox(height: 35)` around a `Stack`
  /// (`catalog_scaffold.dart`). A render box refuses a pointer outside its own
  /// SIZE — `RenderBox.hitTest` returns false before it reaches its children —
  /// so a 48 dp child of a 35 dp box is tappable over 35 dp of itself, and the
  /// rest goes to whatever is behind. This is a LAYOUT bound, not a clipping
  /// one: `clipBehavior` governs painting only, and `Stack(clipBehavior:
  /// Clip.none)` does not change the answer (verified with a throwaway probe:
  /// 35 dp header rejects a tap 20 dp off centre under both `Clip.hardEdge`
  /// and `Clip.none`; a 48 dp header accepts it under both).
  ///
  /// Measured on this screen: hit-testing the pill's centre +/- 15.5 dp lands
  /// on its own ink box and +/- 24 dp does not
  /// (`subjects_screen_test.dart`, "is the frame's 35 dp pill").
  ///
  /// Wrapping the pill in an explicit `SizedBox(height: 48)` was tried and
  /// changes nothing. The only fix is to grow `CatalogHeader`, which edit2
  /// owns and this edit may not touch, so it is recorded in
  /// docs/DESIGN_ISSUES.md #80 and the pill is left at exact parity with the
  /// button it replaced rather than given a box that measures 48 and behaves
  /// like 35.
  static const _pillHeight = 35.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;

    // `MergeSemantics` + `button: true`, because `ElevatedSurface` adds no
    // semantics of its own and its `InkWell` exposes only a tap ACTION - not
    // the button FLAG the `OutlinedButton` this replaced carried. Without both,
    // TalkBack announces "Mistakes" and never says it is a button. The merge is
    // what keeps that flag, the label from the `Text` and the tap action from
    // the `InkWell` as ONE node instead of three.
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: ElevatedSurface(
          height: _pillHeight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          color: ext.mistakesPillFill,
          side: BorderSide(
            color: ext.mistakesPillAccent,
            width: elevation.mistakesPillBorderWidth,
          ),
          shadows: elevation.mistakesPillShadows,
          glass: elevation.mistakesPillGlass,
          onTap: () => context.push('/learn/mistakes'),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Center(
            widthFactor: 1,
            child: Text(
              l10n.mistakes,
              style: AppType.buttonSmall.copyWith(
                color: ext.mistakesPillAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma `135:610` (light) / `337:5724` (dark) — 56 tall, radius 15.
/// Deliberately not the shared `FieldShell` (60 tall, radius 20, bordered):
/// bending that component to fit would change every registration field with it.
///
/// **The surface is drawn by [ElevatedSurface], not by the `TextField`.** The
/// field is `filled: false` with no border of its own, so the two canvases can
/// diverge the way the frames do: light gets a TOP-ONLY 0.8 hairline (the panel
/// read — the CSS export wrongly showed all four sides) over two 10% shadows,
/// the file's only 10% pair; dark gets a 20% wash lit with Glass **G5** and no
/// border and no shadow at all.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  static const _height = 56.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;
    final topBorder = ext.subjectSearchTopBorder;

    return ElevatedSurface(
      height: _height,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: ext.subjectSearchFill,
      // Null in dark — the frame draws no hairline there at all.
      topSide: topBorder == null
          ? null
          : BorderSide(color: topBorder, width: 0.8),
      shadows: elevation.subjectSearchShadows,
      glass: elevation.subjectSearchGlass,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: AppType.bodyLarge.copyWith(color: ext.textPrimary),
        decoration: InputDecoration(
          // The surface above owns the fill and the shape; a filled field here
          // would paint a second, opaque rectangle over the 20% dark wash.
          filled: false,
          hintText: l10n.searchSubjects,
          hintStyle: AppType.bodyLarge.copyWith(color: ext.mutedText),
          prefixIcon: Icon(Icons.search, color: ext.mutedText),
          contentPadding: const EdgeInsetsDirectional.symmetric(vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _SubjectsGrid extends StatelessWidget {
  const _SubjectsGrid({required this.subjects, required this.noMatchMessage});

  final List<Subject> subjects;
  final String noMatchMessage;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return CatalogMessage(icon: Icons.search_off, text: noMatchMessage);
    }

    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16.5,
        childAspectRatio: SubjectCard.aspectRatio,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return SubjectCard(
          subject: subject,
          // The ONE tree fetch for this subject starts here.
          onTap: () => context.go('/learn/subject/${subject.id}'),
        );
      },
    );
  }
}

class _SubjectsSkeleton extends StatelessWidget {
  const _SubjectsSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16.5,
        childAspectRatio: SubjectCard.aspectRatio,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => const CatalogBlock(height: 89),
    );
  }
}
