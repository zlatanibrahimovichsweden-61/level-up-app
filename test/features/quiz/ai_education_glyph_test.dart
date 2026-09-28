/// DESIGN_ISSUES #98, owner ruling 2026-09-27: the `tdesign:ai-education`
/// glyph is drawn at the frame's own scale inside its 26.55 Iconify box. Every
/// instance read (`159:1839`, `337:9272`, `159:2348`, `348:7871`, `162:2589`)
/// holds a 22.12 x 21.01 group 2.215 / 2.289 into the box, and the asset's
/// geometry is that group at 1:1 in a 27 x 25 viewBox.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/quiz/widgets/ai_education_glyph.dart';

void main() {
  Future<void> pumpGlyph(
    WidgetTester tester, {
    TextDirection direction = TextDirection.ltr,
  }) => tester.pumpWidget(
    MaterialApp(
      home: Directionality(
        textDirection: direction,
        child: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: AiEducationGlyph(color: Colors.black),
          ),
        ),
      ),
    ),
  );

  testWidgets('the box is the frame\'s 26.55 square', (tester) async {
    await pumpGlyph(tester);
    expect(
      tester.getSize(find.byType(AiEducationGlyph)),
      const Size.square(26.55),
    );
  });

  testWidgets('the asset is drawn 27 x 25, at 1:1, not boxed into the '
      'square', (tester) async {
    await pumpGlyph(tester);

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.height, 25);
    // Boxing it (width AND height 26.55) drew it 28.67 x 26.55: the width
    // passed alongside a height is ignored.
    expect(svg.width, isNull);
    final drawn = tester.getRect(find.byType(SvgPicture));
    expect(drawn.height, closeTo(25, 0.01));
    expect(drawn.width, closeTo(27, 0.01));
  });

  for (final direction in TextDirection.values) {
    testWidgets('${direction.name}: the drawing lands on the frame\'s group, '
        '2.215 / 2.289 into the box', (tester) async {
      await pumpGlyph(tester, direction: direction);

      final box = tester.getRect(find.byType(AiEducationGlyph));
      final drawn = tester.getRect(find.byType(SvgPicture));
      // The asset's geometry starts 2.03076 / 2.28735 into its viewBox.
      expect(drawn.left + 2.03076 - box.left, closeTo(2.215, 0.001));
      expect(drawn.top + 2.28735 - box.top, closeTo(2.289, 0.001));
    });
  }

  testWidgets('it adds no image to the semantics tree; its colour is the '
      'caller\'s', (tester) async {
    await pumpGlyph(tester);

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.excludeFromSemantics, isTrue);
    expect(
      svg.colorFilter,
      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
    );
  });
}
