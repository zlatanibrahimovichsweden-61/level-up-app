import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// The 5-tab bottom-nav shell · Figma nav `59:1264` (light) / `348:6686` (dark).
///
/// Home · Leaderboard · Learn (centre, visually elevated) · Message · Account.
/// Only Home is real in Day 4; the other four are coming-soon placeholders.
///
/// Built on `StatefulShellRoute.indexedStack`, so each tab keeps its own
/// Navigator and its own state: switching to Leaderboard and back must not
/// re-fetch `/me` or reset Home's scroll position.
///
/// The bar is hand-rolled rather than a Material `NavigationBar` because the
/// frame needs three things NavigationBar does not give: a thin top indicator
/// over the ACTIVE tab, an elevated circular centre tab, and 11px labels.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Index of the centre tab, drawn elevated.
  static const _centreIndex = 2;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops that branch back to its root, which is
      // the behaviour every student already expects from other apps.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    final destinations = <({IconData icon, String label})>[
      (icon: Icons.home, label: l10n.navHome),
      (icon: Icons.leaderboard, label: l10n.navLeaderboard),
      (icon: Icons.menu_book, label: l10n.navLearn),
      (icon: Icons.chat_bubble, label: l10n.navMessage),
      (icon: Icons.person, label: l10n.navAccount),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ext.background,
          border: Border(
            top: BorderSide(color: ext.fieldBorder, width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                for (var i = 0; i < destinations.length; i++)
                  Expanded(
                    child: _NavTab(
                      // TODO(design-asset): real footer glyphs (Figma
                      // icon/footer/*) — blocked by export-disabled + View-only
                      // seat. See docs/DESIGN_ISSUES.md #1.
                      icon: destinations[i].icon,
                      label: destinations[i].label,
                      selected: i == navigationShell.currentIndex,
                      elevated: i == _centreIndex,
                      onTap: () => _goBranch(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.elevated,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool elevated;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;
    // Active = the theme primary (green in light, purple in dark — the same
    // flip the rest of the app uses); inactive = the shared muted grey.
    final color = selected ? cs.primary : ext.mutedText;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The frame's 2px rule sitting over the selected tab.
            Container(
              height: 2,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 12),
              color: selected ? cs.primary : Colors.transparent,
            ),
            const Spacer(),
            if (elevated)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ext.cardFill,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 0.5),
                ),
                child: Icon(icon, size: 22, color: color),
              )
            else
              Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
