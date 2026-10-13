import 'dart:async';
import 'dart:io';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/notifications/models/notification_models.dart';
import 'package:level_up_app/features/notifications/repository/notifications_repository.dart';
import 'package:level_up_app/features/notifications/screens/notifications_screen.dart';
import 'package:level_up_app/features/notifications/widgets/notification_filter_chips.dart';
import 'package:level_up_app/features/notifications/widgets/notification_row.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_fixtures.dart';

class _MockRepo extends Mock implements NotificationsRepository {}

/// The four chips, in the frame's order.
const _chipKeys = [
  'notification_chip_all',
  'notification_chip_announcements',
  'notification_chip_support',
  'notification_chip_system',
];

/// One chip's drawn pill: the 40, inside the chip's 48 box.
Rect _pillOf(WidgetTester tester, String key) => tester.getRect(
  find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(ElevatedSurface),
  ),
);

/// The Notifications inbox screen · Figma `180:8386`.
///
/// States (loading, empty, error, offline, pending deletion, append failure) in
/// English and Arabic, RTL layout, both canvases, the chips, the tap that marks
/// a row read, and what each kind shows.
///
/// The widget tests run on the test font, whose glyph widths are far from
/// Inter's: they assert STRUCTURE, text, direction and sizes that do not depend
/// on glyph width, never pixel widths of text.
void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    when(() => repo.markNotificationRead(any())).thenAnswer((_) async {});
  });

  /// Stubs ONE `(cursor, category)` pair of `listMyNotifications`.
  When<Future<CursorPage<NotificationItem>>> listCall({
    String? cursor,
    NotificationCategory? category,
  }) => when(
    () => repo.listMyNotifications(
      cursor: cursor,
      limit: any(named: 'limit'),
      category: category,
    ),
  );

  VerificationResult verifyList({
    String? cursor,
    NotificationCategory? category,
  }) => verify(
    () => repo.listMyNotifications(
      cursor: cursor,
      limit: any(named: 'limit'),
      category: category,
    ),
  );

  Future<void> pumpInbox(
    WidgetTester tester, {
    String language = 'en',
    Brightness brightness = Brightness.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) async {
    await tester.binding.setSurfaceSize(const Size(402, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [notificationsRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          locale: Locale(language),
          theme: brightness == Brightness.light
              ? AppTheme.light
              : AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          ),
          home: const NotificationsScreen(),
        ),
      ),
    );
    // One frame for the build future, a second because a REJECTED future
    // reaches the widget a microtask later than a resolved one.
    await tester.pump();
    await tester.pump();
  }

  Future<AppLocalizations> l10nFor(String language) =>
      AppLocalizations.delegate.load(Locale(language));

  Finder rowFor(String id) => find.byKey(ValueKey(id));

  /// Taps a chip the way a student does: the row scrolls sideways, and on the
  /// test font (far wider than Inter) the later chips start off screen.
  Future<void> tapChip(WidgetTester tester, String key) async {
    final chip = find.byKey(Key(key));
    await tester.ensureVisible(chip);
    await tester.pump();
    await tester.tap(chip);
    await tester.pump();
    await tester.pump();
  }

  const languages = ['en', 'ar'];

  // -------------------------------------------------------------------------
  group('the four states', () {
    for (final language in languages) {
      group(language, () {
        testWidgets('loading: a spinner under the chips', (tester) async {
          final pending = Completer<CursorPage<NotificationItem>>();
          listCall().thenAnswer((_) => pending.future);

          await pumpInbox(tester, language: language);

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          // The chips are part of the screen, not of one state.
          expect(
            find.byKey(const Key('notification_chip_all')),
            findsOneWidget,
          );
          expect(find.byType(NotificationRow), findsNothing);

          pending.complete(inboxPage([]));
          await tester.pump();
        });

        testWidgets('empty: nothingHere, no Retry', (tester) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer((_) async => inboxPage([]));

          await pumpInbox(tester, language: language);

          expect(find.text(l10n.nothingHere), findsOneWidget);
          expect(find.byKey(const Key('notifications_retry')), findsNothing);
          expect(find.byType(NotificationRow), findsNothing);
        });

        testWidgets('a page of only ignored items with no more is empty', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer((_) async => inboxPage([ignoredItem('i1')]));

          await pumpInbox(tester, language: language);

          expect(find.text(l10n.nothingHere), findsOneWidget);
        });

        testWidgets('error: genericError and a Retry that re-asks', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => throw const ApiException(
              status: 500,
              code: 'internal_server_error',
            ),
          );

          await pumpInbox(tester, language: language);

          expect(find.text(l10n.genericError), findsOneWidget);
          expect(find.text(l10n.retry), findsOneWidget);

          listCall().thenAnswer(
            (_) async => inboxPage([announcementItem('1')]),
          );
          await tester.tap(find.byKey(const Key('notifications_retry')));
          await tester.pump();
          await tester.pump();

          expect(find.byType(NotificationRow), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          verifyList().called(2);
        });

        testWidgets('offline: its own copy and a Retry', (tester) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer((_) async => throw const OfflineException());

          await pumpInbox(tester, language: language);

          expect(find.text(l10n.offline), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(find.byKey(const Key('notifications_retry')), findsOneWidget);

          listCall().thenAnswer(
            (_) async => inboxPage([announcementItem('1')]),
          );
          await tester.tap(find.byKey(const Key('notifications_retry')));
          await tester.pump();
          await tester.pump();

          expect(find.byType(NotificationRow), findsOneWidget);
        });

        testWidgets(
          'pending deletion: its own copy, NO Retry, nothing re-asked',
          (tester) async {
            final l10n = await l10nFor(language);
            listCall().thenAnswer(
              (_) async => throw const ApiException(
                status: 403,
                code: 'account_pending_deletion',
              ),
            );

            await pumpInbox(tester, language: language);

            expect(find.text(l10n.accountPendingDeletion), findsOneWidget);
            expect(find.text(l10n.genericError), findsNothing);
            expect(find.byKey(const Key('notifications_retry')), findsNothing);
            expect(find.text(l10n.retry), findsNothing);
            // The contract: do not retry, do not log out, do not navigate.
            expect(find.byType(NotificationsScreen), findsOneWidget);
            verifyList().called(1);
          },
        );

        testWidgets('a rate-limited inbox offers no Retry either', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => throw const RateLimitedException(),
          );

          await pumpInbox(tester, language: language);

          expect(find.text(l10n.genericError), findsOneWidget);
          expect(find.byKey(const Key('notifications_retry')), findsNothing);
        });
      });
    }
  });

  // -------------------------------------------------------------------------
  group('paging', () {
    for (final language in languages) {
      testWidgets('Load more appends the next page · $language', (
        tester,
      ) async {
        final l10n = await l10nFor(language);
        listCall().thenAnswer(
          (_) async => inboxPage(
            [announcementItem('1')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        listCall(
          cursor: 'c2',
        ).thenAnswer((_) async => inboxPage([announcementItem('2')]));

        await pumpInbox(tester, language: language);
        expect(find.byType(NotificationRow), findsOneWidget);
        expect(find.text(l10n.loadMore), findsOneWidget);

        await tester.tap(find.byKey(const Key('notifications_load_more')));
        await tester.pump();
        await tester.pump();

        expect(find.byType(NotificationRow), findsNWidgets(2));
        // Finished: the button is gone, and nothing else takes its place.
        expect(find.text(l10n.loadMore), findsNothing);
      });

      testWidgets(
        'a failed append keeps the rows and offers its own Retry · $language',
        (tester) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => inboxPage(
              [announcementItem('1')],
              hasMore: true,
              nextCursor: 'c2',
            ),
          );
          listCall(cursor: 'c2').thenAnswer(
            (_) async => throw const ApiException(
              status: 500,
              code: 'internal_server_error',
            ),
          );

          await pumpInbox(tester, language: language);
          await tester.tap(find.byKey(const Key('notifications_load_more')));
          await tester.pump();
          await tester.pump();

          // The page already on screen survives; the whole inbox is NOT an
          // error.
          expect(find.byType(NotificationRow), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(
            find.byKey(const Key('notifications_append_retry')),
            findsOneWidget,
          );
          expect(find.text(l10n.retry), findsOneWidget);

          listCall(
            cursor: 'c2',
          ).thenAnswer((_) async => inboxPage([announcementItem('2')]));
          await tester.tap(find.byKey(const Key('notifications_append_retry')));
          await tester.pump();
          await tester.pump();

          expect(find.byType(NotificationRow), findsNWidgets(2));
          expect(
            find.byKey(const Key('notifications_append_retry')),
            findsNothing,
          );
          verifyList(cursor: 'c2').called(2);
        },
      );

      testWidgets(
        'a failed append: scrolling to and fro asks nothing more, only Retry '
        'does · $language',
        (tester) async {
          // The inbox pages by BUTTON, never by scroll, so a long list that is
          // scrolled after a failed append must send no further request. Counted
          // at the repository, where the server would see it.
          var asks = 0;
          listCall().thenAnswer(
            (_) async => inboxPage(
              [for (var n = 1; n <= 30; n++) announcementItem('$n')],
              hasMore: true,
              nextCursor: 'c2',
            ),
          );
          listCall(cursor: 'c2').thenAnswer((_) async {
            asks++;
            throw const ApiException(
              status: 500,
              code: 'internal_server_error',
            );
          });

          await pumpInbox(tester, language: language);
          final list = find.byWidgetPredicate(
            (w) => w is ListView && w.scrollDirection == Axis.vertical,
          );
          await tester.drag(list, const Offset(0, -20000));
          await tester.pump();
          await tester.tap(find.byKey(const Key('notifications_load_more')));
          await tester.pump();
          await tester.pump();
          expect(asks, 1);
          expect(
            find.byKey(const Key('notifications_append_retry')),
            findsOneWidget,
          );

          for (var pass = 0; pass < 3; pass++) {
            await tester.drag(list, const Offset(0, 20000));
            await tester.pump();
            await tester.drag(list, const Offset(0, -20000));
            await tester.pump();
          }
          expect(asks, 1);

          await tester.tap(find.byKey(const Key('notifications_append_retry')));
          await tester.pump();
          await tester.pump();
          expect(asks, 2);
        },
      );

      testWidgets(
        'an append refused for pending deletion has no Retry · $language',
        (tester) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => inboxPage(
              [announcementItem('1')],
              hasMore: true,
              nextCursor: 'c2',
            ),
          );
          listCall(cursor: 'c2').thenAnswer(
            (_) async => throw const ApiException(
              status: 403,
              code: 'account_pending_deletion',
            ),
          );

          await pumpInbox(tester, language: language);
          await tester.tap(find.byKey(const Key('notifications_load_more')));
          await tester.pump();
          await tester.pump();

          expect(find.byType(NotificationRow), findsOneWidget);
          expect(find.text(l10n.accountPendingDeletion), findsOneWidget);
          expect(
            find.byKey(const Key('notifications_append_retry')),
            findsNothing,
          );
        },
      );

      testWidgets(
        'a rate-limited append keeps its text and offers no button · $language',
        (tester) async {
          // The same call as the first page's: a 429 recovers on its own
          // clock, so no Retry (and no Load more) is handed out to hammer it.
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => inboxPage(
              [announcementItem('1')],
              hasMore: true,
              nextCursor: 'c2',
            ),
          );
          listCall(
            cursor: 'c2',
          ).thenAnswer((_) async => throw const RateLimitedException());

          await pumpInbox(tester, language: language);
          await tester.tap(find.byKey(const Key('notifications_load_more')));
          await tester.pump();
          await tester.pump();

          expect(find.byType(NotificationRow), findsOneWidget);
          expect(find.text(l10n.genericError), findsOneWidget);
          expect(
            find.byKey(const Key('notifications_append_retry')),
            findsNothing,
          );
          expect(
            find.byKey(const Key('notifications_load_more')),
            findsNothing,
          );
          verifyList(cursor: 'c2').called(1);
        },
      );
    }

    testWidgets('hasMore with no cursor offers no Load more to tap', (
      tester,
    ) async {
      // A button the notifier would answer with nothing is worse than none.
      listCall().thenAnswer(
        (_) async => inboxPage([announcementItem('1')], hasMore: true),
      );

      await pumpInbox(tester);

      expect(find.byType(NotificationRow), findsOneWidget);
      expect(find.byKey(const Key('notifications_load_more')), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
      'a first page of only ignored items with more behind it keeps walking',
      (tester) async {
        // Every student's welcome item is one of these: the screen must not
        // flash "Nothing here yet" over rows that are one request away.
        listCall().thenAnswer((_) async => ignoredOnlyPage('i1'));
        listCall(
          cursor: 'cursor-next',
        ).thenAnswer((_) async => inboxPage([announcementItem('1')]));

        await pumpInbox(tester);
        await tester.pump();

        expect(find.byType(NotificationRow), findsOneWidget);
        expect(find.text('Nothing here yet'), findsNothing);
      },
    );
  });

  // -------------------------------------------------------------------------
  group('the chips', () {
    testWidgets('All · Announcements · Support · System, in that order, and no '
        'Promotions', (tester) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);

      final keys = [
        'notification_chip_all',
        'notification_chip_announcements',
        'notification_chip_support',
        'notification_chip_system',
      ];
      final lefts = [
        for (final key in keys) tester.getTopLeft(find.byKey(Key(key))).dx,
      ];
      expect(lefts, [...lefts]..sort(), reason: 'laid out in this order');
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Announcements'), findsWidgets);
      expect(find.text('Promotions'), findsNothing);
    });

    testWidgets('each chip asks for ITS category, and All asks for none', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      for (final category in NotificationCategory.values) {
        listCall(category: category).thenAnswer((_) async => inboxPage([]));
      }
      await pumpInbox(tester);
      verifyList().called(1);

      for (final category in [
        NotificationCategory.announcements,
        NotificationCategory.support,
        NotificationCategory.system,
      ]) {
        await tapChip(tester, 'notification_chip_${category.wire}');

        verifyList(category: category).called(1);
        expect(find.text('Nothing here yet'), findsOneWidget);
      }

      await tapChip(tester, 'notification_chip_all');
      // Back on All: the rows are there, and the request carries no
      // `category` (a null matcher, so an invented `all` would not match).
      // Leaving a chip unmounts its tab and the autoDispose notifier goes with
      // it, so coming back is exactly ONE new request from page one. The first
      // All request was verified above and no longer counts.
      expect(find.byType(NotificationRow), findsOneWidget);
      verifyList().called(1);
    });

    testWidgets('the selected chip is marked selected, the others are not', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      listCall(
        category: NotificationCategory.support,
      ).thenAnswer((_) async => inboxPage([]));
      final handle = tester.ensureSemantics();
      await pumpInbox(tester);

      bool selected(String key) =>
          tester
              .getSemantics(find.byKey(Key(key)))
              .flagsCollection
              .isSelected ==
          Tristate.isTrue;

      expect(selected('notification_chip_all'), isTrue);
      expect(selected('notification_chip_support'), isFalse);

      await tapChip(tester, 'notification_chip_support');

      expect(selected('notification_chip_all'), isFalse);
      expect(selected('notification_chip_support'), isTrue);
      handle.dispose();
    });

    testWidgets('every chip is a button with ONE node, and no image role', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      final handle = tester.ensureSemantics();
      await pumpInbox(tester);

      for (final (key, label) in [
        ('notification_chip_all', 'All'),
        ('notification_chip_announcements', 'Announcements'),
        ('notification_chip_support', 'Support'),
        ('notification_chip_system', 'System'),
      ]) {
        final node = tester.getSemantics(find.byKey(Key(key)));
        expect(node.flagsCollection.isButton, isTrue, reason: key);
        // The glyph is excluded: an SVG inside a button makes Android read an
        // ImageView.
        expect(node.flagsCollection.isImage, isFalse, reason: key);
        expect(node.label, label, reason: '$key reads once');
      }
      handle.dispose();
    });

    testWidgets('a chip is drawn 40 tall inside a 48 box', (tester) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);

      for (final key in _chipKeys) {
        final chip = find.byKey(Key(key));
        final target = tester.getSize(chip);
        expect(target.height, greaterThanOrEqualTo(48), reason: '$key target');
        expect(target.width, greaterThanOrEqualTo(48), reason: '$key target');

        expect(
          _pillOf(tester, key).height,
          40,
          reason: '$key is drawn 40 high',
        );
      }
    });

    // The 48 is a hit region, not only a layout size: a SizedBox and a Center
    // do not hit-test themselves, so the band around the 40 pill used to drop
    // the tap.
    for (final (name, above) in [('above', true), ('below', false)]) {
      testWidgets('a tap 2 px $name the pill selects the chip', (tester) async {
        listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
        listCall(
          category: NotificationCategory.support,
        ).thenAnswer((_) async => inboxPage([]));
        await pumpInbox(tester);
        verifyList().called(1);

        const key = 'notification_chip_support';
        await tester.ensureVisible(find.byKey(const Key(key)));
        await tester.pump();
        final box = tester.getRect(find.byKey(const Key(key)));
        final pill = _pillOf(tester, key);
        final y = above ? pill.top - 2 : pill.bottom + 2;
        expect(
          y,
          allOf(greaterThan(box.top), lessThan(box.bottom)),
          reason: 'inside the 48 box',
        );
        expect(y < pill.top || y > pill.bottom, isTrue, reason: 'off the pill');

        await tester.tapAt(Offset(pill.center.dx, y));
        await tester.pump();
        await tester.pump();

        verifyList(category: NotificationCategory.support).called(1);
        expect(find.text('Nothing here yet'), findsOneWidget);
      });
    }

    testWidgets('one tap calls onChanged once, on the pill and off it', (
      tester,
    ) async {
      final changes = <NotificationCategory?>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: NotificationFilterChips(
              selected: null,
              onChanged: changes.add,
            ),
          ),
        ),
      );

      const key = 'notification_chip_announcements';
      final pill = _pillOf(tester, key);
      // The InkWell is deeper than the detector around the 48 box and wins a
      // tap on the pill; the detector takes the band around it.
      await tester.tapAt(pill.center);
      await tester.pump();
      expect(changes, [NotificationCategory.announcements]);

      await tester.tapAt(Offset(pill.center.dx, pill.top - 2));
      await tester.pump();
      expect(changes, [
        NotificationCategory.announcements,
        NotificationCategory.announcements,
      ]);
    });

    testWidgets('vertical geometry: the pills sit 20 under the title bar and '
        'the list 25 under the pills', (tester) async {
      // Figma 180:8386: the title bar (180:8528) ends at y=95, the chips
      // (180:8554) start at y=115, and the list (180:8844) is 25 under them.
      // The bar's bottom edge is the back chip's (35 high, filling the bar).
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);

      final back = tester.getRect(find.byKey(const Key('notifications_back')));
      final row = tester.getRect(rowFor('1'));
      for (final key in _chipKeys) {
        final pill = _pillOf(tester, key);
        expect(pill.top - back.bottom, 20, reason: '$key pill under the bar');
        expect(row.top - pill.bottom, 25, reason: '$key pill over the list');
      }
    });
  });

  // -------------------------------------------------------------------------
  group('text scale', () {
    for (final language in languages) {
      testWidgets('a larger scale grows the selected chip and clips nothing · '
          '$language', (tester) async {
        // An empty inbox, so the chips are the only thing that can overflow:
        // a row's pill label is far wider on the test font than on Inter.
        listCall().thenAnswer((_) async => inboxPage([]));
        const all = Key('notification_chip_all');

        Rect label() => tester.getRect(
          find.descendant(of: find.byKey(all), matching: find.byType(Text)),
        );

        await pumpInbox(tester, language: language);
        final normalPill = _pillOf(tester, 'notification_chip_all');
        final normalBox = tester.getRect(find.byKey(all));
        expect(normalPill.height, 40);
        expect(normalBox.height, 48);

        await pumpInbox(
          tester,
          language: language,
          textScaler: const TextScaler.linear(2.0),
        );
        expect(tester.takeException(), isNull);
        final bigPill = _pillOf(tester, 'notification_chip_all');
        final bigBox = tester.getRect(find.byKey(all));
        // buttonLarge is a 20 line: 40 scaled, plus the 6 + 6 padding.
        expect(bigPill.height, greaterThanOrEqualTo(52));
        expect(bigBox.height, greaterThan(normalBox.height));
        expect(bigBox.height, greaterThanOrEqualTo(bigPill.height));
        // The label keeps its whole scaled line instead of being squeezed
        // into the old fixed box.
        expect(label().height, closeTo(40, 0.01));
        expect(label().height, lessThanOrEqualTo(bigPill.height - 12));
      });
    }

    for (final scale in [1.0, 1.3]) {
      testWidgets('the unread dot stays centred on the first title line at '
          '${scale}x', (tester) async {
        listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));

        await pumpInbox(tester, textScaler: TextScaler.linear(scale));

        // At 1.3x the title wraps on the test font, so the BAND is the first
        // line only: the text's top down one scaled `h3` line.
        final title = tester.getRect(find.text('English title'));
        final line = AppType.h3.fontSize! * scale * AppType.h3.height!;
        final dot = tester.getCenter(
          find.byKey(const Key('notification_unread_dot')),
        );
        expect(dot.dy, inInclusiveRange(title.top, title.top + line));
        // …and where the frame centres it: the middle of that line, give or
        // take the half pixel the frame itself is off by.
        expect(dot.dy, closeTo(title.top + line / 2, 1));
      });
    }
  });

  // -------------------------------------------------------------------------
  group('direction', () {
    testWidgets('LTR: the chip row starts at the left, the dot sits at the '
        'right', (tester) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);

      expect(
        tester.getTopLeft(find.byKey(const Key('notification_chip_all'))).dx,
        20,
      );

      final row = tester.getRect(rowFor('1'));
      final dot = tester.getCenter(
        find.byKey(const Key('notification_unread_dot')),
      );
      expect(dot.dx, greaterThan(row.center.dx));
      expect(row.right - dot.dx, lessThan(row.width / 4));
    });

    testWidgets('RTL: the chip row starts at the right, the dot sits at the '
        'left', (tester) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester, language: 'ar');

      expect(
        tester.getTopRight(find.byKey(const Key('notification_chip_all'))).dx,
        402 - 20,
      );
      // All is first, so it is the right-most chip.
      expect(
        tester.getCenter(find.byKey(const Key('notification_chip_all'))).dx,
        greaterThan(
          tester
              .getCenter(find.byKey(const Key('notification_chip_system')))
              .dx,
        ),
      );

      final row = tester.getRect(rowFor('1'));
      final dot = tester.getCenter(
        find.byKey(const Key('notification_unread_dot')),
      );
      expect(dot.dx, lessThan(row.center.dx));
      expect(dot.dx - row.left, lessThan(row.width / 4));
      // …and the disc, the row's first item, is at the right.
      final disc = tester.getCenter(
        find
            .descendant(of: rowFor('1'), matching: find.byType(ElevatedSurface))
            .at(1),
      );
      expect(disc.dx, greaterThan(row.center.dx));
    });

    testWidgets('the back chip is on the start side in both directions', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);
      expect(
        tester.getCenter(find.byKey(const Key('notifications_back'))).dx,
        lessThan(201),
      );

      await pumpInbox(tester, language: 'ar');
      expect(
        tester.getCenter(find.byKey(const Key('notifications_back'))).dx,
        greaterThan(201),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('both canvases', () {
    for (final brightness in Brightness.values) {
      for (final language in languages) {
        testWidgets('${brightness.name} · $language builds a loaded page '
            'with the canvas\'s own tokens', (tester) async {
          final palette = brightness == Brightness.light
              ? AppColors.light
              : AppColors.dark;
          final elevation = brightness == Brightness.light
              ? AppElevation.light
              : AppElevation.dark;
          listCall().thenAnswer(
            (_) async => inboxPage(
              [
                announcementItem('1'),
                warningItem('2', readAt: DateTime.utc(2026, 10, 9, 13)),
              ],
              hasMore: true,
              nextCursor: 'c2',
            ),
          );

          await pumpInbox(tester, language: language, brightness: brightness);

          expect(tester.takeException(), isNull);
          expect(find.byType(NotificationRow), findsNWidgets(2));

          // The row is the canvas's own token, with its own elevation: an
          // inner shadow in light, Glass in dark.
          final surfaces = tester.widgetList<ElevatedSurface>(
            find.descendant(
              of: rowFor('1'),
              matching: find.byType(ElevatedSurface),
            ),
          );
          final card = surfaces.first;
          expect(card.color, palette.notificationRowFill);
          expect(card.shadows, elevation.notificationRowShadows);
          expect(card.glass, elevation.notificationRowGlass);
          expect(
            brightness == Brightness.light
                ? card.shadows.single.inset && card.glass == null
                : card.shadows.isEmpty && card.glass != null,
            isTrue,
            reason: 'light raises with an inner shadow, dark with Glass',
          );

          final dot = tester.widget<Container>(
            find.byKey(const Key('notification_unread_dot')),
          );
          expect(
            (dot.decoration! as BoxDecoration).color,
            palette.notificationUnreadDot,
          );
        });
      }
    }

    testWidgets('the selected chip is flat and purple on both canvases', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      for (final (brightness, palette) in [
        (Brightness.light, AppColors.light),
        (Brightness.dark, AppColors.dark),
      ]) {
        await pumpInbox(tester, brightness: brightness);
        await tester.pumpAndSettle();
        final selected = tester.widget<ElevatedSurface>(
          find.descendant(
            of: find.byKey(const Key('notification_chip_all')),
            matching: find.byType(ElevatedSurface),
          ),
        );
        expect(selected.color, palette.notificationChipSelectedFill);
        expect(selected.shadows, isEmpty);
        expect(selected.glass, isNull);

        final idle = tester.widget<ElevatedSurface>(
          find.descendant(
            of: find.byKey(const Key('notification_chip_support')),
            matching: find.byType(ElevatedSurface),
          ),
        );
        expect(idle.color, palette.notificationChipIdleFill);
      }
    });
  });

  // -------------------------------------------------------------------------
  group('marking a row read', () {
    testWidgets('a tap on an unread row asks once and the dot goes', (
      tester,
    ) async {
      listCall().thenAnswer(
        (_) async => inboxPage([
          announcementItem('1'),
          announcementItem('2', readAt: DateTime.utc(2026, 10, 9, 13)),
        ]),
      );
      await pumpInbox(tester);
      expect(
        find.byKey(const Key('notification_unread_dot')),
        findsOneWidget,
        reason: 'only the unread row draws the dot',
      );

      await tester.tap(rowFor('1'));
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const Key('notification_unread_dot')), findsNothing);

      // It is read now: a second tap does nothing at all.
      await tester.tap(rowFor('1'));
      await tester.pump();
      await tester.pump();

      verify(() => repo.markNotificationRead('1')).called(1);
      verifyNever(() => repo.markNotificationRead('2'));
    });

    testWidgets('a tap on a READ row asks nothing', (tester) async {
      listCall().thenAnswer(
        (_) async => inboxPage([
          announcementItem('2', readAt: DateTime.utc(2026, 10, 9, 13)),
        ]),
      );
      await pumpInbox(tester);

      await tester.tap(rowFor('2'));
      await tester.pump();
      await tester.pump();

      verifyNever(() => repo.markNotificationRead(any()));
    });

    testWidgets('a failed mark leaves the row unread, with no retry', (
      tester,
    ) async {
      when(() => repo.markNotificationRead(any())).thenAnswer(
        (_) async => throw const ApiException(
          status: 500,
          code: 'internal_server_error',
        ),
      );
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);

      await tester.tap(rowFor('1'));
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const Key('notification_unread_dot')), findsOneWidget);
      // Nothing surfaced, nothing looped.
      expect(find.byType(SnackBar), findsNothing);
      verify(() => repo.markNotificationRead('1')).called(1);
    });

    testWidgets('a 404 not_found also leaves the row read', (tester) async {
      when(() => repo.markNotificationRead(any())).thenAnswer(
        (_) async => throw const ApiException(status: 404, code: 'not_found'),
      );
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);

      await tester.tap(rowFor('1'));
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const Key('notification_unread_dot')), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('semantics', () {
    testWidgets('an unread row is ONE button; a read row is not a button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      listCall().thenAnswer(
        (_) async => inboxPage([
          announcementItem('1'),
          announcementItem('2', readAt: DateTime.utc(2026, 10, 9, 13)),
        ]),
      );
      await pumpInbox(tester);

      final unread = tester.getSemantics(rowFor('1'));
      expect(unread.flagsCollection.isButton, isTrue);
      expect(unread.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      // Not an ImageView on Android: the glyph is excluded.
      expect(unread.flagsCollection.isImage, isFalse);

      final read = tester.getSemantics(rowFor('2'));
      expect(read.flagsCollection.isButton, isFalse);
      expect(read.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      expect(read.flagsCollection.isImage, isFalse);
      handle.dispose();
    });

    testWidgets('a row reads title, body, category and time as one node, '
        'with no invented "unread"', (tester) async {
      final handle = tester.ensureSemantics();
      final createdAt = DateTime.utc(2026, 10, 9, 12);
      listCall().thenAnswer(
        (_) async => inboxPage([
          notification(
            '1',
            data: announcementData(
              titleEn: 'New quiz',
              bodyEn: 'Cell Biology was added',
            ),
            createdAt: createdAt,
          ),
        ]),
      );
      await pumpInbox(tester);

      final label = tester.getSemantics(rowFor('1')).label;
      final time = DateFormat.yMMMd('en').add_jm().format(createdAt.toLocal());
      for (final part in [
        'New quiz',
        'Cell Biology was added',
        'Announcements',
        time,
      ]) {
        expect(label, contains(part));
      }
      expect(label.toLowerCase(), isNot(contains('unread')));
      handle.dispose();
    });

    testWidgets('the row text renders as plain text: no recognisers, '
        'line breaks kept', (tester) async {
      listCall().thenAnswer(
        (_) async => inboxPage([
          notification(
            '1',
            data: announcementData(
              bodyEn: 'Line one\nSee https://example.com now',
            ),
          ),
        ]),
      );
      await pumpInbox(tester);

      final body = tester.widget<Text>(
        find.textContaining('Line one', findRichText: false),
      );
      expect(body.data, 'Line one\nSee https://example.com now');
      expect(body.textSpan, isNull, reason: 'a plain Text, never auto-linked');
      expect(find.byType(SelectableText), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('what each kind shows', () {
    testWidgets('an announcement shows the English pair under EN', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester);

      expect(find.text('English title'), findsOneWidget);
      expect(find.text('English body'), findsOneWidget);
      expect(find.text('عنوان عربي'), findsNothing);
      expect(find.text('نص عربي'), findsNothing);
    });

    testWidgets('an announcement shows the ARABIC pair under AR', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => inboxPage([announcementItem('1')]));
      await pumpInbox(tester, language: 'ar');

      expect(find.text('عنوان عربي'), findsOneWidget);
      expect(find.text('نص عربي'), findsOneWidget);
      expect(find.text('English title'), findsNothing);
      expect(find.text('English body'), findsNothing);
    });

    for (final language in languages) {
      testWidgets(
        'a moderation_warning shows the contract text VERBATIM · $language',
        (tester) async {
          final copy = _contractModerationCopy();
          listCall(
            category: NotificationCategory.system,
          ).thenAnswer((_) async => inboxPage([warningItem('w')]));
          listCall().thenAnswer((_) async => inboxPage([warningItem('w')]));

          await pumpInbox(tester, language: language);

          final title = language == 'en' ? copy.enTitle : copy.arTitle;
          final body = language == 'en' ? copy.enBody : copy.arBody;
          final other = language == 'en' ? copy.arTitle : copy.enTitle;

          expect(find.text(title), findsOneWidget);
          expect(find.text(body), findsOneWidget);
          expect(find.text(other), findsNothing);

          final l10n = await l10nFor(language);
          expect(l10n.notifModerationWarningTitle, title);
          expect(l10n.notifModerationWarningBody, body);
          // Its pill is System.
          expect(find.text(l10n.notifSystem), findsWidgets);
        },
      );
    }

    testWidgets('both languages carry the contract text character for '
        'character', (tester) async {
      // Not through a widget: the comparison itself, so a failure names the
      // key. Includes the contract's spelling "نهائيا" and the Latin
      // "Level Up" inside the Arabic body.
      final copy = _contractModerationCopy();
      final en = await l10nFor('en');
      final ar = await l10nFor('ar');

      expect(en.notifModerationWarningTitle, copy.enTitle);
      expect(en.notifModerationWarningBody, copy.enBody);
      expect(ar.notifModerationWarningTitle, copy.arTitle);
      expect(ar.notifModerationWarningBody, copy.arBody);
      expect(ar.notifModerationWarningBody, contains('نهائيا'));
      expect(ar.notifModerationWarningBody, contains('Level Up'));
    });

    testWidgets('ignored kinds never render', (tester) async {
      listCall().thenAnswer(
        (_) async => inboxPage([
          ignoredItem('enrolment'),
          notification(
            'ticket',
            kind: 'support_ticket_replied',
            category: 'support',
            data: const {'ticketId': 't', 'reference': 'TK-1'},
          ),
          notification(
            'year',
            kind: 'academic_year_opened',
            category: 'system',
            data: const {},
          ),
          notification(
            'future-kind',
            kind: 'a_kind_from_the_future',
            category: 'system',
            data: const {'anything': 'at all'},
          ),
          notification(
            'future-category',
            category: 'a_category_from_the_future',
          ),
          notification('malformed', data: const {'titleEn': 'only a title'}),
          announcementItem('shown'),
        ]),
      );
      await pumpInbox(tester);

      expect(find.byType(NotificationRow), findsOneWidget);
      expect(rowFor('shown'), findsOneWidget);
      for (final id in [
        'enrolment',
        'ticket',
        'year',
        'future-kind',
        'future-category',
        'malformed',
      ]) {
        expect(rowFor(id), findsNothing, reason: id);
      }
      expect(find.text('only a title'), findsNothing);
    });

    testWidgets('each category has its own pill', (tester) async {
      listCall().thenAnswer(
        (_) async => inboxPage([announcementItem('a'), warningItem('s')]),
      );
      await pumpInbox(tester);

      Finder pill(String id, String label) =>
          find.descendant(of: rowFor(id), matching: find.text(label));
      expect(pill('a', 'Announcements'), findsOneWidget);
      expect(pill('s', 'System'), findsOneWidget);
    });

    testWidgets('the time is an absolute date and time in the UI locale and '
        'the local zone', (tester) async {
      final createdAt = DateTime.utc(2026, 10, 9, 12, 30);
      listCall().thenAnswer(
        (_) async => inboxPage([notification('1', createdAt: createdAt)]),
      );

      await pumpInbox(tester);
      expect(
        find.text(DateFormat.yMMMd('en').add_jm().format(createdAt.toLocal())),
        findsOneWidget,
      );

      await pumpInbox(tester, language: 'ar');
      expect(
        find.text(DateFormat.yMMMd('ar').add_jm().format(createdAt.toLocal())),
        findsOneWidget,
      );
    });
  });
}

/// The four `moderation_warning` strings, read out of the VENDORED contract —
/// `listMyNotifications`'s description in `contract/openapi.yaml` — so the test
/// compares the ARB keys with the source they claim to copy rather than with a
/// second hand-typed copy. A YAML flow scalar folds a line break and its
/// indentation into ONE space, which is what the join does.
({String enTitle, String enBody, String arTitle, String arBody})
_contractModerationCopy() {
  final lines = File('contract/openapi.yaml').readAsLinesSync();
  final start = lines.indexWhere((line) => line.contains('EN title: "'));
  expect(
    start,
    isNonNegative,
    reason: 'the contract no longer prints the copy',
  );
  final joined = lines
      .skip(start)
      .takeWhile((line) => !line.contains('kind: support_ticket_replied'))
      .map((line) => line.trim())
      .join(' ');

  String grab(String label) {
    final match = RegExp('$label: "([^"]*)"').firstMatch(joined);
    expect(match, isNotNull, reason: 'no "$label" in the contract');
    return match!.group(1)!;
  }

  return (
    enTitle: grab('EN title'),
    enBody: grab('EN body'),
    arTitle: grab('AR title'),
    arBody: grab('AR body'),
  );
}
