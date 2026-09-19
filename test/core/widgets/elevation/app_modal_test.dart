import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/app_modal.dart';

/// `showAppDialog` / `showAppModalSheet` are the two shared modal entry points
/// edits 4 and 5 will also route their framework dialogs through, so what is
/// pinned here is the BEHAVIOUR CONTRACT (edit2.md §7.5.1), not the paint:
/// no scrim means the framework's own route untouched, a scrim means that
/// barrier colour, a sigma means a real backdrop blur, and dismissal keeps
/// working in every direction it worked before.
void main() {
  const noBlur = ScrimStyle(color: Color.fromRGBO(49, 49, 49, 0.3));
  const blurred = ScrimStyle(color: Color.fromRGBO(49, 49, 49, 0.6), sigma: 10);

  Widget host(void Function(BuildContext) onPressed) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () => onPressed(context),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );

  /// The barrier's colour, read off the live `ModalBarrier` rather than off the
  /// route: a `ModalRoute.barrierColor` that never reaches the widget would
  /// pass a route-level assertion and still render nothing.
  Color? barrierColour(WidgetTester tester) {
    final barrier = tester.widgetList<ModalBarrier>(find.byType(ModalBarrier));
    return barrier.map((b) => b.color).whereType<Color>().firstOrNull;
  }

  /// Every sigma a `BackdropFilter` in the tree is blurring by. Empty when the
  /// route carries no filter at all.
  List<double> blurSigmas(WidgetTester tester) => [
    for (final f in tester.widgetList<BackdropFilter>(
      find.byType(BackdropFilter),
    ))
      if (f.filter case final ImageFilter filter)
        // `ImageFilter.blur`'s sigmas are not exposed; toString is the only
        // readable form, and it is stable: "ImageFilter.blur(10.0, 10.0, clamp)".
        double.parse(
          RegExp(r'blur\(([0-9.]+)').firstMatch(filter.toString())!.group(1)!,
        ),
  ];

  group('showAppDialog', () {
    testWidgets('no scrim leaves the framework barrier alone', (tester) async {
      await tester.pumpWidget(
        host(
          (c) => showAppDialog<void>(
            context: c,
            builder: (_) => const Dialog(child: Text('body')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('body'), findsOneWidget);
      // The framework's own default, i.e. NOT one of this app's scrims.
      expect(barrierColour(tester), isNot(noBlur.color));
      expect(blurSigmas(tester), isEmpty);
    });

    testWidgets('a scrim supplies the barrier colour', (tester) async {
      await tester.pumpWidget(
        host(
          (c) => showAppDialog<void>(
            context: c,
            scrim: noBlur,
            builder: (_) => const Dialog(child: Text('body')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(barrierColour(tester), noBlur.color);
    });

    testWidgets('a BackdropFilter exists only when sigma > 0', (tester) async {
      await tester.pumpWidget(
        host(
          (c) => showAppDialog<void>(
            context: c,
            scrim: noBlur,
            builder: (_) => const Dialog(child: Text('body')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(blurSigmas(tester), isEmpty);
    });

    testWidgets('sigma > 0 blurs the page at exactly that sigma', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          (c) => showAppDialog<void>(
            context: c,
            scrim: blurred,
            builder: (_) => const Dialog(child: Text('body')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(blurSigmas(tester), contains(blurred.sigma));
      expect(barrierColour(tester), blurred.color);
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('the barrier keeps its dismiss semantics label', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          (c) => showAppDialog<void>(
            context: c,
            scrim: blurred,
            builder: (_) => const Dialog(child: Text('body')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final label =
          const DefaultMaterialLocalizations().modalBarrierDismissLabel;
      expect(
        tester
            .widgetList<ModalBarrier>(find.byType(ModalBarrier))
            .map((b) => b.semanticsLabel),
        contains(label),
      );
    });

    testWidgets('a barrier tap still dismisses, blurred', (tester) async {
      await tester.pumpWidget(
        host(
          (c) => showAppDialog<void>(
            context: c,
            scrim: blurred,
            builder: (_) => const Dialog(child: Text('body')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('body'), findsNothing);
    });

    testWidgets('barrierDismissible false keeps it open', (tester) async {
      await tester.pumpWidget(
        host(
          (c) => showAppDialog<void>(
            context: c,
            scrim: blurred,
            barrierDismissible: false,
            builder: (_) => const Dialog(child: Text('body')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('system back still pops it, and returns its value', (
      tester,
    ) async {
      Object? result = 'untouched';
      await tester.pumpWidget(
        host((c) async {
          result = await showAppDialog<String>(
            context: c,
            scrim: blurred,
            builder: (_) => const Dialog(child: Text('body')),
          );
        }),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('body'), findsNothing);
      expect(result, isNull);
    });
  });

  group('showAppModalSheet', () {
    Widget sheetHost(ScrimStyle? scrim, {bool showDragHandle = false}) => host(
      (c) => showAppModalSheet<void>(
        context: c,
        scrim: scrim,
        showDragHandle: showDragHandle,
        builder: (_) => const SizedBox(height: 200, child: Text('sheet')),
      ),
    );

    testWidgets('no scrim leaves the framework sheet alone', (tester) async {
      await tester.pumpWidget(sheetHost(null));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('sheet'), findsOneWidget);
      expect(blurSigmas(tester), isEmpty);
    });

    testWidgets('a scrim supplies the barrier colour, unblurred', (
      tester,
    ) async {
      await tester.pumpWidget(sheetHost(noBlur));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(barrierColour(tester), noBlur.color);
      expect(blurSigmas(tester), isEmpty);
    });

    testWidgets('sigma > 0 blurs the page at exactly that sigma', (
      tester,
    ) async {
      await tester.pumpWidget(sheetHost(blurred));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(blurSigmas(tester), contains(blurred.sigma));
      expect(barrierColour(tester), blurred.color);
    });

    testWidgets('showDragHandle still inserts the handle, blurred', (
      tester,
    ) async {
      // The handle is a private widget, so it is measured by what it does:
      // `BottomSheet` reserves one interactive dimension above the builder's
      // child for it, so the sheet grows by exactly that much.
      await tester.pumpWidget(sheetHost(blurred));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final without = tester.getSize(find.byType(BottomSheet)).height;

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      await tester.pumpWidget(sheetHost(blurred, showDragHandle: true));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final with_ = tester.getSize(find.byType(BottomSheet)).height;

      expect(with_ - without, kMinInteractiveDimension);
    });

    testWidgets('drag-to-dismiss still works, blurred', (tester) async {
      await tester.pumpWidget(sheetHost(blurred));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.drag(find.text('sheet'), const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(find.text('sheet'), findsNothing);
    });

    testWidgets('a barrier tap still dismisses, blurred', (tester) async {
      await tester.pumpWidget(sheetHost(blurred));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('sheet'), findsNothing);
    });
  });

  group('the tokens these helpers are fed', () {
    test('the dark limit sheet is BLOCKED, not unscrimmed', () {
      // Null here means "no dark Limitation frame exists to measure", which is
      // why `LimitSheet` falls back to the framework barrier on that canvas.
      // If a dark frame ever arrives this expectation is what fails first.
      expect(AppElevation.dark.limitSheetScrim, isNull);
      expect(AppElevation.light.limitSheetScrim!.sigma, 5.75);
    });

    test('light scrims never blur; dark ones always do', () {
      for (final scrim in [
        AppElevation.light.avatarActionSheetScrim,
        AppElevation.light.chooseAvatarSheetScrim,
        AppElevation.light.logoutDialogScrim,
        AppElevation.light.goToUniversityDialogScrim,
      ]) {
        expect(scrim!.sigma, 0);
      }
      for (final scrim in [
        AppElevation.dark.avatarActionSheetScrim,
        AppElevation.dark.chooseAvatarSheetScrim,
        AppElevation.dark.logoutDialogScrim,
        AppElevation.dark.goToUniversityDialogScrim,
      ]) {
        expect(scrim!.sigma, greaterThan(0));
      }
    });
  });
}
