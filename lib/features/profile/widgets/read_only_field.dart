import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/form_fields.dart';

/// One immutable fact about the student, shown on Edit Profile · Figma
/// `180:3989`.
///
/// The frame draws phone, parent phone, city, school, education system and
/// grade as inputs — three of them with a dropdown caret. `PATCH /me` accepts
/// none of them: they are fixed at registration, and phone especially is the
/// identity anchor (adr-019, phone-verify-first). `seif_fight.md` **S20**.
///
/// **This is not a disabled input, and the difference is the whole widget.** A
/// dimmed, greyed-out text field reads as *broken* — the student assumes the
/// screen failed to load. A read-only row reads as *fixed*: full contrast, the
/// same pill the editable fields use, and a padlock where a caret would be. So
/// there is no [Opacity] here and no `enabled: false`.
///
/// Structurally there is no [TextField] and no [InkWell] anywhere in the
/// subtree, which is what makes "renders but cannot be edited" something a test
/// can assert rather than something a comment claims.
class ReadOnlyField extends StatelessWidget {
  const ReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    required this.lockedHint,
    this.forceLtr = false,
  });

  final String label;

  /// Already resolved for display — the localized city name, the localized
  /// stage, the E.164 phone. This widget never picks a locale arm itself.
  final String value;

  /// Screen-reader reason. Sighted students get the padlock; everyone else
  /// gets told, rather than being left to wonder why the field will not focus.
  final String lockedHint;

  /// Phone numbers read left-to-right whatever the UI locale is doing.
  final bool forceLtr;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    final text = Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18, color: ext.textSecondary),
    );

    return Semantics(
      readOnly: true,
      label: label,
      value: value,
      hint: lockedHint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldLabel(label),
          const SizedBox(height: 8),
          FieldShell(
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: forceLtr
                        ? Directionality(
                            textDirection: TextDirection.ltr,
                            child: text,
                          )
                        : text,
                  ),
                ),
                // Where the frame draws a dropdown caret on three of these
                // rows. A caret promises a list that opens; this promises the
                // opposite, which is the truth.
                Icon(Icons.lock_outline, size: 18, color: ext.hint),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
