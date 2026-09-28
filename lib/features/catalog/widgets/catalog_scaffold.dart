import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';

/// Shared chrome for the four browse screens (Subjects → Units → Chapters →
/// Lessons) · Figma header `404:7413`.
///
/// One widget rather than four copies of the same Stack: the drill-down screens
/// differ only in title, body and (on Subjects) the trailing action.
class CatalogScaffold extends StatelessWidget {
  const CatalogScaffold({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });

  final String title;
  final Widget child;

  /// Trailing header action — only Subjects has one ("Mistakes").
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false, // the nav shell owns the bottom inset
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 16),
              child: CatalogHeader(title: title, action: action),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// Back chevron · centred title · optional trailing action.
///
/// The frame draws a back chevron on every screen including Subjects, but
/// Subjects is a TAB ROOT — there is nothing to pop, so a chevron there would be
/// a dead control. It is therefore rendered only when THIS route has a route
/// below it to go back to. Flagged to the designer (DESIGN_ISSUES #14).
///
/// That is `ModalRoute.canPopOf`, not `GoRouter.canPop()`. The router's answer
/// is for the whole app, root navigator first, and reading it in build never
/// rebuilds anything: `InheritedGoRouter` does not notify. So a Subjects root
/// rebuilt while Settings sat on the root navigator (a theme change is enough)
/// drew a chip, kept it after Settings closed, and the chip popped nothing.
/// `canPopOf` is scoped to this route in its own branch navigator and rebuilds
/// the header when that changes. API→UI Wave 08, KNOWN_BUGS BUG-010.
class CatalogHeader extends StatelessWidget {
  const CatalogHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final canPop = ModalRoute.canPopOf(context) ?? false;

    return SizedBox(
      height: 35,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Text(
            title,
            // One line, like `TitledChrome`: a long server-side name would
            // wrap to 52px inside this 35px bar and be clipped over the back
            // chip. Register SF-08.
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.h2.copyWith(color: ext.textPrimary),
          ),
          if (canPop)
            // The shared chip (Figma `90:208`), not a local copy: this header
            // used to draw its own `cardFill` circle around a Material
            // `arrow_back_ios_new`, which is the drift `CircleBackButton`'s
            // docstring says it exists to stop. It now carries the same SVG
            // chevron, the same 20%-alpha dark surface with Glass, and the same
            // light drop shadow as every other back chip in the app.
            PositionedDirectional(
              start: 0,
              child: CircleBackButton(onPressed: () => context.pop()),
            ),
          if (action != null) PositionedDirectional(end: 0, child: action!),
        ],
      ),
    );
  }
}

/// Back-pointing chevron. ALWAYS the LTR glyph: Material's chevrons and
/// arrows carry `matchTextDirection: true`, so [Icon] mirrors them in RTL by
/// itself.
///
/// Both helpers used to swap the glyph for RTL as well. The two flips
/// cancelled, and every drill-in chevron pointed right in Arabic
/// (device-proven 2026-09-20, fixed in API→UI Wave 07). The guard
/// `no glyph is swapped for its mirror image` keeps it from coming back.
const IconData backChevron = Icons.arrow_back_ios_new;

/// Forward-pointing chevron ("drill into this row"). The LTR glyph, for the
/// same reason as [backChevron]; [Icon] turns it to point left in Arabic.
const IconData forwardChevron = Icons.chevron_right;
