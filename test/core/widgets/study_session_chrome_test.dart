import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/study_session_chrome.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The chrome the quiz question screen and the flashcards study screen share
/// (API→UI Wave 22). The quiz's own tests (`quiz_screen_test.dart`, Wave 12)
/// pin the ✕, the rule, the height, the bar and the counter THROUGH the quiz
/// and were not touched by the move; they do NOT pin where the title sits, and
/// they cannot pin the parameterisation the flashcards screen relies on — the
/// title, the fill colour and the keys arrive from outside. This file pins
/// both, and what the header must NOT hold (no second glyph, no second
/// tappable).
void main() {
  const headerKey = Key('study_header');
  const closeKey = Key('study_close');

  Widget host(
    Widget child, {
    ThemeData? theme,
    Locale locale = const Locale('en'),
  }) => MaterialApp(
    theme: theme ?? AppTheme.light,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [child],
      ),
    ),
  );

  StudySessionHeader header({
    String title = 'Flash cards',
    VoidCallback? onClose,
    int position = 3,
    int total = 10,
    Color fill = const Color(0xFF5A7F73),
  }) => StudySessionHeader(
    headerKey: headerKey,
    closeKey: closeKey,
    title: title,
    onClose: onClose ?? () {},
    position: position,
    total: total,
    progressFill: fill,
  );

  LinearProgressIndicator bar(WidgetTester tester) =>
      tester.widget(find.byType(LinearProgressIndicator));

  /// Whether [title] was cut short with an ellipsis.
  bool ellipsised(WidgetTester tester, String title) =>
      tester.renderObject<RenderParagraph>(find.text(title)).didExceedMaxLines;

  group('StudySessionHeader', () {
    testWidgets('draws the title it is given, not the quiz\'s', (tester) async {
      await tester.pumpWidget(host(header(title: 'Flash cards')));

      expect(find.text('Flash cards'), findsOneWidget);
      expect(find.text('Quiz'), findsNothing);
    });

    // The owner's instruction: the title is CENTRED on the screen, not on the
    // room left beside the ✕. A `Stack(alignment: center)` and a symmetric
    // 48 dp inset are all that hold it there, and nothing else pins its x —
    // the quiz's tests read the ✕, the rule, the bar and the counter only.
    for (final (name, locale, short, long) in [
      (
        'EN',
        const Locale('en'),
        'Flash cards',
        'A study session title far too long to fit between the two close '
            'targets of the header',
      ),
      (
        'AR',
        const Locale('ar'),
        'فلاش كارد',
        'عنوان جلسة دراسة أطول بكثير من أن يتسع بين زر الإغلاق وحافة الشاشة '
            'المقابلة له',
      ),
    ]) {
      testWidgets('$name: the title sits on the screen centre, short or '
          'ellipsised', (tester) async {
        tester.view.physicalSize = const Size(402, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(host(header(title: short), locale: locale));
        expect(ellipsised(tester, short), isFalse);
        expect(
          tester.getCenter(find.text(short)).dx,
          moreOrLessEquals(402 / 2, epsilon: 0.5),
        );

        await tester.pumpWidget(host(header(title: long), locale: locale));
        // The long one really is cut, or this proves nothing about it...
        expect(ellipsised(tester, long), isTrue);
        // ...and it still sits on the centre line, clear of the ✕ target.
        final title = tester.getRect(find.text(long));
        expect(title.center.dx, moreOrLessEquals(402 / 2, epsilon: 0.5));
        final cross = tester.getRect(find.byKey(closeKey));
        if (locale.languageCode == 'ar') {
          expect(title.right, lessThanOrEqualTo(cross.left + 0.01));
        } else {
          expect(title.left, greaterThanOrEqualTo(cross.right - 0.01));
        }
      });
    }

    testWidgets('holds exactly one SvgPicture (the ✕) and one tappable', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(header()));

      // The frame's bookmark and share glyphs are SVGs (503:6807, 503:6811),
      // and so is the ✕: count the pictures, not just Material icons.
      final pictures = find.descendant(
        of: find.byKey(headerKey),
        matching: find.byType(SvgPicture),
      );
      expect(pictures, findsOneWidget);
      expect(
        find.descendant(of: find.byKey(closeKey), matching: pictures),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byKey(headerKey), matching: find.byType(Icon)),
        findsNothing,
      );

      // One node a screen reader can act on, and it is the ✕. The host holds
      // nothing but the header, so the whole tree is the header's.
      expect(
        find.semantics.byAction(SemanticsAction.tap).evaluate(),
        hasLength(1),
      );
      expect(
        find.semantics
            .byPredicate((n) => n.getSemanticsData().flagsCollection.isButton)
            .evaluate(),
        hasLength(1),
      );
      handle.dispose();
    });

    testWidgets('the bar and the counter follow position and total', (
      tester,
    ) async {
      await tester.pumpWidget(host(header(position: 3, total: 10)));

      expect(find.text('3/10'), findsOneWidget);
      expect(bar(tester).value, closeTo(0.3, 1e-9));
    });

    testWidgets('a short pool reads n/short, and the last card fills the bar', (
      tester,
    ) async {
      await tester.pumpWidget(host(header(position: 7, total: 7)));

      expect(find.text('7/7'), findsOneWidget);
      expect(bar(tester).value, 1.0);
    });

    testWidgets('an empty deck is an empty bar, and a position past the end '
        'stops at full', (tester) async {
      await tester.pumpWidget(host(header(position: 1, total: 0)));
      expect(bar(tester).value, 0.0);

      await tester.pumpWidget(host(header(position: 12, total: 10)));
      expect(bar(tester).value, 1.0);
    });

    for (final (name, theme, track) in [
      ('light', AppTheme.light, AppColors.light),
      ('dark', AppTheme.dark, AppColors.dark),
    ]) {
      testWidgets('$name: the FILL is whatever the screen passes; the track '
          'and counter are shared', (tester) async {
        // The quiz passes quizProgressFill and flashcards its own token: the
        // one thing the two frames disagree on (225:5616 vs 308:5266).
        await tester.pumpWidget(
          host(header(fill: track.flashcardProgressFill), theme: theme),
        );

        expect(bar(tester).valueColor!.value, track.flashcardProgressFill);
        expect(bar(tester).backgroundColor, track.progressTrack);
        expect(
          tester.widget<Text>(find.text('3/10')).style!.color,
          track.quizProgressCounter,
        );
      });
    }

    testWidgets('the keys land on the container and the ✕ button', (
      tester,
    ) async {
      await tester.pumpWidget(host(header()));

      // A key on the widget itself would make `tester.widget<Container>` fail
      // in the quiz's tests, which read the container's decoration.
      final container = tester.widget<Container>(find.byKey(headerKey));
      final border = (container.decoration! as BoxDecoration).border! as Border;
      expect(
        border.bottom,
        const BorderSide(color: Color.fromRGBO(124, 58, 237, 0.1), width: 1.18),
      );
      expect(
        tester.getSize(find.byKey(headerKey)).height,
        moreOrLessEquals(89.18),
      );
      expect(tester.widget(find.byKey(closeKey)), isA<IconButton>());
      expect(tester.getSize(find.byKey(closeKey)), const Size(48, 48));
    });

    testWidgets('without keys it still builds', (tester) async {
      await tester.pumpWidget(
        host(
          StudySessionHeader(
            title: 'T',
            onClose: () {},
            position: 1,
            total: 2,
            progressFill: AppColors.light.flashcardProgressFill,
          ),
        ),
      );

      expect(find.text('T'), findsOneWidget);
    });

    testWidgets('tapping the ✕ calls onClose, and it is named Close', (
      tester,
    ) async {
      var closed = 0;
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(header(onClose: () => closed++)));

      expect(find.byTooltip('Close'), findsOneWidget);
      await tester.tap(find.byKey(closeKey));
      expect(closed, 1);
      handle.dispose();
    });

    testWidgets('Arabic mirrors the ✕: 16 from the right edge', (tester) async {
      await tester.pumpWidget(host(header(), locale: const Locale('ar')));

      final cross = find.descendant(
        of: find.byKey(closeKey),
        matching: find.byType(SvgPicture),
      );
      expect(
        tester.getRect(find.byKey(headerKey)).right -
            tester.getRect(cross).right,
        16,
      );
      expect(find.byTooltip('إغلاق'), findsOneWidget);
    });
  });

  group('StudyPreviousButton', () {
    final chevron = find.byWidgetPredicate(
      (w) =>
          w is SvgPicture &&
          w.bytesLoader is SvgAssetLoader &&
          (w.bytesLoader as SvgAssetLoader).assetName ==
              'assets/icons/chevron.svg',
    );

    testWidgets('is the 79 x 58 pill, and tapping it calls onPressed', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(Align(child: StudyPreviousButton(onPressed: () => taps++))),
      );

      expect(
        tester.getSize(
          find.ancestor(of: chevron, matching: find.byType(ElevatedSurface)),
        ),
        const Size(79, 58),
      );
      await tester.tap(chevron);
      expect(taps, 1);
    });

    // 225:5623, "weui:arrow-filled": a 27 x 54 box at (26, 4) in the 79 x 58
    // pill. The asset is a 15 x 30 viewBox, so that is 1.8x, and the glyph in it
    // is the 16.57 x 28.64 vector 225:5624. The pill used to size the ASSET to
    // 16.57 x 28.64, which drew the glyph at about half that.
    for (final locale in const [Locale('en'), Locale('ar')]) {
      testWidgets('${locale.languageCode}: the glyph is the frame\'s 27 x 54 '
          'arrow box, 4 under the top, centred', (tester) async {
        await tester.pumpWidget(
          host(
            Align(child: StudyPreviousButton(onPressed: () {})),
            locale: locale,
          ),
        );

        final pill = tester.getRect(
          find.ancestor(of: chevron, matching: find.byType(ElevatedSurface)),
        );
        final glyph = tester.getRect(chevron);
        expect(glyph.size, const Size(27, 54));
        expect(glyph.left - pill.left, 26);
        expect(pill.right - glyph.right, 26);
        expect(glyph.top - pill.top, 4);

        // 27 x 54 is the asset's own viewBox at 1.8x, and what it draws inside
        // is the frame's glyph: x 3.8575-13.0622, y 7.05-22.96 in the asset.
        expect(
          File('assets/icons/chevron.svg').readAsStringSync(),
          contains('viewBox="0 0 15 30"'),
        );
        final scale = glyph.width / 15;
        expect(glyph.height / 30, moreOrLessEquals(scale));
        expect(
          (13.0622 - 3.8575) * scale,
          moreOrLessEquals(16.57, epsilon: 0.01),
        );
        expect((22.96 - 7.05) * scale, moreOrLessEquals(28.64, epsilon: 0.01));
      });
    }

    testWidgets('announces itself as PREVIOUS, not as back', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(Align(child: StudyPreviousButton(onPressed: () {}))),
      );

      expect(find.bySemanticsLabel('Previous page'), findsOneWidget);
      expect(find.bySemanticsLabel('Back'), findsNothing);
      handle.dispose();
    });

    testWidgets('a null onPressed is dimmed, inert and disabled to TalkBack', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(const Align(child: StudyPreviousButton(onPressed: null))),
      );

      final opacity = tester.widget<Opacity>(
        find.ancestor(of: chevron, matching: find.byType(Opacity)).first,
      );
      expect(opacity.opacity, 0.45);
      expect(
        tester
            .widget<ElevatedSurface>(
              find.ancestor(
                of: chevron,
                matching: find.byType(ElevatedSurface),
              ),
            )
            .onTap,
        isNull,
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Previous page')),
        isSemantics(
          isButton: true,
          isEnabled: false,
          hasEnabledState: true,
          label: 'Previous page',
        ),
      );
      handle.dispose();
    });

    testWidgets('the chevron is mirrored in LTR and left alone in RTL', (
      tester,
    ) async {
      Future<double> xScale(Locale locale) async {
        await tester.pumpWidget(
          host(
            Align(child: StudyPreviousButton(onPressed: () {})),
            locale: locale,
          ),
        );
        return tester
            .widget<Transform>(
              find
                  .ancestor(of: chevron, matching: find.byType(Transform))
                  .first,
            )
            .transform
            .storage[0];
      }

      // The shared asset points RIGHT: "back" is its flip in LTR and its
      // unflipped self in RTL. Pinned by value, so an inverted mirror fails.
      expect(await xScale(const Locale('en')), -1.0);
      expect(await xScale(const Locale('ar')), 1.0);
    });
  });
}
