import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

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
/// a dead control. It is therefore rendered only when the branch's Navigator can
/// actually pop. Flagged to the designer (DESIGN_ISSUES #14).
class CatalogHeader extends StatelessWidget {
  const CatalogHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final canPop = GoRouter.of(context).canPop();

    return SizedBox(
      height: 35,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: ext.textPrimary,
            ),
          ),
          if (canPop)
            PositionedDirectional(
              start: 0,
              child: Semantics(
                button: true,
                child: InkWell(
                  onTap: () => context.pop(),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: ext.cardFill,
                      shape: BoxShape.circle,
                    ),
                    // TODO(design-asset): real back glyph (Figma
                    // weui:arrow-filled) — blocked by export-disabled +
                    // View-only seat. See docs/DESIGN_ISSUES.md #1.
                    child: Icon(
                      backChevron(context),
                      size: 18,
                      color: ext.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          if (action != null) PositionedDirectional(end: 0, child: action!),
        ],
      ),
    );
  }
}

/// Back-pointing chevron, mirrored for RTL. Material's arrow icons do not flip
/// themselves, and a back arrow pointing the wrong way in Arabic is a real bug,
/// not a cosmetic one.
IconData backChevron(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
    ? Icons.arrow_forward_ios
    : Icons.arrow_back_ios_new;

/// Forward-pointing chevron ("drill into this row"), mirrored for RTL.
IconData forwardChevron(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
    ? Icons.chevron_left
    : Icons.chevron_right;
