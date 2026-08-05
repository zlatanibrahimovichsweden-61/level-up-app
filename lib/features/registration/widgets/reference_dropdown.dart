import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../l10n/app_localizations.dart';
import '../registration_error_copy.dart';

/// One selectable row. Reference rows are bilingual (`nameAr`/`nameEn`) — the
/// label is resolved by locale at the call site via [localizedRefName], and the
/// opaque `id` is what gets submitted.
typedef PickerOption = ({String id, String label, Widget? leading});

/// Display the reference row in the reading locale; submit the id.
String localizedRefName(BuildContext context, String nameAr, String nameEn) =>
    Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

/// The rounded dropdown from the registration frames, with all four states
/// folded in.
///
/// Every picker on both screens is one of these, so the loading / empty /
/// error / offline handling exists exactly once instead of per field:
/// - `AsyncLoading`            → an in-field progress indicator
/// - `AsyncError`              → offline vs. generic copy + a user-tapped Retry
/// - `AsyncData` + empty list  → the localized "nothing to show" line
/// - `AsyncData`               → the dropdown itself
///
/// [enabled] is the cascade gate: a picker whose dependency is unchosen renders
/// [disabledHint] instead of firing a request it cannot scope
/// (Faculty before University, City before Governorate, …).
class ReferenceDropdown extends ConsumerWidget {
  const ReferenceDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    this.enabled = true,
    this.disabledHint,
    this.errorText,
    this.onRetry,
    this.fieldKey,
  });

  /// Field caption (localized).
  final String label;

  /// The selected option id, or null.
  final String? value;

  /// The reference rows, as an `AsyncValue` straight off a provider.
  final AsyncValue<List<PickerOption>> options;

  final ValueChanged<String> onSelected;

  /// False while an upstream selection is still missing.
  final bool enabled;

  /// Shown in place of the control when [enabled] is false.
  final String? disabledHint;

  /// A per-field validation message (client pre-flight or the server's map).
  final String? errorText;

  /// User-tapped retry for a failed load. Never auto-retried.
  final VoidCallback? onRetry;

  /// Stable key for widget tests / semantics, e.g. `'field-governorateId'`.
  final String? fieldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final hasError = errorText != null;

    Widget shell(Widget child, {VoidCallback? onTap}) => FieldShell(
          key: fieldKey == null ? null : Key(fieldKey!),
          enabled: enabled,
          hasError: hasError,
          onTap: onTap,
          semanticLabel: label,
          child: child,
        );

    final Widget control;
    if (!enabled) {
      control = shell(
        Text(
          disabledHint ?? l10n.selectHint,
          style: TextStyle(fontSize: 18, color: ext.hint),
        ),
      );
    } else {
      control = switch (options) {
        AsyncLoading() => shell(
            Row(
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.selectHint,
                  style: TextStyle(fontSize: 18, color: ext.hint),
                ),
              ],
            ),
          ),
        AsyncError(:final error) => _PickerFailure(
            message: referenceErrorMessage(l10n, error),
            isOffline: isOffline(error),
            onRetry: onRetry,
          ),
        AsyncData(value: final rows) when rows.isEmpty => shell(
            Text(
              l10n.noOptions,
              style: TextStyle(fontSize: 18, color: ext.hint),
            ),
          ),
        AsyncData(value: final rows) => shell(
            _Dropdown(
              value: rows.any((r) => r.id == value) ? value : null,
              rows: rows,
              hint: l10n.selectHint,
              onSelected: onSelected,
            ),
          ),
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(label),
        const SizedBox(height: 8),
        control,
        if (hasError) InlineFieldError(errorText!),
      ],
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.rows,
    required this.hint,
    required this.onSelected,
  });

  final String? value;
  final List<PickerOption> rows;
  final String hint;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        // Directional by default — the arrow sits at the end edge, which flips
        // under RTL along with the rest of the row.
        icon: Icon(Icons.keyboard_arrow_down, color: ext.hint),
        hint: Text(hint, style: TextStyle(fontSize: 18, color: ext.hint)),
        style: TextStyle(fontSize: 18, color: ext.textPrimary),
        dropdownColor: ext.fieldFill,
        borderRadius: BorderRadius.circular(20),
        items: [
          for (final row in rows)
            DropdownMenuItem<String>(
              value: row.id,
              child: Row(
                children: [
                  if (row.leading != null) ...[
                    row.leading!,
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(row.label, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
        ],
        onChanged: (id) {
          if (id != null) onSelected(id);
        },
      ),
    );
  }
}

/// A failed reference load, rendered in the field's own slot so one broken
/// picker never blanks the whole form. Offline gets its own copy and icon —
/// it is not a generic error.
class _PickerFailure extends StatelessWidget {
  const _PickerFailure({
    required this.message,
    required this.isOffline,
    this.onRetry,
  });

  final String message;
  final bool isOffline;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return FieldShell(
      hasError: true,
      child: Row(
        children: [
          Icon(
            isOffline ? Icons.wifi_off : Icons.error_outline,
            size: 20,
            color: cs.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: cs.error),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
