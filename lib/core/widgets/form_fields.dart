import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// The shared rounded form primitives from the Figma auth/registration frames
/// (Login `82:819`, Sign Up_1 `337:15875`, School Registration `337:5269`,
/// University Registration `337:10373`) — one 60pt-tall pill with a 20pt radius,
/// `fieldFill` background and a 1.17pt `fieldBorder`.
///
/// They live in core rather than per-feature because the same three pieces
/// (label → control → inline error) recur on every form screen. Every value
/// comes from a theme token; nothing here holds a raw hex.

/// The caption above a field.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Text(
      text,
      style: AppType.labelLarge.copyWith(color: ext.textSecondary),
    );
  }
}

/// The rounded pill every control sits inside.
///
/// [hasError] switches the border to the error colour so a per-field validation
/// message and its field are visually linked; [enabled] dims it for a control
/// still waiting on its dependency (e.g. Faculty before a University is picked).
class FieldShell extends StatelessWidget {
  const FieldShell({
    super.key,
    required this.child,
    this.enabled = true,
    this.hasError = false,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final bool enabled;
  final bool hasError;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    final container = Container(
      height: 60,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
      alignment: AlignmentDirectional.centerStart,
      decoration: BoxDecoration(
        color: ext.fieldFill,
        border: Border.all(
          color: hasError ? cs.error : ext.fieldBorder,
          width: hasError ? 1.5 : 1.17,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DefaultTextStyle.merge(
        style: AppType.bodyLarge.copyWith(
          color: enabled ? ext.textPrimary : ext.hint,
        ),
        child: child,
      ),
    );

    final opaque = enabled
        ? container
        : Opacity(opacity: 0.6, child: container);
    if (onTap == null) return opaque;

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: opaque,
      ),
    );
  }
}

/// A per-field validation message. Shown under the field it belongs to — the
/// same slot is used for client-side issues and the server's `validation_failed`
/// field map.
class InlineFieldError extends StatelessWidget {
  const InlineFieldError(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: cs.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppType.captionRegular.copyWith(color: cs.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single-line text input inside a [FieldShell]. `maxLength` hard-caps via a
/// formatter (no counter), matching the contract's `maxLength` on the field.
class PlainTextField extends StatelessWidget {
  const PlainTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.hasError = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return FieldShell(
      hasError: hasError,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: maxLength != null
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : null,
        style: AppType.bodyLarge.copyWith(color: ext.textPrimary),
        decoration: InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
          hintText: hint,
          hintStyle: AppType.bodyLarge.copyWith(color: ext.hint),
        ),
      ),
    );
  }
}
