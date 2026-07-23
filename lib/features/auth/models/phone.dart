/// E.164 phone value type. The server is the source of truth for phone shape;
/// this mirrors the contract's `Phone` schema exactly:
///   pattern ^\+[1-9][0-9]{7,14}$  (e.g. +201001234567)
///
/// The Login field collects a local Egyptian number (placeholder 01021871999)
/// behind a fixed +20 chip; [tryParse] normalizes that to E.164 before it ever
/// reaches the repository. A small plain class (freezed optional per the brief).
library;

class Phone {
  const Phone._(this.e164);

  /// The normalized E.164 string, e.g. `+201021871999`. This is what is sent
  /// to `POST /auth/otp/request` and `/auth/otp/verify`.
  final String e164;

  /// Egypt default dial prefix. The Figma shows a typo `+02`; E.164 is `+20`.
  static const egyptDialCode = '+20';

  static final RegExp _e164 = RegExp(r'^\+[1-9][0-9]{7,14}$');

  /// Normalizes a locally-typed number to E.164 and validates it against the
  /// contract pattern. Returns null when the result is not a valid E.164 phone.
  ///
  /// - Arabic-Indic digits (٠-٩) are folded to ASCII.
  /// - Spaces, dashes and parentheses are stripped.
  /// - Input already starting with `+` is treated as complete E.164.
  /// - Otherwise a single leading national `0` is dropped and [dialCode] is
  ///   prepended (Egyptian mobiles are entered as 0100…, sent as +20100…).
  static Phone? tryParse(String input, {String dialCode = egyptDialCode}) {
    final folded = _foldDigits(input).replaceAll(RegExp(r'[\s\-()]'), '');
    if (folded.isEmpty) return null;

    final String candidate;
    if (folded.startsWith('+')) {
      candidate = folded;
    } else {
      final local = folded.startsWith('0') ? folded.substring(1) : folded;
      candidate = '$dialCode$local';
    }

    return _e164.hasMatch(candidate) ? Phone._(candidate) : null;
  }

  /// True when [input] normalizes to a valid E.164 phone.
  static bool isValid(String input, {String dialCode = egyptDialCode}) =>
      tryParse(input, dialCode: dialCode) != null;

  /// Folds Arabic-Indic (٠-٩) and Extended Arabic-Indic (۰-۹) digits to ASCII.
  static String _foldDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x0660 && rune <= 0x0669) {
        buffer.writeCharCode(0x30 + (rune - 0x0660)); // Arabic-Indic
      } else if (rune >= 0x06F0 && rune <= 0x06F9) {
        buffer.writeCharCode(0x30 + (rune - 0x06F0)); // Extended Arabic-Indic
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) => other is Phone && other.e164 == e164;

  @override
  int get hashCode => e164.hashCode;

  @override
  String toString() => 'Phone($e164)';
}
