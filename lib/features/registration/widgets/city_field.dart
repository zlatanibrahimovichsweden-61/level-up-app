import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../l10n/app_localizations.dart';
import 'reference_dropdown.dart';

/// The city step on BOTH registration tracks, with the adr-028 §1 escape.
///
/// **This state exists in no Figma frame.** It is built from Seif's partner
/// notice of 2026-07-30, which is the spec of record for it — see
/// docs/DESIGN_ISSUES.md #44 and the DECISIONS.md entry. Styling is entirely
/// borrowed from the existing registration fields; nothing new was invented
/// visually, only behaviourally.
///
/// It is an IN-PLACE SWAP, not a new wizard step: the coded [ReferenceDropdown]
/// and a plain text field occupy the same slot, and a small link underneath
/// moves between them. The link is deliberately low-weight — a `TextButton`,
/// not a button-shaped control — because most students should use the list:
/// the coded id is the only value the backend can filter and report on.
///
/// The widget owns only which half is *showing*. Both values live on
/// `RegistrationController`, and each setter clears the other, so the draft can
/// never carry both and the body factory's "both → throw" stays unreachable.
class CityField extends StatefulWidget {
  const CityField({
    super.key,
    required this.cityId,
    required this.cityName,
    required this.options,
    required this.onCitySelected,
    required this.onCityNameChanged,
    this.enabled = true,
    this.disabledHint,
    this.errorText,
    this.onRetry,
  });

  /// The coded selection, or null.
  final String? cityId;

  /// The free-text fallback, or null. A non-null value opens the field in
  /// free-text mode, so returning to this screen shows what the student typed.
  final String? cityName;

  final AsyncValue<List<PickerOption>> options;
  final ValueChanged<String> onCitySelected;
  final ValueChanged<String?> onCityNameChanged;

  /// Cascade gate for the coded picker (Egypt needs a governorate first).
  /// It does NOT gate the free-text field: a student whose city is missing from
  /// the list must not also be blocked by the list's own scoping.
  final bool enabled;
  final String? disabledHint;

  final String? errorText;
  final VoidCallback? onRetry;

  @override
  State<CityField> createState() => _CityFieldState();
}

class _CityFieldState extends State<CityField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.cityName ?? '',
  );

  /// Set by tapping the escape link. ORed with the draft's own `cityName` so
  /// the free-text field survives a rebuild before the student has typed
  /// anything, and re-opens on a screen the student navigates back to.
  bool _escaped = false;

  bool get _freeText => _escaped || widget.cityName != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toPicker() {
    _controller.clear();
    // Clearing the draft's cityName is what actually returns the union to the
    // coded half; `_escaped` alone would leave a stale free-text value on it.
    widget.onCityNameChanged(null);
    setState(() => _escaped = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_freeText) ...[
          FieldLabel(l10n.cityNameLabel),
          const SizedBox(height: 8),
          PlainTextField(
            key: const Key('field-cityName'),
            controller: _controller,
            hint: l10n.cityNameLabel,
            hasError: widget.errorText != null,
            // Contract: cityName maxLength 100 (openapi.yaml:1273).
            maxLength: 100,
            onChanged: widget.onCityNameChanged,
          ),
          if (widget.errorText != null) InlineFieldError(widget.errorText!),
          _EscapeLink(label: l10n.chooseFromList, onTap: _toPicker),
        ] else ...[
          ReferenceDropdown(
            fieldKey: 'field-cityId',
            label: l10n.cityLabel,
            value: widget.cityId,
            options: widget.options,
            enabled: widget.enabled,
            disabledHint: widget.disabledHint,
            errorText: widget.errorText,
            onRetry: widget.onRetry,
            onSelected: widget.onCitySelected,
          ),
          _EscapeLink(
            label: l10n.cityNotListed,
            onTap: () => setState(() => _escaped = true),
          ),
        ],
      ],
    );
  }
}

/// The shared secondary link used by both escapes on these screens (city here,
/// school below it). Start-aligned so it reads as belonging to the field above
/// it in LTR and RTL alike, and sized down so it never competes with the field.
class _EscapeLink extends StatelessWidget {
  const _EscapeLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ext.textSecondary,
            decoration: TextDecoration.underline,
            decorationColor: ext.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// The same link, exported for the school skip so both affordances on the
/// screen are literally the same widget rather than two lookalikes.
class RegistrationEscapeLink extends StatelessWidget {
  const RegistrationEscapeLink({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _EscapeLink(label: label, onTap: onTap);
}
