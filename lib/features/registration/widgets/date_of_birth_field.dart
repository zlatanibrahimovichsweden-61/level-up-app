import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../l10n/app_localizations.dart';

/// Date-of-birth picker.
///
/// TODO(design): dateOfBirth is not in either Figma frame — see
/// docs/DESIGN_ISSUES.md #2. The contract marks it REQUIRED on both
/// `SchoolRegistration` and `UniversityRegistration`, so it is built anyway and
/// styled to match the surrounding rounded fields; the contract wins.
///
/// Many Level Up students are minors, so no minimum age is enforced client-side
/// — the server owns that rule, and inventing one here would lock out real
/// users. The range is simply "a plausible human birth date, not in the future".
class DateOfBirthField extends StatelessWidget {
  const DateOfBirthField({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? errorText;

  /// The oldest selectable birth date (100 years back) and the newest (today).
  static const _maxAgeYears = 100;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(now.year - 15, now.month, now.day),
      firstDate: DateTime(now.year - _maxAgeYears),
      lastDate: now,
      // Birth dates are far from "today" — open on the year grid so the student
      // isn't paging through a decade of months.
      initialDatePickerMode: DatePickerMode.year,
      // The dialog inherits Directionality + MaterialLocalizations from the app,
      // so it renders Arabic/RTL with no extra wiring.
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final selected = value;

    // Locale-aware display only; the WIRE format is always yyyy-MM-dd
    // (DateOnlyConverter) — never this string.
    final display = selected == null
        ? l10n.dobHint
        : DateFormat.yMMMd(Localizations.localeOf(context).toString())
            .format(selected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(l10n.dobLabel),
        const SizedBox(height: 8),
        FieldShell(
          key: const Key('field-dateOfBirth'),
          hasError: errorText != null,
          semanticLabel: l10n.dobLabel,
          onTap: () => _pick(context),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  display,
                  style: TextStyle(
                    fontSize: 18,
                    color: selected == null ? ext.hint : ext.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.calendar_today_outlined, size: 20, color: ext.hint),
            ],
          ),
        ),
        if (errorText != null) InlineFieldError(errorText!),
      ],
    );
  }
}
