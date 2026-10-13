import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

import '../../goldens/golden_harness.dart' show loadAppFonts;

/// docs/RESPONSIVE.md #8: the six code boxes are 6 x 48 + 5 x 8 = 328 dp wide
/// and the card has that much room only from a 396 dp screen up, so on a
/// 360 dp phone (the commonest Android size in Egypt) the sixth box was drawn
/// off the right edge. The row now scales down to the card, and at 396 dp and
/// up it is the row it always was.
///
/// Real fonts (a placeholder face is half as wide again), real theme,
/// both languages. The geometry is asserted from the rendered cells, not from
/// the code, so a regression names the width it broke at.
class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

const _args = OtpArgs(
  phone: '+2010000000001',
  resendAfterSeconds: 0,
  expiresInSeconds: 300,
);
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');

/// The least width of the six-box row: 6 x 48 + 5 x 8.
const _rowWidth = 328.0;

/// The card's own horizontal padding, per side (`_InputView._cardPadding`).
const _cardPad = 10.0;

/// The screen's gutter, per side.
const _gutter = 24.0;

void main() {
  setUpAll(() async {
    registerFallbackValue(_device);
    await loadAppFonts();
  });

  Future<void> pumpOtp(
    WidgetTester tester, {
    required double width,
    String locale = 'en',
    double textScale = 1.0,
    bool dark = false,
    double height = 800,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    if (textScale != 1.0) {
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }
    final storage = _MockSecureStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: Locale(locale),
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OtpScreen(args: _args),
        ),
      ),
    );
    await tester.pump();
  }

  // The six cells: the surfaces inside the Pinput, in paint order.
  Finder cells() => find.descendant(
    of: find.byType(Pinput),
    matching: find.byType(ElevatedSurface),
  );

  // The code card: the nearest surface around the Pinput.
  Rect card(WidgetTester tester) => tester.getRect(
    find
        .ancestor(
          of: find.byType(Pinput),
          matching: find.byType(ElevatedSurface),
        )
        .first,
  );

  List<Rect> cellRects(WidgetTester tester) => [
    for (var i = 0; i < cells().evaluate().length; i++)
      tester.getRect(cells().at(i)),
  ];

  String cellText(WidgetTester tester, int i) => tester
      .widget<Text>(
        find.descendant(of: cells().at(i), matching: find.byType(Text)),
      )
      .data!;

  const widths = <double>[
    320,
    340,
    360,
    375,
    390,
    395,
    396,
    411,
    412,
    430,
    600,
  ];

  for (final width in widths) {
    for (final locale in ['en', 'ar']) {
      testWidgets('the code row fills its card and fits the screen at '
          '${width}dp ($locale)', (tester) async {
        await pumpOtp(tester, width: width, locale: locale);

        // A RenderFlex overflow is REPORTED, not thrown: it must be looked for.
        expect(tester.takeException(), isNull, reason: 'layout overflow');

        final rects = cellRects(tester);
        expect(rects, hasLength(6));
        final c = card(tester);
        final inner = Rect.fromLTRB(
          c.left + _cardPad,
          c.top,
          c.right - _cardPad,
          c.bottom,
        );
        expect(c.left, _gutter);
        expect(c.right, width - _gutter);

        // The row spans the card's inner width, edge to edge - never wider
        // (spilling) and never narrower (a row that shrank for no reason).
        expect(rects.first.left, moreOrLessEquals(inner.left, epsilon: 0.01));
        expect(rects.last.right, moreOrLessEquals(inner.right, epsilon: 0.01));
        expect(rects.last.right, lessThanOrEqualTo(width));
        for (final r in rects) {
          expect(r.left, greaterThanOrEqualTo(inner.left - 0.01));
          expect(r.right, lessThanOrEqualTo(inner.right + 0.01));
        }

        // Left to right, in order, apart from each other.
        for (var i = 1; i < rects.length; i++) {
          expect(
            rects[i].left,
            greaterThanOrEqualTo(rects[i - 1].right),
            reason: 'cell ${i + 1} overlaps cell $i',
          );
        }

        // 48 x 56 where there is room; scaled together (the same shape)
        // where there is not.
        final scale = (inner.width / _rowWidth).clamp(0.0, 1.0);
        for (final r in rects) {
          expect(r.width, moreOrLessEquals(48 * scale, epsilon: 0.01));
          expect(r.height, moreOrLessEquals(56 * scale, epsilon: 0.01));
        }
      });
    }
  }

  for (final width in [412.0, 402.0, 396.0]) {
    testWidgets('at ${width}dp the row is exactly the frame\'s: 48 x 56 cells '
        'spread edge to edge', (tester) async {
      await pumpOtp(tester, width: width);
      final rects = cellRects(tester);
      final inner = width - 2 * (_gutter + _cardPad);
      final gap = (inner - 6 * 48) / 5;
      expect(rects.first.left, _gutter + _cardPad);
      for (var i = 0; i < 6; i++) {
        expect(rects[i].width, moreOrLessEquals(48, epsilon: 0.001));
        expect(rects[i].height, moreOrLessEquals(56, epsilon: 0.001));
        expect(
          rects[i].left,
          moreOrLessEquals(_gutter + _cardPad + i * (48 + gap), epsilon: 0.01),
        );
      }
      expect(rects.last.right, width - _gutter - _cardPad);
    });
  }

  for (final locale in ['en', 'ar']) {
    for (final width in [320.0, 360.0, 412.0]) {
      testWidgets('digits fill left to right whatever the language: $locale at '
          '${width}dp', (tester) async {
        await pumpOtp(tester, width: width, locale: locale);
        // Five digits: the sixth completes the code and submits it.
        await tester.enterText(find.byType(Pinput), '12345');
        await tester.pump();
        expect(tester.takeException(), isNull);

        final rects = cellRects(tester);
        for (var i = 1; i < rects.length; i++) {
          expect(rects[i].left, greaterThan(rects[i - 1].left));
        }
        expect(
          [for (var i = 0; i < 6; i++) cellText(tester, i)],
          ['1', '2', '3', '4', '5', ''],
        );
      });
    }
  }

  testWidgets('a tap on a scaled box still reaches the field (320dp)', (
    tester,
  ) async {
    await pumpOtp(tester, width: 320);
    final field = find.descendant(
      of: find.byType(Pinput),
      matching: find.byType(EditableText),
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(tester.widget<EditableText>(field).focusNode.hasFocus, isFalse);

    await tester.tap(cells().last);
    await tester.pump();
    expect(tester.widget<EditableText>(field).focusNode.hasFocus, isTrue);
  });

  for (final width in [320.0, 360.0]) {
    testWidgets('no overflow at ${width}dp at the largest text, dark', (
      tester,
    ) async {
      await pumpOtp(
        tester,
        width: width,
        textScale: 2.0,
        dark: true,
        height: 700,
      );
      expect(tester.takeException(), isNull);
      final rects = cellRects(tester);
      expect(rects.last.right, lessThanOrEqualTo(width - _gutter));
    });
  }
}
