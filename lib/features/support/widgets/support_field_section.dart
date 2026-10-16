import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/form_fields.dart' show InlineFieldError;

/// One field of the create-ticket form · Figma `178:3333` (Subject) and
/// `178:3345` (Details): a section of radius 8 holding a label and a white
/// input of radius 10, with the field's inline error under the input.
///
/// **The limits are enforced as you type** ([maxLength] is a formatter, the
/// counter is hidden), so the field cannot hold what the server would refuse.
///
/// **The drawn input and the field are not the same height, on purpose.** The
/// frame draws the subject input 43 high and the details input 94; Android's
/// minimum tap target is 48. The `TextField` is therefore at least 48 high
/// ([_target]) and the white surface is drawn behind it at the frame's height,
/// centred: the same device as Edit Profile's 40 dp pencil in a 48 dp target.
/// The 2.5 the field overhangs the drawing on each side is taken out of the
/// gaps above and below, so the section stays 107 high. The details input is
/// already taller than 48, so it is simply its own surface.
///
/// The inputs are MINIMUMS: the padding is inside the `TextField`, so the whole
/// field is the tap target, and a longer text grows it instead of scrolling in
/// a fixed box or being clipped by the text scale.
///
/// **The visible label is the field's accessible label.** The label `Text` is
/// excluded from semantics and the same words name the field itself, so a
/// screen reader announces "Subject, text field" once rather than the label and
/// then an unnamed field.
///
/// Dark has no frame: the section takes Glass G5 and the input the existing
/// field Glass (the frame gives the input none, but without it a flat dark
/// input has no edge on the dark section).
class SupportFieldSection extends StatelessWidget {
  const SupportFieldSection({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.maxLength,
    required this.minInputHeight,
    required this.enabled,
    this.hint,
    this.multiline = false,
    this.errorText,
    this.onChanged,
    this.textInputAction,
  });

  /// The key of the `TextField`, so a test (or a student's keyboard) reaches
  /// the field itself rather than its decoration.
  final Key fieldKey;

  final String label;
  final TextEditingController controller;
  final int maxLength;

  /// The frame's drawn input height: 43 for the subject, 94 for the details.
  final double minInputHeight;

  /// False while a submit is in flight.
  final bool enabled;

  final String? hint;

  /// The details field: three lines tall at rest, growing with its text.
  final bool multiline;

  /// The localized inline error shown under the input, if any.
  final String? errorText;

  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  static const _sectionRadius = 8.0;
  static const _inputRadius = 10.0;

  /// `178:3334`: the label is 20 from the section's top and sides, the input
  /// 50 from its top; the label line is 17.2 high, so the gap is the rest. The
  /// section's bottom edge is 14 under the subject input (107 = 50 + 43 + 14)
  /// and 21 under the details input (165 = 50 + 94 + 21).
  static const _labelToInput = 12.764;
  static const _subjectBottom = 14.0;
  static const _detailsBottom = 21.0;

  /// `bodyLarge`'s line, which the text inside the input is set in.
  static const _line = 24.0;

  /// Android's minimum tap target.
  static const _target = 48.0;

  /// `178:3352`: the hint starts 16.69 in and 15.33 down in the details input.
  static const _insetStart = 16.69;
  static const _detailsTop = 15.33;
  static const _detailsLines = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    // How much taller than the drawing the field is, per side. Zero for the
    // details input, 2.5 for the subject.
    final overhang = multiline
        ? 0.0
        : ((_target - minInputHeight) / 2).clamp(0.0, _target);

    // The vertical padding that makes the field exactly its resting height:
    // one centred line in the 48 for the subject (12 + 24 + 12), the frame's
    // 15.33 above three lines for the details (15.33 + 72 + 6.67 = 94).
    final top = multiline ? _detailsTop : (_target - _line) / 2;
    final bottom = multiline
        ? minInputHeight - _detailsTop - _detailsLines * _line
        : top;

    return ElevatedSurface(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_sectionRadius),
      ),
      color: ext.supportCardFill,
      shadows: elevation.supportFieldSectionShadows,
      glass: elevation.supportFieldSectionGlass,
      padding: EdgeInsetsDirectional.fromSTEB(
        20,
        20,
        20,
        (multiline ? _detailsBottom : _subjectBottom) - overhang,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(
            child: Text(
              label,
              // Inter Bold 14 / 17.2 with 0.42 tracking; the scale's 14 with
              // the nearest weight (SemiBold). Logged for the designer.
              style: AppType.labelLarge.copyWith(color: ext.supportInk),
            ),
          ),
          SizedBox(height: _labelToInput - overhang),
          Semantics(
            label: label,
            child: Stack(
              children: [
                // The white input as drawn, behind the field.
                Positioned.fill(
                  top: overhang,
                  bottom: overhang,
                  child: ElevatedSurface(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_inputRadius),
                    ),
                    color: ext.supportSurfaceFill,
                    shadows: elevation.supportInputShadows,
                    glass: elevation.fieldGlass,
                    child: const SizedBox.expand(),
                  ),
                ),
                TextField(
                  key: fieldKey,
                  controller: controller,
                  enabled: enabled,
                  onChanged: onChanged,
                  keyboardType: multiline
                      ? TextInputType.multiline
                      : TextInputType.text,
                  textInputAction:
                      textInputAction ??
                      (multiline
                          ? TextInputAction.newline
                          : TextInputAction.next),
                  minLines: multiline ? _detailsLines : 1,
                  maxLines: multiline ? null : 1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength),
                  ],
                  style: AppType.bodyLarge.copyWith(color: ext.textPrimary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // Dense, or Material floors the field at 48 whatever the
                    // padding says.
                    isDense: true,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(
                      _insetStart,
                      top,
                      _insetStart,
                      bottom,
                    ),
                    hintText: hint,
                    hintStyle: AppType.bodyLarge.copyWith(
                      color: ext.supportInputHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (errorText != null) InlineFieldError(errorText!),
        ],
      ),
    );
  }
}
