import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/models/phone.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

void main() {
  group(
    'Phone.tryParse — normalizes to contract E.164 (^\\+[1-9][0-9]{7,14}\$)',
    () {
      test('Egyptian local number with leading 0 → +20…', () {
        expect(Phone.tryParse('010000000001')?.e164, '+2010000000001');
      });

      test('local number without leading 0 → +20…', () {
        expect(Phone.tryParse('10000000001')?.e164, '+2010000000001');
      });

      test('already-E.164 input is preserved', () {
        expect(Phone.tryParse('+2010000000001')?.e164, '+2010000000001');
      });

      test('Arabic-Indic digits are folded to ASCII', () {
        expect(Phone.tryParse('٠١٠٠٠٠٠٠٠٠٠١')?.e164, '+2010000000001');
      });

      test('spaces and dashes are stripped', () {
        expect(Phone.tryParse('010 0000-00001')?.e164, '+2010000000001');
      });
    },
  );

  group('Phone.tryParse — rejects invalid input', () {
    test('empty', () => expect(Phone.tryParse(''), isNull));
    test('non-numeric', () => expect(Phone.tryParse('not a phone'), isNull));
    test('E.164 starting with +0 (fails [1-9])', () {
      expect(Phone.tryParse('+0123456789'), isNull);
    });
    test('too short after normalization', () {
      expect(Phone.tryParse('012'), isNull);
    });
  });

  test('isValid mirrors tryParse', () {
    expect(Phone.isValid('010000000001'), isTrue);
    expect(Phone.isValid('abc'), isFalse);
  });

  // N-26: the frame's sample in this hint was a real person's number. The
  // hint is a pattern now and must never again be a number someone can dial.
  test('the phone hint is not a dialable number, in either language', () {
    for (final code in const ['en', 'ar']) {
      final hint = lookupAppLocalizations(Locale(code)).phoneHint;
      expect(Phone.isValid(hint), isFalse, reason: 'phoneHint ($code)');
    }
  });
}
