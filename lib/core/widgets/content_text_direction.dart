import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show Bidi;

/// The direction to lay out server content in: the direction of its first
/// strong character, and [fallback] (the app's) when it has none (digits and
/// symbols only).
///
/// Content arrives in the content language (adr-018), which need not be the
/// app's: an English card in the Arabic app, an Arabic lecture name in the
/// English one. Laid out in the app's direction instead, a line's neutral
/// punctuation lands at the wrong end: the Arabic app drew an English card's
/// closing "?" at the START of "?into right and left parts" (BUG-020, the
/// Wave 22 walk).
///
/// The rule is the quiz question's (`QuestionStemText`, Wave 13/14); one
/// direction per text, taken from where it starts.
TextDirection contentTextDirection(
  String text, {
  required TextDirection fallback,
}) => Bidi.startsWithRtl(text)
    ? TextDirection.rtl
    : Bidi.startsWithLtr(text)
    ? TextDirection.ltr
    : fallback;
