import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/widgets/content_text_direction.dart';
import 'package:level_up_app/features/quiz/widgets/question_stem_text.dart';

/// `contentTextDirection`: server content's own direction, from its first
/// strong character, and the app's when it has none (BUG-020).
void main() {
  // null: no strong character, so the app's direction.
  const samples = <String, TextDirection?>{
    'Which plane divides the body into right and left parts?':
        TextDirection.ltr,
    'ما هو الوضع التشريحي؟': TextDirection.rtl,
    // Digits are weak: the first letter decides.
    '1. Vascular spasm': TextDirection.ltr,
    '1. المستوى السهمي': TextDirection.rtl,
    // The rule's known edge: an Arabic sentence that opens on a Latin term
    // takes the Latin term's direction.
    'ATP هو مصدر الطاقة.': TextDirection.ltr,
    '12 + 30 = ?': null,
    '': null,
  };

  test('a text takes its first strong character\'s direction, else the '
      'app\'s', () {
    for (final MapEntry(key: text, value: own) in samples.entries) {
      for (final app in TextDirection.values) {
        expect(
          contentTextDirection(text, fallback: app),
          own ?? app,
          reason: '"$text" in the $app app',
        );
      }
    }
  });

  testWidgets('it is the quiz question\'s rule, exactly', (tester) async {
    for (final text in samples.keys.where((text) => text.isNotEmpty)) {
      for (final app in TextDirection.values) {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(),
            child: Directionality(
              textDirection: app,
              child: QuestionStemText(text, style: const TextStyle()),
            ),
          ),
        );
        expect(
          tester
              .renderObject<RenderParagraph>(find.byType(RichText))
              .textDirection,
          contentTextDirection(text, fallback: app),
          reason: '"$text" in the $app app',
        );
      }
    }
  });
}
