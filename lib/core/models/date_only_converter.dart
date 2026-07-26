import 'package:json_annotation/json_annotation.dart';

/// Bridges a contract `format: date` field (`"2009-05-01"`) to a Dart
/// [DateTime]. Registration's `dateOfBirth` is the first consumer.
///
/// json_serializable's default `DateTime` handling emits a FULL ISO-8601
/// timestamp (`2009-05-01T00:00:00.000`), which is not what `format: date`
/// specifies — the server would reject it. This converter emits exactly
/// `yyyy-MM-dd`.
///
/// A date of birth is a CALENDAR date, not an instant: the local Y/M/D
/// components are written verbatim with no UTC conversion. Converting to UTC
/// first would shift the date by a day for students east of Greenwich —
/// Egypt is UTC+2, so every midnight-local birthday would serialize as the
/// previous day.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime date) => format(date);

  /// The wire format, exposed for the UI/validators that need it without a
  /// full serialization round-trip.
  static String format(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-$month-$day';
  }
}

/// Nullable sibling — for contract-optional date fields.
class NullableDateOnlyConverter implements JsonConverter<DateTime?, String?> {
  const NullableDateOnlyConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json);

  @override
  String? toJson(DateTime? date) =>
      date == null ? null : DateOnlyConverter.format(date);
}
