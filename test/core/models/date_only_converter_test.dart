import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/models/date_only_converter.dart';

void main() {
  const converter = DateOnlyConverter();

  group('toJson — contract `format: date` (yyyy-MM-dd)', () {
    test('emits a bare date, never an ISO-8601 timestamp', () {
      expect(converter.toJson(DateTime(2009, 5, 1)), '2009-05-01');
      expect(converter.toJson(DateTime(2009, 5, 1)), isNot(contains('T')));
    });

    test('zero-pads month and day', () {
      expect(converter.toJson(DateTime(2004, 3, 7)), '2004-03-07');
      expect(converter.toJson(DateTime(2011, 12, 31)), '2011-12-31');
    });

    test(
      'a local midnight does NOT shift a day (Egypt is UTC+2 — a DoB is a '
      'calendar date, not an instant)',
      () {
        // Constructed as LOCAL midnight: a toUtc() round-trip would render
        // 2009-04-30 for any timezone east of Greenwich.
        expect(converter.toJson(DateTime(2009, 5, 1)), '2009-05-01');
        // Late in the local day must not roll forward either.
        expect(converter.toJson(DateTime(2009, 5, 1, 23, 59)), '2009-05-01');
      },
    );
  });

  group('fromJson', () {
    test('parses a contract date string', () {
      final parsed = converter.fromJson('2009-05-01');
      expect(parsed.year, 2009);
      expect(parsed.month, 5);
      expect(parsed.day, 1);
    });

    test('round-trips', () {
      expect(converter.toJson(converter.fromJson('1998-02-28')), '1998-02-28');
    });
  });

  group('NullableDateOnlyConverter', () {
    const nullable = NullableDateOnlyConverter();

    test('passes null through both ways', () {
      expect(nullable.toJson(null), isNull);
      expect(nullable.fromJson(null), isNull);
    });

    test('formats a value identically to the non-null converter', () {
      expect(nullable.toJson(DateTime(2009, 5, 1)), '2009-05-01');
    });
  });
}
