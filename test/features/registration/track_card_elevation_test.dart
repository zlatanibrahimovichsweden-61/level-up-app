import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/layer_blur.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The sign-up track cards' surfaces · edit5 items #32 and #54.
///
/// The two cards are the one place in the app where two surfaces differ ONLY
/// by their Glass light angle, so most of what is asserted here is the pair
/// rather than either card alone.
const _args = RegistrationArgs(
  registrationToken: 'reg.token',
  expiresInSeconds: 600,
  phone: '+201021871999',
);

const _black25 = Color.fromRGBO(0, 0, 0, 0.25);

void main() {
  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Brightness brightness = Brightness.light,
  }) async {
    final container = ProviderContainer(
      overrides: [
        // Otherwise the real connectivity EventChannel is subscribed and
        // throws MissingPluginException under the test binding.
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);
    container.read(registrationControllerProvider.notifier).start(_args);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          themeAnimationDuration: Duration.zero,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            initialLocation: '/register/track',
            routes: [
              GoRoute(
                path: '/register/track',
                builder: (_, _) => const SignupTrackScreen(),
              ),
              GoRoute(
                path: '/register/school',
                builder: (_, _) => const Scaffold(body: Text('SCHOOL')),
              ),
              GoRoute(
                path: '/register/university',
                builder: (_, _) => const Scaffold(body: Text('UNI')),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  /// The card whose label is [label]. Sections carry no keys, and the screen's
  /// only other `ElevatedSurface` is the back chip, which is not an ancestor
  /// of either label.
  ElevatedSurface cardFor(WidgetTester tester, String label) =>
      tester.widget<ElevatedSurface>(
        find
            .ancestor(
              of: find.text(label),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );

  // -----------------------------------------------------------------------
  group('#32 light: a drop shadow, a gradient outline, no Glass', () {
    testWidgets('the card is an ElevatedSurface at 112 / r25', (tester) async {
      await pump(tester);
      final card = cardFor(tester, 'School Student');

      expect(card.height, 112);
      expect(
        card.shape,
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      );
    });

    testWidgets('(0.5, 0.5) blur 4 black 25%, on BOTH cards', (tester) async {
      await pump(tester);

      for (final label in ['School Student', 'University Student']) {
        final shadows = cardFor(tester, label).shadows;
        expect(shadows, AppElevation.light.trackCardShadows, reason: label);
        expect(shadows.single.color, _black25, reason: label);
        expect(shadows.single.offset, const Offset(0.5, 0.5), reason: label);
        expect(shadows.single.blur, 4, reason: label);
        expect(shadows.single.inset, isFalse, reason: label);
      }
    });

    testWidgets('no Glass, and the fill stays on the inset surface', (
      tester,
    ) async {
      await pump(tester);
      final card = cardFor(tester, 'School Student');

      expect(card.glass, isNull, reason: 'Glass is a dark-canvas mechanism');
      expect(
        card.color,
        isNull,
        reason:
            'light draws a 1px gradient outline, so the fill belongs to the '
            'surface inset inside it or the gradient would be painted over',
      );
      // The gradient outline itself is unchanged and still present.
      expect(AppColors.light.trackCardBorderStart, const Color(0xFF384F47));
      expect(AppColors.light.trackCardBorderEnd, const Color(0xFF95CDBB));
    });
  });

  // -----------------------------------------------------------------------
  group('#32 dark: no shadow, a 20% fill, and Glass instead', () {
    testWidgets('the fill is #232428 at 20%, not the opaque page', (
      tester,
    ) async {
      await pump(tester, brightness: Brightness.dark);
      final card = cardFor(tester, 'School Student');

      expect(card.color, AppColors.dark.trackCardFill);
      expect(
        card.color!.a,
        closeTo(0.2, 0.005),
        reason: 'the build painted the opaque `background` here',
      );
      expect(
        card.color,
        isNot(AppColors.dark.background),
        reason: '`337:15981` is a wash, and the wash is what the rim reads on',
      );
    });

    testWidgets('no shadow at all — the dark frames draw none', (tester) async {
      await pump(tester, brightness: Brightness.dark);

      for (final label in ['School Student', 'University Student']) {
        expect(
          cardFor(tester, label).shadows,
          isEmpty,
          reason: '$label — a dark token with no shadow is a reading (R1)',
        );
      }
    });

    testWidgets('SCHOOL takes G20 and UNIVERSITY takes G5', (tester) async {
      // The mapping is the verify-first half of #32: `337:15947` and
      // `82:1785` both list School first, read 2026-09-20.
      await pump(tester, brightness: Brightness.dark);

      final school = cardFor(tester, 'School Student').glass;
      final university = cardFor(tester, 'University Student').glass;

      expect(school, AppElevation.dark.trackCardGlassFirst);
      expect(university, AppElevation.dark.trackCardGlassSecond);
      expect(school, isNot(university));
    });

    testWidgets('the two Glass tokens differ ONLY by light angle', (
      tester,
    ) async {
      await pump(tester, brightness: Brightness.dark);

      final a = cardFor(tester, 'School Student').glass!;
      final b = cardFor(tester, 'University Student').glass!;

      expect(a.lightAngle, 25);
      expect(b.lightAngle, -45);
      expect(a.frost, b.frost);
      expect(a.refraction, b.refraction);
      expect(a.depth, b.depth);
      expect(a.lightIntensity, b.lightIntensity);
      expect(a.dispersion, b.dispersion);
      expect(a.splay, b.splay);
    });

    testWidgets('School comes first on screen', (tester) async {
      await pump(tester);
      expect(
        tester.getTopLeft(find.text('School Student')).dy,
        lessThan(tester.getTopLeft(find.text('University Student')).dy),
      );
    });
  });

  // -----------------------------------------------------------------------
  group('#54 the illustration shadow', () {
    testWidgets('School has one; University does NOT', (tester) async {
      await pump(tester);

      // `Group 37219` inside `Component 2` holds the asset twice; the
      // University card's art (`Component 3`) is a plain vector group.
      expect(
        find.byType(LayerBlur),
        findsOneWidget,
        reason: 'exactly one card carries a blurred duplicate',
      );
      expect(
        find.descendant(
          of: find
              .ancestor(
                of: find.text('School Student'),
                matching: find.byType(ElevatedSurface),
              )
              .first,
          matching: find.byType(LayerBlur),
        ),
        findsOneWidget,
      );
    });

    testWidgets('53% at sigma 3.7 — layer blur 7.4 halved (R3)', (
      tester,
    ) async {
      await pump(tester);
      final blur = tester.widget<LayerBlur>(find.byType(LayerBlur));

      expect(blur.opacity, 0.53);
      expect(blur.sigma, 3.7, reason: 'the panel reads 7.4; sigma = B/2');
    });

    testWidgets('it is a BLACK SILHOUETTE, not a coloured duplicate', (
      tester,
    ) async {
      // Both copies wrap the same 75.66 x 84.91 `Group`; the back one's whole
      // group is one flat `#000000` at 25%. A coloured duplicate would put a
      // teal haze under the teal book — the frame puts grey under all of it.
      await pump(tester);
      final svg = tester.widget<SvgPicture>(
        find.descendant(
          of: find.byType(LayerBlur),
          matching: find.byType(SvgPicture),
        ),
      );

      expect(svg.colorFilter, isNotNull);
      expect(
        svg.colorFilter,
        ColorFilter.mode(AppColors.light.trackCardArtShadow, BlendMode.srcIn),
      );
      expect(
        AppColors.light.trackCardArtShadow,
        const Color.fromRGBO(0, 0, 0, 0.25),
      );
      expect(
        AppColors.dark.trackCardArtShadow,
        AppColors.light.trackCardArtShadow,
        reason: 'the frames draw the identical layer on both canvases',
      );

      // The sharp copy is untinted — the two illustrations are the only
      // assets in this pass rendered in full colour.
      final sharp = tester
          .widgetList<SvgPicture>(
            find.descendant(
              of: find
                  .ancestor(
                    of: find.text('School Student'),
                    matching: find.byType(ElevatedSurface),
                  )
                  .first,
              matching: find.byType(SvgPicture),
            ),
          )
          .where((w) => w.colorFilter == null);
      expect(sharp, hasLength(1));
    });

    testWidgets('it sits BEHIND the sharp copy, offset (1, 2)', (tester) async {
      await pump(tester);

      // `.first` on both: `find.ancestor` walks outward, and an SVG and a
      // Material route each contribute their own Stack and Transform.
      final stack = tester.widget<Stack>(
        find
            .ancestor(of: find.byType(LayerBlur), matching: find.byType(Stack))
            .first,
      );
      expect(
        stack.children.first,
        isA<Transform>(),
        reason: 'the blurred copy is child 0, so the sharp one paints over it',
      );

      final translate = tester.widget<Transform>(
        find
            .ancestor(
              of: find.byType(LayerBlur),
              matching: find.byType(Transform),
            )
            .first,
      );
      expect(translate.transform.getTranslation().x, 1);
      expect(translate.transform.getTranslation().y, 2);
    });

    testWidgets('the offset is PHYSICAL — it does not mirror in RTL', (
      tester,
    ) async {
      // edit1.md R9: a shadow's offset is physics, a back-light's is
      // direction. This is the illustration's own soft shadow.
      await pump(tester);
      final ltr = tester
          .widget<Transform>(
            find
                .ancestor(
                  of: find.byType(LayerBlur),
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform
          .getTranslation();

      expect(ltr.x, isPositive);
      expect(ltr.y, isPositive);
    });
  });

  // -----------------------------------------------------------------------
  group('behaviour survives the surface swap', () {
    testWidgets('tapping a card selects it, and Continue then routes', (
      tester,
    ) async {
      final container = await pump(tester);

      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'))
            .onPressed,
        isNull,
      );

      await tester.tap(find.text('University Student'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(
        container.read(registrationControllerProvider)!.track,
        RegTrack.university,
      );
      expect(find.text('UNI'), findsOneWidget);
    });

    testWidgets('the selected card keeps its invented 2px border and wash', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(find.text('School Student'));
      await tester.pumpAndSettle();

      final card = cardFor(tester, 'School Student');
      expect(
        card.color,
        isNull,
        reason: 'selected draws an outline too, so the fill stays inset',
      );

      // Figma draws no selected state; the 8% wash and 2px primary border are
      // the Day-2 invention, kept (DESIGN_ISSUES #40).
      final boxes = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byWidgetPredicate((w) => identical(w, card)),
              matching: find.byType(Container),
            ),
          )
          .toList();
      expect(boxes, isNotEmpty);
      expect(
        boxes.any((c) => c.padding == const EdgeInsets.all(2)),
        isTrue,
        reason: 'the 2px outline box',
      );
    });

    testWidgets('semantics still announce a selectable button', (tester) async {
      await pump(tester);
      final handle = tester.ensureSemantics();

      // `isSemantics`, not `matchesSemantics`: the latter asserts the FULL
      // flag and action set, so it fails on the focus action the card has
      // always had rather than on anything this edit changed.
      final school = tester
          .getSemantics(find.text('School Student'))
          .getSemanticsData();
      final university = tester
          .getSemantics(find.text('University Student'))
          .getSemanticsData();

      expect(school.label, contains('School Student'));
      expect(school.flagsCollection.isButton, isTrue);
      expect(school.hasAction(SemanticsAction.tap), isTrue);

      // **The glow must be semantically invisible.** `flutter_svg` marks
      // every `SvgPicture` as an image, and the blurred duplicate is a
      // second one inside the same merged button node. Without
      // `excludeFromSemantics` on it the School card's flag set came out
      // DIFFERENT from the University card's - which is how this was
      // caught, because the two cards are otherwise the same control.
      expect(
        school.flagsCollection,
        university.flagsCollection,
        reason: 'the decorative duplicate must not change the flag set',
      );
      handle.dispose();
    });
  });
}
