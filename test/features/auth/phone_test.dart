import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/models/phone.dart';

void main() {
  group(
    'Phone.tryParse — normalizes to contract E.164 (^\\+[1-9][0-9]{7,14}\$)',
    () {
      test('Egyptian local number with leading 0 → +20…', () {
        expect(Phone.tryParse('01021871999')?.e164, '+201021871999');
      });

      test('local number without leading 0 → +20…', () {
        expect(Phone.tryParse('1021871999')?.e164, '+201021871999');
      });

      test('already-E.164 input is preserved', () {
        expect(Phone.tryParse('+201021871999')?.e164, '+201021871999');
      });

      test('Arabic-Indic digits are folded to ASCII', () {
        expect(Phone.tryParse('٠١٠٢١٨٧١٩٩٩')?.e164, '+201021871999');
      });

      test('spaces and dashes are stripped', () {
        expect(Phone.tryParse('010 2187-1999')?.e164, '+201021871999');
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
    expect(Phone.isValid('01021871999'), isTrue);
    expect(Phone.isValid('abc'), isFalse);
  });
}
