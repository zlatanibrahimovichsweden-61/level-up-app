import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/titled_chrome.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_scaffold.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart';

/// O-15: the back chip's 48 dp target, and titled bars that grow with the
/// text instead of clipping it.
///
/// Every expectation about a TARGET here failed before O-15: the chip was a
/// 35 box in a 35 bar, so a tap 6 dp outside its drawn edge went nowhere and
/// Android's tap-target check flagged it. Every expectation about the DRAWN
/// chip, the title and the body pins the frame's own numbers, which O-15 must
/// not move (they were also checked pixel for pixel against the pre-O-15
/// build; DESIGN_ISSUES #132).
///
/// The bundled fonts are loaded, because "every title fits on one line at
/// 1.0×" is a claim about Inter and Tajawal, not about the test face.
void main() {
  setUpAll(loadAppFonts);

  const back = DefaultMaterialLocalizations();

  void phone(WidgetTester tester, {double width = 411}) {
    tester.view.physicalSize = Size(width, 914) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Widget app(Widget home, {String locale = 'en', double textScale = 1}) {
    return MaterialApp(
      locale: Locale(locale),
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: home,
    );
  }

  Finder drawnChip([Finder? within]) => find.descendant(
    of: within ?? find.byType(CircleBackButton),
    matching: find.byType(ElevatedSurface),
  );

  // -------------------------------------------------------------------------
  group('CircleBackButton', () {
    testWidgets('shrink-wrapped (the default) is still the 35 box', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(Center(child: CircleBackButton(onPressed: () {}))),
      );
      expect(tester.getSize(find.byType(CircleBackButton)), const Size(35, 35));
      expect(tester.getSize(drawnChip()), const Size(35, 35));
    });

    testWidgets('padded is a 48 box around the same 35 chip, centred', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          Center(
            child: CircleBackButton(
              tapTargetSize: MaterialTapTargetSize.padded,
              chipKey: const Key('chip'),
              onPressed: () {},
            ),
          ),
        ),
      );
      final box = tester.getRect(find.byType(CircleBackButton));
      final chip = tester.getRect(find.byKey(const Key('chip')));
      expect(box.size, const Size(48, 48));
      expect(chip.size, const Size(35, 35));
      expect(chip.center, box.center);
      expect(chip, tester.getRect(drawnChip()), reason: 'chipKey = drawn');
    });

    for (final direction in TextDirection.values) {
      testWidgets('${direction.name}: an edge-aligned chip sits flush to '
          'that edge', (tester) async {
        Future<Rect> chipFor(AlignmentDirectional alignment) async {
          await tester.pumpWidget(
            app(
              Directionality(
                textDirection: direction,
                child: Center(
                  child: CircleBackButton(
                    tapTargetSize: MaterialTapTargetSize.padded,
                    chipAlignment: alignment,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          );
          return tester.getRect(drawnChip());
        }

        final start = await chipFor(AlignmentDirectional.centerStart);
        final end = await chipFor(AlignmentDirectional.centerEnd);
        final box = tester.getRect(find.byType(CircleBackButton));
        final ltr = direction == TextDirection.ltr;
        expect(ltr ? start.left : start.right, ltr ? box.left : box.right);
        expect(ltr ? end.right : end.left, ltr ? box.right : box.left);
        expect(start.center.dy, box.center.dy);
      });
    }

    testWidgets('padded: a tap anywhere in the 48 box goes back, once', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        app(
          Center(
            child: CircleBackButton(
              tapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () => taps++,
            ),
          ),
        ),
      );
      final box = tester.getRect(find.byType(CircleBackButton));

      // On the chip: its own ink handles it, the outer detector does not
      // fire a second time.
      await tester.tapAt(box.center);
      expect(taps, 1);
      // Outside the drawn 35 but inside the 48: every side and a corner.
      for (final offset in const [
        Offset(22, 0),
        Offset(-22, 0),
        Offset(0, 22),
        Offset(0, -22),
        Offset(22, 22),
      ]) {
        await tester.tapAt(box.center + offset);
      }
      expect(taps, 6);
      // Outside the box: nothing.
      await tester.tapAt(box.center + const Offset(26, 0));
      expect(taps, 6);
    });

    testWidgets('padded: ONE button node, the size of the box, not an image', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        app(
          Center(
            child: CircleBackButton(
              tapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () {},
            ),
          ),
        ),
      );
      final node = tester.getSemantics(find.byType(CircleBackButton));
      expect(
        node,
        isSemantics(
          isButton: true,
          isImage: false,
          hasTapAction: true,
          label: back.backButtonTooltip,
        ),
      );
      expect(node.rect.size, const Size(48, 48));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      semantics.dispose();
    });
  });

  // -------------------------------------------------------------------------
  group('TitledChrome', () {
    Widget bar(String title, {VoidCallback? onBack}) => Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: title,
          backKey: const Key('back'),
          onBack: onBack,
          child: const SizedBox.expand(key: Key('body')),
        ),
      ),
    );

    for (final locale in ['en', 'ar']) {
      testWidgets('$locale · 1.0×: the frame\'s chip, title and body, '
          'unmoved', (tester) async {
        phone(tester);
        await tester.pumpWidget(app(bar('Settings'), locale: locale));

        final chip = tester.getRect(find.byKey(const Key('back')));
        expect(chip.size, const Size(35, 35));
        expect(chip.top, 16);
        if (locale == 'en') {
          expect(chip.left, 20);
        } else {
          expect(chip.right, 411 - 20);
        }
        final title = tester.getRect(find.text('Settings'));
        expect(title.center.dx, moreOrLessEquals(411 / 2, epsilon: 0.5));
        expect(title.center.dy, moreOrLessEquals(16 + 35 / 2, epsilon: 0.01));
        expect(tester.getRect(find.byKey(const Key('body'))).top, 16 + 35 + 8);
      });

      testWidgets('$locale · the back target is 48 and a tap at its corner '
          'goes back', (tester) async {
        phone(tester);
        var backs = 0;
        final semantics = tester.ensureSemantics();
        await tester.pumpWidget(
          app(bar('Settings', onBack: () => backs++), locale: locale),
        );

        final target = tester.getRect(find.byType(CircleBackButton));
        expect(target.size, const Size(48, 48));
        final chip = tester.getRect(find.byKey(const Key('back')));
        expect(target.center, chip.center);
        // 4 dp in from the target's outer corner: 6.5 outside the chip's
        // top edge — where the old 35 bar refused every tap.
        await tester.tapAt(target.topLeft + const Offset(4, 4));
        await tester.tapAt(target.bottomRight - const Offset(4, 4));
        expect(backs, 2);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        semantics.dispose();
      });
    }

    final en = lookupAppLocalizations(const Locale('en'));
    final ar = lookupAppLocalizations(const Locale('ar'));
    final titles = <String, List<String>>{
      for (final entry in {'en': en, 'ar': ar}.entries)
        entry.key: [
          entry.value.profileCustomerSupport,
          entry.value.friendsTitle,
          entry.value.profileReferAFriend,
          entry.value.flashcardSetupTitle,
          entry.value.notifications,
          entry.value.quizSetupTitle,
          entry.value.profileSettings,
          entry.value.supportNewTicketTitle,
          entry.value.editProfile,
          entry.value.profilePrivacyPolicy,
          entry.value.profileTermsConditions,
        ],
    };

    RenderParagraph paragraphOf(WidgetTester tester, String text) =>
        tester.renderObject<RenderParagraph>(find.text(text));

    /// [text] laid out the way the bar lays it out.
    TextPainter laidOut(WidgetTester tester, String text) {
      final paragraph = paragraphOf(tester, text);
      final painter = TextPainter(
        text: paragraph.text,
        textDirection: paragraph.textDirection,
        textAlign: paragraph.textAlign,
        textScaler: paragraph.textScaler,
        locale: paragraph.locale,
      )..layout(maxWidth: paragraph.constraints.maxWidth);
      addTearDown(painter.dispose);
      return painter;
    }

    double neededHeight(WidgetTester tester, String text) =>
        laidOut(tester, text).height;

    for (final locale in ['en', 'ar']) {
      // From 360 dp, the narrowest common Android width. At 320 the Arabic
      // "Edit Profile" (199.9 dp in Tajawal) is wider than the 197 dp between
      // the two 48 reservations and takes two lines (DESIGN_ISSUES #132).
      testWidgets('$locale · 1.0×: every titled bar\'s title fits one line '
          'from 360 dp up', (tester) async {
        phone(tester, width: 360);
        for (final title in titles[locale]!) {
          await tester.pumpWidget(app(bar(title), locale: locale));
          // Counted, not measured: a line set in the Arabic fallback face
          // can be a pixel taller than Inter's 26.
          expect(
            laidOut(tester, title).computeLineMetrics(),
            hasLength(1),
            reason: '"$title" is one line',
          );
        }
      });

      for (final width in [360.0, 411.0]) {
        testWidgets('$locale · ${width.toInt()} dp · 2.0×: no title is '
            'clipped, cut or under the chip', (tester) async {
          phone(tester, width: width);
          for (final title in titles[locale]!) {
            await tester.pumpWidget(
              app(bar(title), locale: locale, textScale: 2),
            );
            expect(tester.takeException(), isNull, reason: title);

            final paragraph = paragraphOf(tester, title);
            expect(paragraph.didExceedMaxLines, isFalse, reason: title);
            // Its whole scaled text, not a 35 slice of it.
            expect(
              paragraph.size.height,
              moreOrLessEquals(neededHeight(tester, title), epsilon: 0.01),
              reason: '"$title" keeps every line',
            );
            expect(paragraph.size.height, greaterThanOrEqualTo(52));

            final text = tester.getRect(find.text(title));
            final strip = tester.getRect(
              find.descendant(
                of: find.byType(TitledChrome),
                matching: find.byType(Stack),
              ),
            );
            final target = tester.getRect(find.byType(CircleBackButton));
            final body = tester.getRect(find.byKey(const Key('body')));
            expect(text.top, greaterThanOrEqualTo(strip.top), reason: title);
            expect(text.bottom, lessThanOrEqualTo(strip.bottom), reason: title);
            expect(body.top, greaterThan(text.bottom), reason: title);
            expect(
              text.left >= target.right || text.right <= target.left,
              isTrue,
              reason: '"$title" clear of the back target',
            );
            // The chip is still 35 and still on the bar.
            expect(
              tester.getSize(find.byKey(const Key('back'))),
              const Size(35, 35),
            );
          }
        });
      }
    }
  });

  // -------------------------------------------------------------------------
  group('EditProfileChrome', () {
    testWidgets('is the titled bar, its key on the drawn chip', (tester) async {
      phone(tester);
      await tester.pumpWidget(
        app(
          const Scaffold(
            body: SafeArea(child: EditProfileChrome(child: SizedBox.expand())),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(EditProfileChrome),
          matching: find.byType(TitledChrome),
        ),
        findsOneWidget,
      );
      final chip = tester.getRect(find.byKey(const Key('edit_profile_back')));
      expect(chip, const Rect.fromLTWH(20, 16, 35, 35));
      expect(tester.getSize(find.byType(CircleBackButton)), const Size(48, 48));
    });
  });

  // -------------------------------------------------------------------------
  group('CatalogScaffold', () {
    for (final locale in ['en', 'ar']) {
      testWidgets('$locale · the frame\'s header, unmoved, with a 48 back '
          'target', (tester) async {
        phone(tester);
        // A real GoRouter: the header's chip leaves with `context.pop()`.
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(body: Text('root')),
            ),
            GoRoute(
              path: '/units',
              builder: (_, _) => const CatalogScaffold(
                title: 'Units',
                action: SizedBox(key: Key('action'), width: 90, height: 35),
                child: SizedBox.expand(key: Key('body')),
              ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          MaterialApp.router(
            locale: Locale(locale),
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );
        router.push('/units');
        await tester.pumpAndSettle();

        final ltr = locale == 'en';
        final chip = tester.getRect(drawnChip());
        expect(chip.size, const Size(35, 35));
        expect(chip.top, 20);
        expect(ltr ? chip.left : chip.right, ltr ? 20 : 411 - 20);
        final action = tester.getRect(find.byKey(const Key('action')));
        expect(action.top, 20);
        expect(ltr ? action.right : action.left, ltr ? 411 - 20 : 20);
        final title = tester.getRect(find.text('Units'));
        expect(title.center.dy, moreOrLessEquals(20 + 35 / 2, epsilon: 0.01));
        expect(tester.getRect(find.byKey(const Key('body'))).top, 20 + 35 + 16);

        // D-013's measurement, now for the chip: 22 dp below its centre is
        // inside its 48 target. The 35 header used to refuse it.
        final target = tester.getRect(find.byType(CircleBackButton));
        expect(target.size, const Size(48, 48));
        await tester.tapAt(chip.center + const Offset(0, 22));
        await tester.pumpAndSettle();
        expect(find.byType(CatalogScaffold), findsNothing);
      });
    }
  });
}
