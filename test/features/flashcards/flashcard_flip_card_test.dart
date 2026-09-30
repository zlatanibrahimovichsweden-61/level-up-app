import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/flashcards/widgets/flashcard_flip_card.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'reading_order.dart';

/// The flashcard on its own: the faces, the turn, the semantics. The screen's
/// behaviour (grading, rounds, errors) is in `flashcard_study_screen_test.dart`.
///
/// Figma `247:3260` — 363 x 454, radius 20, `#FCFBF9`, an inner shadow; front
/// `246:3237`, back `246:3235`.
void main() {
  const url = 'https://cdn.example.test/card-1.png';
  const cardKey = Key('card');

  // A card 362 x 454, the size the screen gives it on a 402-wide phone.
  Widget host({
    String front = 'What is A?',
    String back = 'Sclera',
    String? imageUrl,
    bool flipped = false,
    VoidCallback? onFlip,
    ThemeData? theme,
    Locale locale = const Locale('en'),
    bool reducedMotion = false,
    double textScale = 1,
    double height = 454,
  }) => MaterialApp(
    theme: theme ?? AppTheme.light,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: reducedMotion,
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 362,
            height: height,
            child: FlashcardFlipCard(
              key: cardKey,
              front: front,
              back: back,
              imageUrl: imageUrl,
              flipped: flipped,
              onFlip: onFlip,
            ),
          ),
        ),
      ),
    ),
  );

  Finder surface() => find.descendant(
    of: find.byKey(cardKey),
    matching: find.byType(ElevatedSurface),
  );

  /// The transform that turns the card: the nearest one above the surface.
  Matrix4 turn(WidgetTester tester) => tester
      .widget<Transform>(
        find.ancestor(of: surface(), matching: find.byType(Transform)).first,
      )
      .transform;

  /// The net x scale a piece of content is drawn with, all the way to the root.
  /// +1 reads the right way round; -1 is mirrored.
  double xScale(WidgetTester tester, Finder content) =>
      tester.renderObject(content).getTransformTo(null).storage[0];

  group('faces', () {
    testWidgets('the front shows the question and not the answer', (
      tester,
    ) async {
      await tester.pumpWidget(host());

      expect(find.text('What is A?'), findsOneWidget);
      expect(find.text('Sclera'), findsNothing);
    });

    testWidgets('flipped shows the answer and not the question', (
      tester,
    ) async {
      await tester.pumpWidget(host(flipped: true));

      expect(find.text('Sclera'), findsOneWidget);
      expect(find.text('What is A?'), findsNothing);
    });

    testWidgets('the surface is the frame\'s: radius 20, cream, inner shadow', (
      tester,
    ) async {
      await tester.pumpWidget(host());

      final s = tester.widget<ElevatedSurface>(surface());
      expect(
        (s.shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(20),
      );
      expect(s.color, AppColors.light.flashcardCardFill);
      expect(s.shadows, AppElevation.light.flashcardCardShadows);
      expect(s.shadows.single.inset, isTrue);
    });

    testWidgets('dark canvas: the card stays the light object it is', (
      tester,
    ) async {
      await tester.pumpWidget(host(theme: AppTheme.dark));

      final s = tester.widget<ElevatedSurface>(surface());
      expect(s.color, const Color(0xFFFCFBF9));
      expect(s.shadows, AppElevation.dark.flashcardCardShadows);
      // Ink on the cream card is the frame's green, on both canvases.
      expect(
        tester.widget<Text>(find.text('What is A?')).style!.color,
        AppColors.dark.flashcardCardText,
      );
    });

    testWidgets('the front is the H1 style and the back the largest', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      final front = tester.widget<Text>(find.text('What is A?'));
      expect(front.style!.fontSize, 24);
      expect(front.style!.fontWeight, FontWeight.w700);
      expect(front.textAlign, TextAlign.center);
      expect(front.style!.color, AppColors.light.flashcardCardText);

      await tester.pumpWidget(host(flipped: true));
      await tester.pumpAndSettle();
      final back = tester.widget<Text>(find.text('Sclera'));
      expect(back.style!.fontSize, 28);
      expect(back.textAlign, TextAlign.center);
      expect(back.style!.color, AppColors.light.flashcardCardText);
    });

    testWidgets('an image-less front centres its text in the card', (
      tester,
    ) async {
      await tester.pumpWidget(host());

      expect(find.byType(Image), findsNothing);
      final card = tester.getRect(find.byKey(cardKey));
      final text = tester.getCenter(find.text('What is A?'));
      expect(text.dx, moreOrLessEquals(card.center.dx, epsilon: 0.01));
      expect(text.dy, moreOrLessEquals(card.center.dy, epsilon: 0.01));
    });

    testWidgets('the back is centred too, and is a wrapping block', (
      tester,
    ) async {
      const answer = 'Cornea\nSclera\nRetina\nA long third answer that goes on';
      await tester.pumpWidget(host(back: answer, flipped: true));

      final card = tester.getRect(find.byKey(cardKey));
      final text = tester.getRect(find.text(answer));
      expect(text.center.dx, moreOrLessEquals(card.center.dx, epsilon: 0.01));
      expect(text.center.dy, moreOrLessEquals(card.center.dy, epsilon: 0.01));
      // Four lines at least — a label would be one.
      expect(text.height, greaterThanOrEqualTo(4 * 34));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a long answer scrolls inside the card instead of overflowing',
      (tester) async {
        final answer = List.generate(40, (i) => 'answer line $i').join('\n');
        await tester.pumpWidget(host(back: answer, flipped: true));

        expect(tester.takeException(), isNull);
        final scroll = find.descendant(
          of: find.byKey(cardKey),
          matching: find.byType(Scrollable),
        );
        expect(scroll, findsOneWidget);
        final position = tester.state<ScrollableState>(scroll).position;
        expect(position.maxScrollExtent, greaterThan(0));
        // The card did not grow to fit it.
        expect(tester.getSize(find.byKey(cardKey)).height, 454);

        await tester.drag(scroll, const Offset(0, -300));
        await tester.pump();
        expect(position.pixels, greaterThan(0));
      },
    );

    testWidgets('a long question scrolls too, and 2x text does not overflow', (
      tester,
    ) async {
      final question = List.filled(30, 'a very long question').join(' ');
      await tester.pumpWidget(host(front: question, textScale: 2));

      expect(tester.takeException(), isNull);
      expect(
        tester
            .state<ScrollableState>(
              find.descendant(
                of: find.byKey(cardKey),
                matching: find.byType(Scrollable),
              ),
            )
            .position
            .maxScrollExtent,
        greaterThan(0),
      );
    });
  });

  group('the image', () {
    _imageTest(
      'a URL draws the frame\'s box: card - 15 wide, 223 tall, 25 in',
      (tester, http) async {
        await tester.pumpWidget(host(imageUrl: url));

        final image = tester.widget<Image>(find.byType(Image));
        expect((image.image as NetworkImage).url, url);
        expect(image.fit, BoxFit.cover);
        expect(image.excludeFromSemantics, isTrue);
        expect(image.errorBuilder, isNotNull);

        final card = tester.getRect(find.byKey(cardKey));
        final box = tester.getRect(find.byType(Image));
        expect(box.size, const Size(362 - 15, 223));
        expect(box.top, card.top + 25);
        // Centred: 7.5 each side.
        expect(box.left - card.left, 7.5);
        expect(card.right - box.right, 7.5);
      },
    );

    _imageTest('the question sits 43 under the image, centred on it', (
      tester,
      http,
    ) async {
      await tester.pumpWidget(host(imageUrl: url));

      final box = tester.getRect(find.byType(Image));
      final text = tester.getRect(find.text('What is A?'));
      expect(text.top, moreOrLessEquals(box.bottom + 43, epsilon: 0.01));
      expect(text.center.dx, moreOrLessEquals(box.center.dx, epsilon: 0.01));
    });

    _imageTest('no URL, no Image widget at all', (tester, http) async {
      await tester.pumpWidget(host());
      expect(find.byType(Image), findsNothing);
    });

    _imageTest('the back face never draws the image', (tester, http) async {
      await tester.pumpWidget(host(imageUrl: url, flipped: true));
      expect(find.byType(Image), findsNothing);
      expect(find.text('Sclera'), findsOneWidget);
    });

    _imageTest('an image that fails collapses to nothing and the text '
        're-centres', (tester, http) async {
      http.fail = true;
      await tester.pumpWidget(host(imageUrl: url));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsNothing);
      expect(find.byIcon(Icons.broken_image), findsNothing);
      final card = tester.getRect(find.byKey(cardKey));
      final text = tester.getCenter(find.text('What is A?'));
      expect(text.dy, moreOrLessEquals(card.center.dy, epsilon: 0.01));
      expect(tester.takeException(), isNull);
    });
  });

  group('the flip', () {
    testWidgets('a tap calls onFlip once', (tester) async {
      var flips = 0;
      await tester.pumpWidget(host(onFlip: () => flips++));

      await tester.tap(find.byKey(cardKey));
      expect(flips, 1);
    });

    testWidgets('a null onFlip is inert', (tester) async {
      await tester.pumpWidget(host());
      await tester.tap(find.byKey(cardKey));
      await tester.pump();
      expect(find.text('What is A?'), findsOneWidget);
    });

    testWidgets('it turns over 300 ms, ease-out, and is at rest after', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      await tester.pumpWidget(host(flipped: true));
      // The first frame of the turn: nothing has moved yet.
      expect(find.text('What is A?'), findsOneWidget);
      expect(turn(tester).storage[0], moreOrLessEquals(1, epsilon: 0.001));

      // 60 ms in, still the front face, and already off flat.
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('What is A?'), findsOneWidget);
      expect(turn(tester).storage[0], lessThan(0.99));

      // 150 ms is HALF the time. A linear turn would be exactly edge-on here;
      // ease-out is well past it.
      await tester.pump(const Duration(milliseconds: 90));
      expect(find.text('Sclera'), findsOneWidget);
      expect(turn(tester).storage[0], lessThan(-0.3));
      expect(turn(tester).storage[0], greaterThan(-0.9));

      // Still turning just short of 300 ms; done just past it.
      await tester.pump(const Duration(milliseconds: 149));
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pump(const Duration(milliseconds: 2));
      expect(tester.hasRunningAnimations, isFalse);
      // Rest: a half turn, the card face-on again.
      expect(turn(tester).storage[0], moreOrLessEquals(-1, epsilon: 0.001));
    });

    testWidgets('it turns back the same way', (tester) async {
      await tester.pumpWidget(host(flipped: true));
      await tester.pumpWidget(host());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      // Half the time, and the reverse turn is already back on the front.
      expect(find.text('What is A?'), findsOneWidget);
      expect(turn(tester).storage[0], greaterThan(0.3));

      await tester.pumpAndSettle();
      expect(find.text('What is A?'), findsOneWidget);
      expect(turn(tester).storage[0], moreOrLessEquals(1, epsilon: 0.001));
    });

    testWidgets('the back is never drawn mirrored: at rest', (tester) async {
      await tester.pumpWidget(host());
      await tester.pumpWidget(host(flipped: true));
      await tester.pumpAndSettle();

      expect(xScale(tester, find.text('Sclera')), moreOrLessEquals(1));
    });

    testWidgets('the back is never drawn mirrored: at any moment of the turn', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      await tester.pumpWidget(host(flipped: true));
      for (var ms = 0; ms < 320; ms += 20) {
        await tester.pump(const Duration(milliseconds: 20));
        if (find.text('Sclera').evaluate().isNotEmpty) {
          expect(
            xScale(tester, find.text('Sclera')),
            greaterThan(0),
            reason: 'mirrored at ${ms + 20} ms',
          );
        }
      }
    });

    testWidgets('the front is never mirrored either', (tester) async {
      await tester.pumpWidget(host());
      expect(xScale(tester, find.text('What is A?')), moreOrLessEquals(1));

      await tester.pumpWidget(host(flipped: true));
      await tester.pumpAndSettle();
      await tester.pumpWidget(host());
      await tester.pumpAndSettle();
      expect(xScale(tester, find.text('What is A?')), moreOrLessEquals(1));
    });

    testWidgets('reduced motion: the other face is simply there, no turn', (
      tester,
    ) async {
      await tester.pumpWidget(host(reducedMotion: true));
      await tester.pumpWidget(host(reducedMotion: true, flipped: true));

      // One frame, no time passed.
      expect(find.text('Sclera'), findsOneWidget);
      expect(find.text('What is A?'), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
      expect(turn(tester).storage[0], moreOrLessEquals(-1, epsilon: 0.001));
      expect(xScale(tester, find.text('Sclera')), moreOrLessEquals(1));

      await tester.pumpWidget(host(reducedMotion: true));
      expect(find.text('What is A?'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('a card built already flipped starts on its back', (
      tester,
    ) async {
      await tester.pumpWidget(host(flipped: true));
      expect(find.text('Sclera'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('semantics', () {
    testWidgets('one button, labelled with the face that is up', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(onFlip: () {}));

      expect(
        tester.getSemantics(find.byKey(cardKey)),
        isSemantics(
          isButton: true,
          label: 'What is A?',
          hasTapAction: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );
      // The text is the card's label, not a second node beside it.
      expect(find.bySemanticsLabel('What is A?'), findsOneWidget);

      await tester.pumpWidget(host(onFlip: () {}, flipped: true));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.byKey(cardKey)),
        isSemantics(isButton: true, label: 'Sclera'),
      );
      expect(find.bySemanticsLabel('What is A?'), findsNothing);
      handle.dispose();
    });

    testWidgets('inert reads as disabled', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host());

      expect(
        tester.getSemantics(find.byKey(cardKey)),
        isSemantics(
          isButton: true,
          isEnabled: false,
          hasEnabledState: true,
          label: 'What is A?',
        ),
      );
      handle.dispose();
    });

    testWidgets('a screen reader\'s tap flips it', (tester) async {
      final handle = tester.ensureSemantics();
      var flips = 0;
      await tester.pumpWidget(host(onFlip: () => flips++));

      tester.semantics.tap(find.semantics.byLabel('What is A?'));
      expect(flips, 1);
      handle.dispose();
    });

    _imageTest('an image does not add a node of its own', (tester, http) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(imageUrl: url, onFlip: () {}));

      expect(find.bySemanticsLabel('What is A?'), findsOneWidget);
      expect(
        tester.getSemantics(find.byKey(cardKey)),
        isSemantics(isButton: true, label: 'What is A?'),
      );
      handle.dispose();
    });
  });

  group('Arabic', () {
    testWidgets('both faces centre in RTL, unmirrored', (tester) async {
      await tester.pumpWidget(
        host(
          front: 'ما هو أ؟',
          back: 'الصلبة',
          locale: const Locale('ar'),
          flipped: true,
        ),
      );

      final card = tester.getRect(find.byKey(cardKey));
      expect(
        tester.getCenter(find.text('الصلبة')).dx,
        moreOrLessEquals(card.center.dx, epsilon: 0.01),
      );
      expect(xScale(tester, find.text('الصلبة')), moreOrLessEquals(1));
    });
  });

  // BUG-020 (the Wave 22 walk): each face takes its direction from its own
  // text, never from the app's. These are the mock deck's own cards, the ones
  // the Pixel 8 caught: in Arabic the English question drew its "?" at the
  // start of "?into right and left parts"; in English the Arabic answer drew
  // its closing full stop at the right.
  group('each face keeps its own direction (BUG-020)', () {
    const enFront = 'Which plane divides the body into right and left parts?';
    const enBack =
        'The sagittal plane. The median (midsagittal) plane passes through '
        'the midline and divides the body into equal right and left halves.';
    const arFront = 'ما هو الوضع التشريحي؟';
    const arBack =
        'وقوف الجسم منتصبًا مع النظر إلى الأمام، والذراعان بجانب الجسم، '
        'وراحتا اليدين إلى الأمام.';
    const arList =
        'المستوى السهمي\n'
        'المستوى الإكليلي (الجبهي)\n'
        'المستوى المستعرض (الأفقي)';

    RenderParagraph paragraph(WidgetTester tester, String text) =>
        tester.renderObject<RenderParagraph>(find.text(text));

    void expectCentred(WidgetTester tester, String text) {
      expect(tester.widget<Text>(find.text(text)).textAlign, TextAlign.center);
      expect(
        tester.getCenter(find.text(text)).dx,
        moreOrLessEquals(
          tester.getCenter(find.byKey(cardKey)).dx,
          epsilon: 0.01,
        ),
      );
    }

    testWidgets('A · Arabic app, English question: it reads left to right and '
        'the "?" closes its line on the right', (tester) async {
      await tester.pumpWidget(host(front: enFront, locale: const Locale('ar')));

      final p = paragraph(tester, enFront);
      expect(expectReadingOrder(p, enFront, TextDirection.ltr), greaterThan(1));
      final mark = inkOf(p, enFront.length - 1, enFront.length);
      final parts = inkOf(p, enFront.lastIndexOf('parts'), enFront.length - 1);
      expect(mark.left, greaterThanOrEqualTo(parts.right - 0.01));
      expect(mark.center.dy, moreOrLessEquals(parts.center.dy, epsilon: 0.01));
      expectCentred(tester, enFront);
    });

    testWidgets('A · Arabic app, English answer: every line reads left to '
        'right, its full stops and parentheses in place', (tester) async {
      await tester.pumpWidget(
        host(back: enBack, flipped: true, locale: const Locale('ar')),
      );

      final p = paragraph(tester, enBack);
      expect(expectReadingOrder(p, enBack, TextDirection.ltr), greaterThan(1));
      expectCentred(tester, enBack);
      expect(xScale(tester, find.text(enBack)), moreOrLessEquals(1));
    });

    testWidgets('B · English app, Arabic answer: it reads right to left and '
        'the full stop closes its line on the left', (tester) async {
      await tester.pumpWidget(host(back: arBack, flipped: true));

      final p = paragraph(tester, arBack);
      expect(expectReadingOrder(p, arBack, TextDirection.rtl), greaterThan(1));
      final stop = inkOf(p, arBack.length - 1, arBack.length);
      final word = inkOf(p, arBack.lastIndexOf('الأمام'), arBack.length - 1);
      expect(stop.right, lessThanOrEqualTo(word.left + 0.01));
      expect(stop.center.dy, moreOrLessEquals(word.center.dy, epsilon: 0.01));
      expectCentred(tester, arBack);
      expect(xScale(tester, find.text(arBack)), moreOrLessEquals(1));
    });

    // This one and the next draw the same before the fix: "؟" is itself an
    // Arabic letter-class character, and a bracket pair resolves as a pair.
    // They pin the direction; the moved marks are the cases above.
    testWidgets('B · English app, Arabic answers on separate lines: each line '
        'reads right to left, its parentheses included', (tester) async {
      await tester.pumpWidget(host(back: arList, flipped: true));

      final p = paragraph(tester, arList);
      // Three answers, each on a line of its own at least (the test font is
      // wide enough to wrap them further).
      expect(
        expectReadingOrder(p, arList, TextDirection.rtl),
        greaterThanOrEqualTo(3),
      );
      expectCentred(tester, arList);
    });

    testWidgets('B · English app, Arabic question: "؟" closes it on the left', (
      tester,
    ) async {
      await tester.pumpWidget(host(front: arFront));

      expectReadingOrder(
        paragraph(tester, arFront),
        arFront,
        TextDirection.rtl,
      );
      expectCentred(tester, arFront);
    });

    testWidgets('C · Arabic app, Arabic card: both faces still read right to '
        'left', (tester) async {
      await tester.pumpWidget(
        host(front: arFront, back: arBack, locale: const Locale('ar')),
      );
      expectReadingOrder(
        paragraph(tester, arFront),
        arFront,
        TextDirection.rtl,
      );
      expectCentred(tester, arFront);

      await tester.pumpWidget(
        host(
          front: arFront,
          back: arBack,
          locale: const Locale('ar'),
          flipped: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        expectReadingOrder(
          paragraph(tester, arBack),
          arBack,
          TextDirection.rtl,
        ),
        greaterThan(1),
      );
      expectCentred(tester, arBack);
    });

    testWidgets('D · English app, English card: both faces still read left to '
        'right', (tester) async {
      await tester.pumpWidget(host(front: enFront, back: enBack));
      expect(
        expectReadingOrder(
          paragraph(tester, enFront),
          enFront,
          TextDirection.ltr,
        ),
        greaterThan(1),
      );
      expectCentred(tester, enFront);

      await tester.pumpWidget(
        host(front: enFront, back: enBack, flipped: true),
      );
      await tester.pumpAndSettle();
      expect(
        expectReadingOrder(
          paragraph(tester, enBack),
          enBack,
          TextDirection.ltr,
        ),
        greaterThan(1),
      );
      expectCentred(tester, enBack);
    });

    testWidgets('the app\'s language does not move a card\'s text at all', (
      tester,
    ) async {
      for (final (text, flipped) in [
        (enFront, false),
        (enBack, true),
        (arFront, false),
        (arBack, true),
        (arList, true),
      ]) {
        // Every character's boxes, in the paragraph's own coordinates.
        List<List<TextBox>> layout() {
          final p = paragraph(tester, text);
          return [
            for (var i = 0; i < text.length; i++)
              p.getBoxesForSelection(
                TextSelection(baseOffset: i, extentOffset: i + 1),
              ),
          ];
        }

        await tester.pumpWidget(
          host(
            front: flipped ? 'x' : text,
            back: flipped ? text : 'x',
            flipped: flipped,
          ),
        );
        // The previous text's card may have been on its other face.
        await tester.pumpAndSettle();
        final english = layout();
        final direction = paragraph(tester, text).textDirection;

        await tester.pumpWidget(
          host(
            front: flipped ? 'x' : text,
            back: flipped ? text : 'x',
            flipped: flipped,
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();
        expect(paragraph(tester, text).textDirection, direction, reason: text);
        expect(layout(), english, reason: text);
      }
    });

    testWidgets('text with no letters at all follows the app', (tester) async {
      const sum = '12 + 30 = ?';
      await tester.pumpWidget(host(front: sum));
      expect(paragraph(tester, sum).textDirection, TextDirection.ltr);

      await tester.pumpWidget(host(front: sum, locale: const Locale('ar')));
      expect(paragraph(tester, sum).textDirection, TextDirection.rtl);
    });

    testWidgets('a screen reader gets the face\'s own direction with its '
        'label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          front: enFront,
          back: arBack,
          onFlip: () {},
          locale: const Locale('ar'),
        ),
      );
      expect(
        tester.getSemantics(find.byKey(cardKey)),
        isSemantics(
          isButton: true,
          label: enFront,
          textDirection: TextDirection.ltr,
          hasTapAction: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );

      await tester.pumpWidget(
        host(front: enFront, back: arBack, onFlip: () {}, flipped: true),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.byKey(cardKey)),
        isSemantics(
          isButton: true,
          label: arBack,
          textDirection: TextDirection.rtl,
        ),
      );
      handle.dispose();
    });

    _imageTest('with an image, the question keeps its own direction too', (
      tester,
      http,
    ) async {
      await tester.pumpWidget(
        host(front: enFront, imageUrl: url, locale: const Locale('ar')),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(
        expectReadingOrder(
          paragraph(tester, enFront),
          enFront,
          TextDirection.ltr,
        ),
        greaterThan(1),
      );
    });
  });
}

/// A `testWidgets` with the network stand-in installed for the test BODY.
///
/// Reset inside the body, not in a `tearDown`: the binding asserts that no
/// painting debug variable is left set BEFORE tear-downs run. The image cache is
/// cleared both ends so a URL another test left pending is not picked up here.
void _imageTest(
  String name,
  Future<void> Function(WidgetTester tester, _ImageHttp http) body,
) {
  testWidgets(name, (tester) async {
    final http = _ImageHttp();
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    debugNetworkImageHttpClientProvider = () => http;
    try {
      await body(tester, http);
    } finally {
      debugNetworkImageHttpClientProvider = null;
      PaintingBinding.instance.imageCache
        ..clear()
        ..clearLiveImages();
    }
  });
}

/// A stand-in for the network behind `Image.network`, installed through the
/// framework's own test hook. By default a request never answers, so an image
/// stays "loading" and the box is measurable; with [fail] it errors at once.
class _ImageHttp extends Fake implements HttpClient {
  bool fail = false;

  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    if (fail) {
      return Future<HttpClientRequest>.error(const SocketException('x'));
    }
    // Never completes, and holds no timer for the test to trip over.
    return Completer<HttpClientRequest>().future;
  }
}
