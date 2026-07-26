import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The AR/EN language-toggle pill. Shows the OTHER language's endonym (its
/// `label`) and flips the locale on tap. Place it top-end so it sits at the
/// right in LTR and the left in RTL. Shared across auth + registration screens.
class LanguagePill extends StatelessWidget {
  const LanguagePill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: ext.background,
          border: Border.all(color: ext.secondaryButtonBorder),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: 18, color: ext.textPrimary),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: ext.textPrimary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
