import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/models/student_profile.dart';

/// Which of the Home frame's section surfaces a placeholder stands in for.
///
/// The placeholders are NOT Figma components — the frame draws populated cards
/// there, and this build deliberately does not invent their content. What the
/// frame *does* specify unambiguously is each section's SURFACE, and by owner
/// decision (2026-09-17) the placeholder takes it: fill, border, radius,
/// shadows, Glass and back-light. Its "Coming soon" content, its 96 dp height
/// and its inertness are untouched.
///
/// [plain] is the pre-2026-09-17 box, and stays the answer for a section the
/// frame gives no surface of its own — today only university Learning Tools,
/// whose five tiles are recorded unbuilt (DESIGN_ISSUES #20).
///
/// Top Student left this list in API→UI Wave 05: it is a real block now
/// (`TopStudentSection`), and its surface moved with it.
enum ComingSoonSurface { dailyTasks, continueLearning, plain }

/// A Home section whose CONTENT has no endpoint yet — Daily Tasks (`337:5353`)
/// and Continue Learning (`337:5427`).
///
/// The section header is real (it is in the frame and costs nothing); the body
/// is an explicit "Coming soon" card. Deliberately NOT populated with the
/// frame's sample rows: "Complete 2 Quizzes 1/2" and "Physics 80%" are the
/// designer's mock values, and rendering them would put invented progress in
/// front of a real student. Both need a draft or non-existent endpoint:
///   - Daily Tasks       → no tasks endpoint in the contract at all
///   - Continue Learning → quiz history (draft)
///
/// `See All` is inert for the same reason — there is nothing to see all of yet.
class ComingSoonSection extends StatelessWidget {
  const ComingSoonSection({
    super.key,
    required this.title,
    required this.surface,
    required this.track,
  });

  final String title;

  /// Which section surface to draw. See [ComingSoonSurface].
  final ComingSoonSurface surface;

  /// Picks the track's back-light, and Continue Learning's fill. The two
  /// tracks' ellipses differ in both size and offset, so this is a real
  /// branch, not a normalisation.
  final Track track;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.h3.copyWith(color: ext.textPrimary),
              ),
            ),
            Text(
              l10n.seeAll,
              // The title's colour, as every frame draws it: `59:2089` black,
              // `337:5456` #FCFBF9 (W05-1; it was `mutedText` #B3B3B3).
              style: AppType.bodyMedium.copyWith(color: ext.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Surface(
          surface: surface,
          track: track,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, size: 18, color: _foreground(surface, ext)),
              const SizedBox(width: 8),
              Text(
                l10n.comingSoon,
                style: AppType.captionRegular.copyWith(
                  color: _foreground(surface, ext),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// What the placeholder's icon and caption are drawn in, per surface.
///
/// [ComingSoonSurface.continueLearning] is the one that cannot use
/// [AppColors.mutedText]. Its card is an opaque LILAC on both canvases, and
/// `#B3B3B3` on the dark school fill `#C4A8E3` measures **1.00:1** — the two
/// have the same relative luminance, so the caption is not faint, it is gone.
/// Its own frames caption it `#2B2B2B` (6.78:1 there), which is what this
/// returns. See DESIGN_ISSUES #79.
///
/// The other two keep `mutedText`. They are near-white in light and a dark
/// wash in dark, which is what that grey was chosen against — and where it
/// still fails (2.0x:1 in light) it fails exactly as it did before this wave,
/// as part of `docs/RESPONSIVE.md`-adjacent work this edit does not own.
Color _foreground(ComingSoonSurface surface, AppColors ext) =>
    switch (surface) {
      ComingSoonSurface.continueLearning => ext.continueLearningContent,
      _ => ext.mutedText,
    };

/// The 96 dp box itself, resolved to its section's Figma surface.
///
/// Every value below is an `AppColors` / `AppElevation` token, so the two
/// canvases diverge — light draws hairlines and drop shadows, dark draws Glass
/// and a lavender back-light — without this widget knowing which one it is on
/// (edit1.md R1, R8).
class _Surface extends StatelessWidget {
  const _Surface({
    required this.surface,
    required this.track,
    required this.child,
  });

  final ComingSoonSurface surface;
  final Track track;
  final Widget child;

  static const _height = 96.0;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final e = Theme.of(context).extension<AppElevation>()!;

    return switch (surface) {
      // `308:4305` / `337:5357`. Light: a 0.302507 green hairline on all four
      // sides. Dark: the frame hides the stroke, so the width token is 0 and
      // no border is drawn at all — that is a reading, not an omission.
      ComingSoonSurface.dailyTasks => ElevatedSurface(
        height: _height,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: ext.dailyTasksFill,
        side: _hairline(ext.dailyTasksBorder, e.dailyTasksBorderWidth),
        glass: e.dailyTasksGlass,
        backlights: _backlights(e.dailyTasksGlass, switch (track) {
          Track.school => e.dailyTasksBacklightSchool,
          Track.university => e.dailyTasksBacklightUniversity,
        }),
        child: _centred(child),
      ),
      // The one section that keeps its shadows on BOTH canvases: the card is
      // an opaque lilac, not a 20% wash, so the frame's two black shadows
      // still land on something (edit1.md R1). No Glass on either canvas.
      ComingSoonSurface.continueLearning => ElevatedSurface(
        height: _height,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.7251),
        ),
        color: switch (track) {
          Track.school => ext.continueLearningFillSchool,
          Track.university => ext.continueLearningFillUniversity,
        },
        shadows: e.continueLearningShadows,
        child: _centred(child),
      ),
      ComingSoonSurface.plain => Container(
        height: _height,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: ext.cardFill,
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      ),
    };
  }

  /// `ElevatedSurface` centres nothing by itself; the plain box used
  /// `Container.alignment` for this and the other two need the equivalent.
  static Widget _centred(Widget child) =>
      Align(alignment: AlignmentDirectional.center, child: child);

  /// A null colour, or a width of 0, both mean "this canvas draws no border".
  static BorderSide? _hairline(Color? color, double width) =>
      (color == null || width <= 0)
      ? null
      : BorderSide(color: color, width: width);

  /// A back-light is only visible through a frost (edit1.md R6), and
  /// `ElevatedSurface` asserts as much — so the Glass token gates the list.
  static List<Backlight> _backlights(GlassStyle? glass, Backlight? light) =>
      (glass == null || light == null) ? const [] : [light];
}
