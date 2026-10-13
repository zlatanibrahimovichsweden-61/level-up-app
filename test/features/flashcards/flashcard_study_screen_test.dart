import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/offline_banner.dart';
import 'package:level_up_app/core/widgets/study_session_chrome.dart';
import 'package:level_up_app/features/flashcards/models/flashcard.dart';
import 'package:level_up_app/features/flashcards/notifier/lecture_flashcards_notifier.dart';
import 'package:level_up_app/features/flashcards/repository/flashcards_repository.dart';
import 'package:level_up_app/features/flashcards/screens/flashcard_study_screen.dart';
import 'package:level_up_app/features/flashcards/widgets/flashcard_again_button.dart';
import 'package:level_up_app/features/flashcards/widgets/flashcard_flip_card.dart';
import 'package:level_up_app/features/quiz/screens/screen_protection.dart';
import 'package:level_up_app/features/quiz/widgets/limit_sheet.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'reading_order.dart';

/// The flashcards study screen · Figma `225:5582`.
///
/// Runs inside a stand-in router with a PARENT route ("Setup"), because the
/// screen's exits are navigation: the ✕ and the last card both pop back to it.
/// The stand-in Setup watches the round position exactly as the real Setup
/// screen must, so a round's end can be read off the provider. Assertions on
/// the location use `GoRouter.state.uri` — `currentConfiguration` misses an
/// imperative push (memory: gorouter-test-location).
class _MockRepo extends Mock implements FlashcardsRepository {}

/// Records what the plugin would have been asked. The screen must never touch it.
class _Protection extends ScreenProtection {
  int enables = 0;
  int disables = 0;

  @override
  Future<void> enable() async => enables++;

  @override
  Future<void> disable() async => disables++;
}

/// A network stand-in whose requests never answer: an `Image.network` stays
/// "loading", so its box can be measured without a timer or a real fetch.
class _PendingImageHttp extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      Completer<HttpClientRequest>().future;
}

const _lecture = 'lec-1';
const _setup = '/setup';
const _study = '/setup/study';

/// The real nesting (`app_router.dart`): Lectures, Setup under it, Study under
/// that.
const _realSetup = '/learn/subject/sub-1/lecture/lec-1/flashcards';
const _realStudy = '$_realSetup/study';

FlashcardCard _card(int n, {String? imageUrl, String? back}) => FlashcardCard(
  id: 'c$n',
  front: 'Front $n',
  back: back ?? 'Back $n',
  imageUrl: imageUrl,
  selfGrade: null,
);

List<FlashcardCard> _deck(int n) => [for (var i = 1; i <= n; i++) _card(i)];

/// Purchase wording the app must never draw (adr-049 §3: purchase-silent).
const _bannedEnglish = [
  'price',
  'subscribe',
  'subscription',
  'upgrade',
  'buy',
  'purchase',
  'checkout',
  'premium',
  'plan',
  'pro',
  'pay',
  'paid',
  'egp',
];
const _bannedArabic = [
  'اشتراك',
  'اشترك',
  'ترقية',
  'سعر',
  'جنيه',
  'شراء',
  'ادفع',
  'مدفوع',
  'بريميوم',
];

/// The one-letter and article prefixes Arabic glues onto a word ("للاشتراك",
/// "السعر"): whole-word matching has to see through them.
const _arabicPrefixes = [
  '',
  'ال',
  'وال',
  'بال',
  'كال',
  'فال',
  'لل',
  'و',
  'ب',
  'ك',
  'ل',
  'ف',
];

/// The banned words [text] holds. Whole words only, case-insensitively, so
/// "free" and "pronounce" do not trip "pro". A word is a run of letters, marks
/// and digits: Dart's `\b` is ASCII-only and would not bound an Arabic one.
List<String> _purchaseWords(String text) {
  final words = RegExp(
    r'[\p{L}\p{M}\p{N}]+',
    unicode: true,
  ).allMatches(text).map((m) => m.group(0)!.toLowerCase()).toList();
  return [
    for (final banned in _bannedEnglish)
      if (words.contains(banned)) banned,
    for (final banned in _bannedArabic)
      if (words.any((w) => _arabicPrefixes.any((p) => w == '$p$banned')))
        banned,
    if (text.contains('£')) '£',
  ];
}

/// WCAG contrast ratio of two opaque colours (4.5 is body text's AA line).
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

CursorPage<FlashcardCard> _page(
  List<FlashcardCard> items, {
  String? nextCursor,
  bool hasMore = false,
}) => CursorPage(items: items, nextCursor: nextCursor, hasMore: hasMore);

/// A repository whose round is [cards] and whose grades all succeed.
_MockRepo _repo(
  List<FlashcardCard> cards, {
  String? nextCursor,
  bool hasMore = false,
}) {
  final repo = _MockRepo();
  _stubRound(repo, _page(cards, nextCursor: nextCursor, hasMore: hasMore));
  when(() => repo.setSelfGrade(any(), any())).thenAnswer((_) async {});
  return repo;
}

void _stubRound(_MockRepo repo, CursorPage<FlashcardCard> page) {
  when(
    () => repo.getFlashcardsForLecture(
      _lecture,
      cursor: null,
      pageSize: any(named: 'pageSize'),
    ),
  ).thenAnswer((_) async => page);
}

class _Harness {
  _Harness({
    required this.container,
    required this.router,
    required this.repo,
    required this.protection,
  });

  final ProviderContainer container;
  final GoRouter router;
  final _MockRepo repo;
  final _Protection protection;

  String get location => router.state.uri.toString();

  /// Where the next round starts, as Setup would see it.
  String? get position =>
      container.read(flashcardRoundPositionProvider(_lecture));
}

/// Boots a stand-in app at Setup and pushes the study screen over it.
///
/// A fetch held on a `Completer` leaves the screen on its skeleton, which has
/// no animation, so the route transition still settles around it.
///
/// [realStack] gives Setup a PARENT of its own, as the app has (Lectures ->
/// Setup -> Study): the default harness has Setup as the root route, where a
/// second, stray pop takes the "nothing to pop" branch and hides itself.
Future<_Harness> _open(
  WidgetTester tester, {
  required _MockRepo repo,
  String locale = 'en',
  ThemeData? theme,
  bool online = true,
  bool reducedMotion = false,
  Size size = const Size(402, 874),
  double textScale = 1,
  bool standalone = false,
  bool realStack = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final protection = _Protection();
  final container = ProviderContainer(
    overrides: [
      flashcardsRepositoryProvider.overrideWithValue(repo),
      screenProtectionProvider.overrideWithValue(protection),
      isOnlineProvider.overrideWith((ref) => Stream.value(online)),
    ],
  );
  addTearDown(container.dispose);

  Widget setupPage() => Consumer(
    builder: (context, ref, _) {
      // What the real Setup screen does: hold the round position alive.
      ref.watch(flashcardRoundPositionProvider(_lecture));
      return const Scaffold(body: Text('SETUP'));
    },
  );
  Widget studyPage() =>
      const FlashcardStudyScreen(subjectId: 'sub-1', lectureId: _lecture);

  final router = GoRouter(
    initialLocation: realStack
        ? _realSetup
        : standalone
        ? '/study'
        : _setup,
    routes: realStack
        ? [
            GoRoute(
              path: '/learn/subject/:subjectId',
              builder: (context, state) =>
                  const Scaffold(body: Text('LECTURES')),
              routes: [
                GoRoute(
                  path: 'lecture/:lectureId/flashcards',
                  builder: (context, state) => setupPage(),
                  routes: [
                    GoRoute(
                      path: 'study',
                      builder: (context, state) => studyPage(),
                    ),
                  ],
                ),
              ],
            ),
          ]
        : [
            if (standalone) ...[
              // A deep link: the study route with nothing under it.
              GoRoute(path: '/study', builder: (context, state) => studyPage()),
              GoRoute(
                path: '/learn/subject/:subjectId',
                builder: (context, state) =>
                    const Scaffold(body: Text('SUBJECT')),
              ),
            ],
            GoRoute(
              path: _setup,
              builder: (context, state) => setupPage(),
              routes: [
                GoRoute(
                  path: 'study',
                  builder: (context, state) => studyPage(),
                ),
              ],
            ),
          ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        locale: Locale(locale),
        theme: theme ?? AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reducedMotion,
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  if (!standalone) unawaited(router.push(realStack ? _realStudy : _study));
  await tester.pumpAndSettle();

  return _Harness(
    container: container,
    router: router,
    repo: repo,
    protection: protection,
  );
}

void main() {
  setUpAll(() => registerFallbackValue(FlashcardSelfGrade.gotIt));

  final gotIt = find.byKey(const Key('flashcard_got_it'));
  final again = find.byKey(const Key('flashcard_again'));
  final cardFinder = find.byKey(const Key('flashcard_card'));
  final header = find.byKey(const Key('flashcard_header'));
  final close = find.byKey(const Key('flashcard_close'));
  final previous = find.byType(StudyPreviousButton);
  final errorLine = find.byKey(const Key('flashcard_error'));

  Rect rect(WidgetTester tester, Finder f) => tester.getRect(f);

  Rect discRect(WidgetTester tester) => tester.getRect(
    find.descendant(of: again, matching: find.byType(ElevatedSurface)),
  );

  LinearProgressIndicator bar(WidgetTester tester) =>
      tester.widget(find.byType(LinearProgressIndicator));

  /// Every string drawn on screen, offstage routes included, after asserting
  /// that none of it is purchase wording.
  List<String> drawnTextWithoutPurchaseWording(WidgetTester tester) {
    final drawn = [
      for (final r in tester.widgetList<RichText>(
        find.byType(RichText, skipOffstage: false),
      ))
        r.text.toPlainText(),
    ];
    expect(drawn, isNotEmpty);
    for (final text in drawn) {
      expect(
        _purchaseWords(text),
        isEmpty,
        reason: 'purchase wording: "$text"',
      );
    }
    return drawn;
  }

  /// Taps "Got it" and lets the grade land.
  Future<void> gradeGotIt(WidgetTester tester) async {
    await tester.tap(gotIt);
    await tester.pumpAndSettle();
  }

  FilledButton gotItButton(WidgetTester tester) =>
      tester.widget<FilledButton>(gotIt);

  group('the counter and the header', () {
    testWidgets(
      'a full round reads 1/10, and the fill is the flashcard token',
      (tester) async {
        await _open(tester, repo: _repo(_deck(10)));

        expect(find.text('1/10'), findsOneWidget);
        expect(bar(tester).value, closeTo(0.1, 1e-9));
        expect(
          bar(tester).valueColor!.value,
          AppColors.light.flashcardProgressFill,
        );
        // Not the quiz's fill.
        expect(
          bar(tester).valueColor!.value,
          isNot(AppColors.light.quizProgressFill),
        );
        expect(find.text('Flash cards'), findsOneWidget);
        expect(find.text('Quiz'), findsNothing);
      },
    );

    testWidgets('a short round reads 1/4: the total is what was delivered', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(4)));

      expect(find.text('1/4'), findsOneWidget);
      expect(find.text('1/10'), findsNothing);
      expect(bar(tester).value, closeTo(0.25, 1e-9));
    });

    testWidgets('dark: the fill is the dark token', (tester) async {
      await _open(tester, repo: _repo(_deck(10)), theme: AppTheme.dark);

      expect(
        bar(tester).valueColor!.value,
        AppColors.dark.flashcardProgressFill,
      );
    });

    testWidgets('the header is the shared one: 89.18 tall, ✕ 16 in', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)));

      final h = rect(tester, header);
      expect(h.top, 0);
      expect(h.width, 402);
      expect(h.height, moreOrLessEquals(89.18));
      expect(rect(tester, close).size, const Size(48, 48));
      // The ✕ box sits 16 in: its 48 dp target starts 16 - 9 in.
      expect(rect(tester, close).left, 16 - 9);
      // The bookmark and share glyphs are not drawn.
      expect(find.byIcon(Icons.share), findsNothing);
      expect(find.byIcon(Icons.bookmark_border), findsNothing);
    });

    // CW17 resp-q2 / RESPONSIVE.md #2, on the real screen. The progress row is
    // the counter's 18 dp line at the default scale and GROWS with the text
    // (the shared header's own pins are in `w4_study_progress_row_*_test.dart`
    // under test/core/widgets): at 2.0x the counter's line is 28 dp, and a
    // fixed 18 dp box clamped the paragraph while its glyphs kept their size.
    for (final locale in ['en', 'ar']) {
      testWidgets('2x text · the counter is drawn whole, inside the header · '
          '$locale', (tester) async {
        await _open(
          tester,
          repo: _repo(_deck(10)),
          textScale: 2,
          locale: locale,
        );
        final l10n = AppLocalizations.of(tester.element(header));
        final counter = find.text(l10n.quizProgress(1, 10));
        expect(counter, findsOneWidget);

        // The line the glyphs really occupy, laid out with the paragraph's own
        // inputs: a paragraph's rect is clamped to the room it is given.
        final paragraph = tester.renderObject<RenderParagraph>(counter);
        final painter = TextPainter(
          text: paragraph.text,
          textDirection: paragraph.textDirection,
          textScaler: paragraph.textScaler,
        )..layout();
        final natural = painter.height;
        painter.dispose();

        final counterRect = rect(tester, counter);
        final headerRect = rect(tester, header);
        expect(
          counterRect.height,
          greaterThanOrEqualTo(natural - 0.01),
          reason: 'a clamped box paints its glyphs outside it',
        );
        expect(counterRect.bottom, lessThanOrEqualTo(headerRect.bottom));
        // It only ever GREW: never shorter than the frame's 89.18.
        expect(headerRect.height, greaterThanOrEqualTo(89.18 - 0.01));
        expect(tester.takeException(), isNull);
      });
    }

    // The owner's instruction: the title is centred on the SCREEN, not on the
    // room beside the ✕ (the frame's own sits 26.5 dp off it, 225:5607).
    for (final (name, locale, title) in [
      ('EN', 'en', 'Flash cards'),
      ('AR', 'ar', 'فلاش كارد'),
    ]) {
      testWidgets('$name: the title sits on the screen centre', (tester) async {
        await _open(tester, repo: _repo(_deck(10)), locale: locale);

        final centre = tester.getCenter(find.text(title));
        expect(centre.dx, moreOrLessEquals(402 / 2, epsilon: 0.5));
        // On the ✕'s row, inside the header.
        expect(centre.dy, moreOrLessEquals(rect(tester, close).center.dy));
        expect(rect(tester, header).contains(centre), isTrue);
      });
    }

    testWidgets('loading: the header without a counter, and a skeleton card', (
      tester,
    ) async {
      final pending = Completer<CursorPage<FlashcardCard>>();
      final repo = _MockRepo();
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) => pending.future);
      await _open(tester, repo: repo);

      expect(find.text('Flash cards'), findsOneWidget);
      // No counter of any kind, and no invented 0/0.
      expect(find.textContaining(RegExp(r'\d+/\d+')), findsNothing);
      expect(bar(tester).value, 0);
      // The card shape, in the track colour, where the card will be.
      final skeleton = find.byKey(const Key('flashcard_skeleton'));
      expect(skeleton, findsOneWidget);
      final box = tester.widget<Container>(
        find.descendant(of: skeleton, matching: find.byType(Container)),
      );
      expect(
        (box.decoration! as BoxDecoration).color,
        AppColors.light.progressTrack,
      );
      expect(cardFinder, findsNothing);
      expect(gotIt, findsNothing);
      expect(again, findsNothing);

      pending.complete(_page(_deck(10)));
      await tester.pumpAndSettle();
      expect(find.text('1/10'), findsOneWidget);
      expect(skeleton, findsNothing);
      // The skeleton was the card's size, so nothing jumps when it lands.
      expect(cardFinder, findsOneWidget);
    });

    testWidgets('the skeleton sits exactly where the card lands', (
      tester,
    ) async {
      final pending = Completer<CursorPage<FlashcardCard>>();
      final repo = _MockRepo();
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) => pending.future);
      await _open(tester, repo: repo);

      final loading = rect(tester, find.byKey(const Key('flashcard_skeleton')));
      pending.complete(_page(_deck(10)));
      await tester.pumpAndSettle();
      final loaded = rect(tester, cardFinder);

      expect(loading.left, loaded.left);
      expect(loading.top, loaded.top);
      expect(loading.size, loaded.size);
    });
  });

  group('geometry against the frame (402 wide, 20 margins)', () {
    testWidgets('disc, card and buttons sit where 225:5582 puts them', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)));

      final h = rect(tester, header);
      final disc = discRect(tester);
      final card = rect(tester, cardFinder);
      final row = rect(tester, gotIt);

      // The restart disc: 38, 20 from the END edge, 16 under the header's rule.
      expect(disc.size, const Size(38, 38));
      expect(disc.right, 402 - 20);
      expect(disc.left, 402 - 20 - 38);
      expect(disc.top, moreOrLessEquals(h.bottom + 16));
      // Its hit target is 48, centred on it, and inside the layout.
      final target = rect(tester, again);
      expect(target.size, const Size(48, 48));
      expect(target.center, disc.center);

      // The card: 20 from each side, 14 under the disc, 454 tall.
      expect(card.left, 20);
      expect(card.right, 402 - 20);
      expect(card.top, moreOrLessEquals(disc.bottom + 14));
      expect(card.height, moreOrLessEquals(454, epsilon: 0.001));

      // The button row: 34 under the card, 60 tall, 20 margins.
      expect(row.top, moreOrLessEquals(card.bottom + 34));
      expect(row.height, 60);
      expect(row.left, 20);
      expect(row.right, 402 - 20);
    });

    testWidgets('on a tall screen the spare room is UNDER the buttons', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)), size: const Size(402, 1200));

      final card = rect(tester, cardFinder);
      final row = rect(tester, gotIt);
      // The card did not stretch to fill it...
      expect(card.height, moreOrLessEquals(454, epsilon: 0.001));
      expect(row.top, moreOrLessEquals(card.bottom + 34));
      // ...it is all below the row.
      expect(1200 - row.bottom, greaterThan(300));
    });

    testWidgets('on a short screen the card shrinks first', (tester) async {
      await _open(tester, repo: _repo(_deck(10)), size: const Size(402, 560));

      final card = rect(tester, cardFinder);
      final row = rect(tester, gotIt);
      expect(card.height, lessThan(454));
      expect(card.height, greaterThan(200));
      // Everything else kept the frame's gaps.
      expect(row.top, moreOrLessEquals(card.bottom + 34));
      expect(row.height, 60);
      expect(560 - row.bottom, moreOrLessEquals(20, epsilon: 0.01));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a very short window scrolls rather than overflowing', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)), size: const Size(402, 330));

      expect(rect(tester, cardFinder).height, 200);
      expect(tester.takeException(), isNull);
      // The body is a scroll view, and the buttons can be reached.
      await tester.dragUntilVisible(
        gotIt,
        find.byType(SingleChildScrollView).first,
        const Offset(0, -80),
      );
      expect(gotIt, findsOneWidget);
    });

    testWidgets('card 2 adds the 79 pill and the 15 gap before "Got it"', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)));
      await gradeGotIt(tester);

      final pill = rect(tester, previous);
      final row = rect(tester, gotIt);
      expect(pill.size, const Size(79, 58));
      expect(pill.left, 20);
      expect(row.left, 20 + 79 + 15);
      expect(row.right, 402 - 20);
    });

    testWidgets('2x text does not overflow', (tester) async {
      await _open(
        tester,
        repo: _repo([
          _card(1, back: List.filled(20, 'a long multi part answer').join(' ')),
        ]),
        textScale: 2,
      );
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('the card', () {
    testWidgets('an image-less card shows no Image and centres its question', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)));

      expect(find.byType(Image), findsNothing);
      final card = rect(tester, cardFinder);
      final text = tester.getCenter(find.text('Front 1'));
      expect(text.dx, moreOrLessEquals(card.center.dx, epsilon: 0.01));
      expect(text.dy, moreOrLessEquals(card.center.dy, epsilon: 0.01));
    });

    testWidgets(
      'the card is the light object: radius 20, cream, inner shadow',
      (tester) async {
        await _open(tester, repo: _repo(_deck(10)));

        final surface = tester.widget<ElevatedSurface>(
          find.descendant(
            of: cardFinder,
            matching: find.byType(ElevatedSurface),
          ),
        );
        expect(
          (surface.shape as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(20),
        );
        expect(surface.color, AppColors.light.flashcardCardFill);
        expect(surface.shadows, AppElevation.light.flashcardCardShadows);
      },
    );

    testWidgets('a tap turns it to the answer, and back', (tester) async {
      await _open(tester, repo: _repo(_deck(10)));
      expect(find.text('Front 1'), findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      expect(find.text('Back 1'), findsOneWidget);
      expect(find.text('Front 1'), findsNothing);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      expect(find.text('Front 1'), findsOneWidget);
      expect(find.text('Back 1'), findsNothing);
    });

    testWidgets('the turn takes time: still the question at 60 ms, the answer '
        'by 300 ms', (tester) async {
      await _open(tester, repo: _repo(_deck(10)));
      await tester.tap(cardFinder);
      await tester.pump();
      // Animated: the first frame has not turned yet, 60 ms in it still has not
      // passed edge-on, and the answer is there by 300 ms.
      expect(find.text('Front 1'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('Front 1'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 240));
      expect(find.text('Back 1'), findsOneWidget);
    });

    testWidgets('reduced motion: the answer is there on the very next frame', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)), reducedMotion: true);
      await tester.tap(cardFinder);
      await tester.pump();

      expect(find.text('Back 1'), findsOneWidget);
      expect(find.text('Front 1'), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('the buttons work on either side of the card', (tester) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);

      // Flipped to the answer, "Got it" still grades this card.
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      await gradeGotIt(tester);

      verify(() => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt)).called(1);
      expect(find.text('2/10'), findsOneWidget);
    });

    testWidgets('each new card starts on its front', (tester) async {
      await _open(tester, repo: _repo(_deck(10)));
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      expect(find.text('Back 1'), findsOneWidget);

      // Frame by frame, NOT settled: a card that reused the last one's widget
      // would still be showing its back here and only turn round afterwards.
      await tester.tap(gotIt);
      await tester.pump();
      await tester.pump();

      expect(find.text('2/10'), findsOneWidget);
      expect(find.text('Front 2'), findsOneWidget);
      expect(find.text('Back 2'), findsNothing);
      // And it is at rest, face-on, not mid-turn.
      final turn = tester
          .widget<Transform>(
            find
                .ancestor(
                  of: find.descendant(
                    of: cardFinder,
                    matching: find.byType(ElevatedSurface),
                  ),
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform;
      expect(turn.storage[0], moreOrLessEquals(1, epsilon: 0.001));
    });

    testWidgets('going back lands on the front of the earlier card', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)));
      await gradeGotIt(tester);
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      expect(find.text('Back 2'), findsOneWidget);

      await tester.tap(previous);
      await tester.pumpAndSettle();

      expect(find.text('Front 1'), findsOneWidget);
      expect(find.text('1/10'), findsOneWidget);
    });

    testWidgets('an answer with several lines is one wrapping block', (
      tester,
    ) async {
      const answer = 'Cornea\nSclera\nRetina';
      await _open(tester, repo: _repo([_card(1, back: answer), _card(2)]));
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      expect(find.text(answer), findsOneWidget);
      expect(
        rect(tester, find.text(answer)).height,
        greaterThanOrEqualTo(3 * 34),
      );
    });

    testWidgets('a card image is drawn only when the card has a URL', (
      tester,
    ) async {
      // A request that never answers, so the box stays put and is measurable.
      final http = _PendingImageHttp();
      PaintingBinding.instance.imageCache
        ..clear()
        ..clearLiveImages();
      debugNetworkImageHttpClientProvider = () => http;
      try {
        await _open(
          tester,
          repo: _repo([
            _card(1, imageUrl: 'https://cdn.example.test/1.png'),
            _card(2),
          ]),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(
          (image.image as NetworkImage).url,
          'https://cdn.example.test/1.png',
        );
        expect(image.fit, BoxFit.cover);
        // 15 narrower than the card, 223 tall, 25 under its top edge.
        final card = rect(tester, cardFinder);
        final box = rect(tester, find.byType(Image));
        expect(box.size, Size(card.width - 15, 223));
        expect(box.top, card.top + 25);
        // The question sits 43 under it.
        expect(
          rect(tester, find.text('Front 1')).top,
          moreOrLessEquals(box.bottom + 43, epsilon: 0.01),
        );

        // Card 2 has no URL, so there is no image box at all.
        await gradeGotIt(tester);
        expect(find.byType(Image), findsNothing);
        final text = tester.getCenter(find.text('Front 2'));
        expect(
          text.dy,
          moreOrLessEquals(rect(tester, cardFinder).center.dy, epsilon: 0.01),
        );
      } finally {
        debugNetworkImageHttpClientProvider = null;
        PaintingBinding.instance.imageCache
          ..clear()
          ..clearLiveImages();
      }
    });
  });

  group('grading', () {
    testWidgets('"Got it" sends ONE gotIt for the card and advances to 2/10', (
      tester,
    ) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);

      await gradeGotIt(tester);

      verify(() => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt)).called(1);
      verifyNever(() => repo.setSelfGrade(any(), FlashcardSelfGrade.again));
      expect(find.text('2/10'), findsOneWidget);
      expect(find.text('Front 2'), findsOneWidget);
      expect(bar(tester).value, closeTo(0.2, 1e-9));
    });

    testWidgets('the restart button sends again for the card and advances', (
      tester,
    ) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);

      await tester.tap(again);
      await tester.pumpAndSettle();

      verify(() => repo.setSelfGrade('c1', FlashcardSelfGrade.again)).called(1);
      verifyNever(() => repo.setSelfGrade(any(), FlashcardSelfGrade.gotIt));
      expect(find.text('2/10'), findsOneWidget);
    });

    testWidgets('the 5 dp ring around the disc is live: a 48 dp target', (
      tester,
    ) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);

      // Inside the 48 box, outside the 38 disc.
      final target = rect(tester, again);
      await tester.tapAt(target.topLeft + const Offset(1.5, 1.5));
      await tester.pumpAndSettle();

      verify(() => repo.setSelfGrade('c1', FlashcardSelfGrade.again)).called(1);
    });

    testWidgets('while the PUT is out: card, "<" and again are inert, and the '
        'index has not moved', (tester) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      await gradeGotIt(tester); // now on card 2, so "<" exists

      final pending = Completer<void>();
      when(
        () => repo.setSelfGrade('c2', FlashcardSelfGrade.gotIt),
      ).thenAnswer((_) => pending.future);
      await tester.tap(gotIt);
      await tester.pump();

      // "Got it" is busy: a spinner in place of its label, and disabled.
      expect(
        find.descendant(
          of: gotIt,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
      expect(find.text('Got it'), findsNothing);
      expect(gotItButton(tester).onPressed, isNull);
      // "<" and the restart button are disabled.
      expect(tester.widget<StudyPreviousButton>(previous).onPressed, isNull);
      expect(tester.widget<FlashcardAgainButton>(again).onPressed, isNull);
      // The card ignores taps.
      expect(tester.widget<FlashcardFlipCard>(cardFinder).onFlip, isNull);
      await tester.tap(cardFinder);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Front 2'), findsOneWidget);
      // And tapping the dead controls sends nothing more.
      await tester.tap(again);
      await tester.tap(previous);
      await tester.pump();
      verify(() => repo.setSelfGrade('c2', FlashcardSelfGrade.gotIt)).called(1);
      verifyNever(() => repo.setSelfGrade('c2', FlashcardSelfGrade.again));
      // The index has not moved.
      expect(find.text('2/10'), findsOneWidget);

      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('3/10'), findsOneWidget);
      expect(gotItButton(tester).onPressed, isNotNull);
      expect(tester.widget<FlashcardAgainButton>(again).onPressed, isNotNull);
    });

    testWidgets('a failed PUT stays on the card with the mapped message and '
        're-enables everything', (tester) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      await gradeGotIt(tester); // card 2

      when(
        () => repo.setSelfGrade('c2', FlashcardSelfGrade.gotIt),
      ).thenAnswer((_) async => throw const NetworkException());
      await tester.tap(gotIt);
      await tester.pumpAndSettle();

      // Same card, same counter.
      expect(find.text('2/10'), findsOneWidget);
      expect(find.text('Front 2'), findsOneWidget);
      // One line of the mapped copy, in the flashcards error token (the
      // quiz's red on light; see the dark test below for why it is a token).
      expect(find.text('You are offline'), findsOneWidget);
      final text = tester.widget<Text>(errorLine);
      expect(text.style!.color, AppColors.light.flashcardGradeError);
      expect(text.style!.fontSize, 14);
      // Between the card and the button row.
      expect(
        rect(tester, errorLine).top,
        greaterThanOrEqualTo(rect(tester, cardFinder).bottom),
      );
      expect(
        rect(tester, errorLine).bottom,
        lessThanOrEqualTo(rect(tester, gotIt).top),
      );
      // Everything is back on.
      expect(gotItButton(tester).onPressed, isNotNull);
      expect(tester.widget<FlashcardAgainButton>(again).onPressed, isNotNull);
      expect(tester.widget<StudyPreviousButton>(previous).onPressed, isNotNull);
      expect(tester.widget<FlashcardFlipCard>(cardFinder).onFlip, isNotNull);
      expect(
        find.descendant(
          of: gotIt,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsNothing,
      );
    });

    // Nothing draws this line (DESIGN_ISSUES #119), so its colour is composed
    // from existing error colours. The quiz's red is #921119 on BOTH canvases,
    // which is 1.7:1 on the dark one: the line was close to invisible there.
    for (final (name, theme, palette) in [
      ('light', AppTheme.light, AppColors.light),
      ('dark', AppTheme.dark, AppColors.dark),
    ]) {
      testWidgets(
        '$name: the failure line reads on the canvas it is drawn on',
        (tester) async {
          final repo = _repo(_deck(10));
          await _open(tester, repo: repo, theme: theme);
          when(
            () => repo.setSelfGrade(any(), any()),
          ).thenAnswer((_) async => throw const UnknownException());

          await tester.tap(gotIt);
          await tester.pumpAndSettle();

          final color = tester.widget<Text>(errorLine).style!.color!;
          expect(color, palette.flashcardGradeError);
          final canvas = Theme.of(
            tester.element(errorLine),
          ).scaffoldBackgroundColor;
          expect(canvas, palette.background);
          expect(_contrast(color, canvas), greaterThanOrEqualTo(4.5));
        },
      );
    }

    testWidgets('tapping again retries, and a success clears the line and '
        'advances', (tester) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);

      var calls = 0;
      when(() => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt)).thenAnswer((
        _,
      ) async {
        if (calls++ == 0) throw const UnknownException();
      });

      await tester.tap(gotIt);
      await tester.pumpAndSettle();
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('1/10'), findsOneWidget);

      await tester.tap(gotIt);
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(errorLine, findsNothing);
      expect(find.text('2/10'), findsOneWidget);
    });

    // A refusal a second try cannot change (openapi.yaml:82-83: on 403
    // account_pending_deletion "do not retry"; insufficient_scope is the same
    // body for every cause). The message stays and the two grade controls stay
    // OFF for that card, so a tap cannot re-send the refused PUT.
    for (final (code, message) in const [
      ('insufficient_scope', 'This content isn\'t part of your course.'),
      ('account_pending_deletion', 'scheduled for deletion'),
    ]) {
      for (final (control, tapGotIt) in const [
        ('Got it', true),
        ('the restart button', false),
      ]) {
        testWidgets('$code on $control: its copy stays and BOTH grade buttons '
            'are off for that card', (tester) async {
          final repo = _repo(_deck(10));
          await _open(tester, repo: repo);
          await gradeGotIt(tester); // card 2, so "<" exists
          when(() => repo.setSelfGrade('c2', any())).thenAnswer(
            (_) async => throw ApiException(status: 403, code: code),
          );

          await tester.tap(tapGotIt ? gotIt : again);
          await tester.pumpAndSettle();

          expect(find.textContaining(message), findsOneWidget);
          expect(find.text('2/10'), findsOneWidget);
          expect(find.text('Front 2'), findsOneWidget);
          // No Retry button of any kind.
          expect(find.text('Retry'), findsNothing);
          // Both grade controls are off, and "Got it" shows its label rather
          // than the busy spinner: it is not in flight, it is refused.
          expect(gotItButton(tester).onPressed, isNull);
          expect(tester.widget<FlashcardAgainButton>(again).onPressed, isNull);
          expect(find.text('Got it'), findsOneWidget);
          expect(
            find.descendant(
              of: gotIt,
              matching: find.byType(CircularProgressIndicator),
            ),
            findsNothing,
          );
          // Tapping the dead controls sends nothing.
          clearInteractions(repo);
          await tester.tap(gotIt);
          await tester.tap(again);
          await tester.pumpAndSettle();
          verifyNever(() => repo.setSelfGrade(any(), any()));

          // The flip, "<" and the ✕ stay live, and turning the card over does
          // not bring the grade buttons back.
          expect(
            tester.widget<FlashcardFlipCard>(cardFinder).onFlip,
            isNotNull,
          );
          expect(
            tester.widget<StudyPreviousButton>(previous).onPressed,
            isNotNull,
          );
          expect(tester.widget<IconButton>(close).onPressed, isNotNull);
          await tester.tap(cardFinder);
          await tester.pumpAndSettle();
          expect(find.text('Back 2'), findsOneWidget);
          expect(find.textContaining(message), findsOneWidget);
          expect(gotItButton(tester).onPressed, isNull);

          // Another card clears the refusal, and its buttons are on again.
          await tester.tap(previous);
          await tester.pumpAndSettle();
          expect(errorLine, findsNothing);
          expect(find.text('1/10'), findsOneWidget);
          expect(gotItButton(tester).onPressed, isNotNull);
          expect(
            tester.widget<FlashcardAgainButton>(again).onPressed,
            isNotNull,
          );
        });
      }
    }

    testWidgets('a 5xx on a grade is a failure a retry can fix: the buttons '
        'come back on', (tester) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      when(() => repo.setSelfGrade('c1', any())).thenAnswer(
        (_) async =>
            throw const ApiException(status: 500, code: 'internal_error'),
      );

      await tester.tap(again);
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('1/10'), findsOneWidget);
      expect(gotItButton(tester).onPressed, isNotNull);
      expect(tester.widget<FlashcardAgainButton>(again).onPressed, isNotNull);

      // And tapping again IS the retry: it sends the PUT again.
      clearInteractions(repo);
      await tester.tap(gotIt);
      await tester.pumpAndSettle();
      verify(() => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt)).called(1);
    });

    testWidgets('the error line leaves with the card it belonged to', (
      tester,
    ) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      await gradeGotIt(tester); // card 2
      when(
        () => repo.setSelfGrade('c2', FlashcardSelfGrade.gotIt),
      ).thenAnswer((_) async => throw const UnknownException());
      await tester.tap(gotIt);
      await tester.pumpAndSettle();
      expect(errorLine, findsOneWidget);

      await tester.tap(previous);
      await tester.pumpAndSettle();

      expect(errorLine, findsNothing);
    });

    testWidgets('"<" goes back with no PUT, and is absent on card 1', (
      tester,
    ) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      expect(previous, findsNothing);
      // With no pill, "Got it" has the whole row.
      expect(rect(tester, gotIt).left, 20);

      await gradeGotIt(tester);
      expect(previous, findsOneWidget);
      clearInteractions(repo);

      await tester.tap(previous);
      await tester.pumpAndSettle();

      verifyNever(() => repo.setSelfGrade(any(), any()));
      expect(find.text('1/10'), findsOneWidget);
      expect(find.text('Front 1'), findsOneWidget);
      expect(previous, findsNothing);
    });

    testWidgets('the LAST card finishes the round then pops back to Setup', (
      tester,
    ) async {
      final repo = _repo(_deck(3), hasMore: true, nextCursor: 'tok-3');
      final h = await _open(tester, repo: repo);
      expect(h.location, _study);
      expect(h.position, isNull);

      await gradeGotIt(tester);
      await gradeGotIt(tester);
      expect(find.text('3/3'), findsOneWidget);
      expect(h.position, isNull, reason: 'the round is not over yet');

      // The final grade is held in flight: nothing has moved.
      final pending = Completer<void>();
      when(
        () => repo.setSelfGrade('c3', FlashcardSelfGrade.gotIt),
      ).thenAnswer((_) => pending.future);
      await tester.tap(gotIt);
      await tester.pump();
      expect(h.location, _study);
      expect(h.position, isNull, reason: 'a grade the server has not taken');

      pending.complete();
      await tester.pumpAndSettle();

      // The position moved to where the server said the next round starts...
      expect(h.position, 'tok-3');
      // ...and the student is back where they came from.
      expect(h.location, _setup);
      expect(find.text('SETUP'), findsOneWidget);
      expect(find.byType(FlashcardStudyScreen), findsNothing);
      verify(() => repo.setSelfGrade('c3', FlashcardSelfGrade.gotIt)).called(1);
    });

    testWidgets('the last card graded "again" ends the round the same way', (
      tester,
    ) async {
      final repo = _repo(_deck(1), hasMore: true, nextCursor: 'tok-1');
      final h = await _open(tester, repo: repo);

      await tester.tap(again);
      await tester.pumpAndSettle();

      verify(() => repo.setSelfGrade('c1', FlashcardSelfGrade.again)).called(1);
      expect(h.position, 'tok-1');
      expect(h.location, _setup);
    });

    testWidgets('a failed final grade does not end the round', (tester) async {
      final repo = _repo(_deck(1), hasMore: true, nextCursor: 'tok-1');
      final h = await _open(tester, repo: repo);
      when(
        () => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt),
      ).thenAnswer((_) async => throw const UnknownException());

      await tester.tap(gotIt);
      await tester.pumpAndSettle();

      expect(h.location, _study);
      expect(h.position, isNull);
      expect(errorLine, findsOneWidget);
    });

    testWidgets('a round with no more pages wraps to the start of the deck', (
      tester,
    ) async {
      final repo = _repo(_deck(2));
      final h = await _open(tester, repo: repo);
      // Seed a stale position so a wrap is observable.
      h.container
          .read(flashcardRoundPositionProvider(_lecture).notifier)
          .moveTo('stale');
      await gradeGotIt(tester);
      await gradeGotIt(tester);

      expect(h.position, isNull);
      expect(h.location, _setup);
    });

    testWidgets('the ✕ leaves at once: no dialog, no PUT', (tester) async {
      final repo = _repo(_deck(10));
      final h = await _open(tester, repo: repo);
      await gradeGotIt(tester);
      clearInteractions(repo);

      await tester.tap(close);
      await tester.pumpAndSettle();

      expect(h.location, _setup);
      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => repo.setSelfGrade(any(), any()));
      // The position was not moved by leaving early.
      expect(h.position, isNull);
    });

    testWidgets('a route with nothing under it leaves for the subject, not '
        'a crash', (tester) async {
      final h = await _open(tester, repo: _repo(_deck(10)), standalone: true);
      expect(h.location, '/study');

      await tester.tap(close);
      await tester.pumpAndSettle();

      expect(h.location, '/learn/subject/sub-1');
      expect(find.text('SUBJECT'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the last card on a route with nothing under it does the '
        'same', (tester) async {
      final h = await _open(
        tester,
        repo: _repo(_deck(1), hasMore: true, nextCursor: 'tok-1'),
        standalone: true,
      );

      await tester.tap(gotIt);
      await tester.pumpAndSettle();

      expect(h.location, '/learn/subject/sub-1');
    });

    testWidgets('leaving while a grade is out does not throw', (tester) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      final pending = Completer<void>();
      when(
        () => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt),
      ).thenAnswer((_) => pending.future);
      await tester.tap(gotIt);
      await tester.pump();

      await tester.tap(close);
      await tester.pumpAndSettle();
      pending.complete();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // A popped route stays mounted for its whole ~300 ms reverse animation, so
    // a FINAL grade that lands mid-pop used to leave a second time and pop the
    // screen under this one as well: the student landed on the Lectures list,
    // not Setup. It needs a real parent under Setup to show (`realStack`); with
    // Setup as the root route the second pop takes the "nothing to pop" branch
    // and the bug hides.
    for (final (name, leave)
        in <(String, Future<void> Function(WidgetTester, _Harness))>[
          ('the ✕', (tester, h) => tester.tap(close)),
          ('system Back', (tester, h) async => h.router.pop()),
        ]) {
      testWidgets('leaving by $name while the last grade is out, then the PUT '
          'lands mid-pop: back at Setup, not one screen further', (
        tester,
      ) async {
        final repo = _repo(_deck(1), hasMore: true, nextCursor: 'tok-1');
        final h = await _open(tester, repo: repo, realStack: true);
        expect(h.location, _realStudy);
        final pending = Completer<void>();
        when(
          () => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt),
        ).thenAnswer((_) => pending.future);
        await tester.tap(gotIt);
        await tester.pump();

        await leave(tester, h);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        // Mid-pop: the route is going, but it is still mounted.
        expect(find.byType(FlashcardStudyScreen), findsOneWidget);
        pending.complete();
        await tester.pump();
        await tester.pumpAndSettle();

        expect(h.location, _realSetup);
        expect(find.text('SETUP'), findsOneWidget);
        expect(find.text('LECTURES'), findsNothing);
        expect(find.byType(FlashcardStudyScreen), findsNothing);
        // The grade WAS saved, so the round is over all the same.
        expect(h.position, 'tok-1');
        verify(
          () => repo.setSelfGrade('c1', FlashcardSelfGrade.gotIt),
        ).called(1);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('the last card on the real stack still pops back to Setup', (
      tester,
    ) async {
      final repo = _repo(_deck(1), hasMore: true, nextCursor: 'tok-1');
      final h = await _open(tester, repo: repo, realStack: true);

      await tester.tap(gotIt);
      await tester.pumpAndSettle();

      expect(h.location, _realSetup);
      expect(find.text('SETUP'), findsOneWidget);
      expect(find.text('LECTURES'), findsNothing);
      expect(h.position, 'tok-1');
    });
  });

  group('the states', () {
    testWidgets('403 flashcard_subscription_required: the owner\'s line and '
        'no buttons', (tester) async {
      final repo = _MockRepo();
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer(
        (_) async => throw const ApiException(
          status: 403,
          code: 'flashcard_subscription_required',
        ),
      );
      await _open(tester, repo: repo);

      expect(
        find.text('You\'ve used this week\'s free flashcards.'),
        findsOneWidget,
      );
      // Nothing else is drawn beside the owner's line that sells: every string
      // on screen, whole words, any case (a Text under the message, or a
      // non-Material tappable, would slip past the button checks below).
      expect(
        drawnTextWithoutPurchaseWording(tester),
        contains('You\'ve used this week\'s free flashcards.'),
      );
      // No button of any kind in the body: no Retry, no upgrade, no checkout.
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(TextButton), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Retry'), findsNothing);
      // The one way out is the header's ✕.
      expect(find.byType(IconButton), findsOneWidget);
      expect(close, findsOneWidget);
      // Never the quiz's limit card, nor any sheet.
      expect(find.byType(LimitSheet), findsNothing);
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.byType(Dialog), findsNothing);
      // No counter for cards that never arrived.
      expect(find.textContaining(RegExp(r'\d+/\d+')), findsNothing);
      // Requested once: nothing retries it behind the student's back.
      verify(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).called(1);
    });

    testWidgets('AR: the same state in Arabic', (tester) async {
      final repo = _MockRepo();
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer(
        (_) async => throw const ApiException(
          status: 403,
          code: 'flashcard_subscription_required',
        ),
      );
      await _open(tester, repo: repo, locale: 'ar');

      expect(
        find.text('لقد استخدمت البطاقات المجانية لهذا الأسبوع.'),
        findsOneWidget,
      );
      expect(
        drawnTextWithoutPurchaseWording(tester),
        contains('لقد استخدمت البطاقات المجانية لهذا الأسبوع.'),
      );
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(LimitSheet), findsNothing);
    });

    testWidgets('insufficient_scope: its copy, no Retry', (tester) async {
      final repo = _MockRepo();
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer(
        (_) async =>
            throw const ApiException(status: 403, code: 'insufficient_scope'),
      );
      await _open(tester, repo: repo);

      expect(
        find.text('This content isn\'t part of your course.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('account_pending_deletion: its copy, no Retry', (tester) async {
      final repo = _MockRepo();
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer(
        (_) async => throw const ApiException(
          status: 403,
          code: 'account_pending_deletion',
        ),
      );
      await _open(tester, repo: repo);

      expect(find.textContaining('scheduled for deletion'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('offline: the offline line and a Retry that refetches', (
      tester,
    ) async {
      final repo = _MockRepo();
      var calls = 0;
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async {
        if (calls++ == 0) throw const OfflineException();
        return _page(_deck(10));
      });
      when(() => repo.setSelfGrade(any(), any())).thenAnswer((_) async {});
      await _open(tester, repo: repo);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(calls, 1);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(calls, 2);
      expect(find.text('1/10'), findsOneWidget);
      expect(find.text('Front 1'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('a generic failure has Retry too', (tester) async {
      final repo = _MockRepo();
      var calls = 0;
      when(
        () => repo.getFlashcardsForLecture(
          _lecture,
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async {
        if (calls++ == 0) throw const UnknownException();
        return _page(_deck(2));
      });
      await _open(tester, repo: repo);

      expect(find.text('Something went wrong'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('1/2'), findsOneWidget);
    });

    testWidgets('an empty lecture: "Nothing here yet", no Retry', (
      tester,
    ) async {
      await _open(tester, repo: _repo([]));

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
      expect(gotIt, findsNothing);
      expect(find.textContaining(RegExp(r'\d+/\d+')), findsNothing);
      // The way out is still there.
      expect(close, findsOneWidget);
    });

    testWidgets('offline with a round on screen: the banner, and no PUT to '
        'send', (tester) async {
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo, online: false);

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.text('You are offline'), findsOneWidget);
      // Grading is a PUT, so it is off; the rest of the study still works.
      expect(gotItButton(tester).onPressed, isNull);
      expect(tester.widget<FlashcardAgainButton>(again).onPressed, isNull);
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      expect(find.text('Back 1'), findsOneWidget);
      verifyNever(() => repo.setSelfGrade(any(), any()));
    });

    testWidgets('online: no banner, and the buttons are on', (tester) async {
      await _open(tester, repo: _repo(_deck(10)));

      expect(find.byType(OfflineBanner), findsNothing);
      expect(gotItButton(tester).onPressed, isNotNull);
    });
  });

  group('Arabic', () {
    testWidgets('the title, the button and the restart label are Arabic', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _open(tester, repo: _repo(_deck(10)), locale: 'ar');

      expect(find.text('فلاش كارد'), findsOneWidget);
      expect(find.text('فهمت'), findsOneWidget);
      expect(
        tester.getSemantics(again),
        isSemantics(isButton: true, label: 'مرة أخرى'),
      );
      expect(find.text('1/10'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the restart button is at the LEFT, 20 from the edge', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)), locale: 'ar');

      final disc = discRect(tester);
      expect(disc.left, 20);
      expect(disc.size, const Size(38, 38));
      expect(rect(tester, again).center, disc.center);
      // The ✕ leads on the right in RTL.
      expect(rect(tester, close).right, 402 - (16 - 9));
    });

    testWidgets('the card and row keep their margins; the pill leads on the '
        'right', (tester) async {
      await _open(tester, repo: _repo(_deck(10)), locale: 'ar');
      await gradeGotIt(tester);

      final card = rect(tester, cardFinder);
      expect(card.left, 20);
      expect(card.right, 402 - 20);
      expect(card.height, moreOrLessEquals(454, epsilon: 0.001));
      // Directional row: the pill is on the right, "Got it" fills the rest.
      final pill = rect(tester, previous);
      final row = rect(tester, gotIt);
      expect(pill.right, 402 - 20);
      expect(row.right, 402 - 20 - 79 - 15);
      expect(row.left, 20);
    });

    testWidgets('the question and the answer are centred in Arabic', (
      tester,
    ) async {
      await _open(
        tester,
        repo: _repo([
          const FlashcardCard(
            id: 'c1',
            front: 'ما هو الغشاء؟',
            back: 'الصلبة',
            imageUrl: null,
            selfGrade: null,
          ),
        ]),
        locale: 'ar',
      );
      final card = rect(tester, cardFinder);
      expect(
        tester.getCenter(find.text('ما هو الغشاء؟')).dx,
        moreOrLessEquals(card.center.dx, epsilon: 0.01),
      );
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      expect(
        tester.getCenter(find.text('الصلبة')).dx,
        moreOrLessEquals(card.center.dx, epsilon: 0.01),
      );
    });

    // BUG-020, on the screen: the mock deck's own texts, in both apps. The
    // English question keeps its "?" at the end of its line and the Arabic
    // answer its full stop, whichever language the app is in.
    for (final locale in ['ar', 'en']) {
      testWidgets('$locale: an English question and an Arabic answer each '
          'keep their own direction', (tester) async {
        const front = 'Which plane divides the body into right and left parts?';
        const back =
            'وقوف الجسم منتصبًا مع النظر إلى الأمام، والذراعان بجانب الجسم، '
            'وراحتا اليدين إلى الأمام.';
        await _open(
          tester,
          repo: _repo([
            const FlashcardCard(
              id: 'c1',
              front: front,
              back: back,
              imageUrl: null,
              selfGrade: null,
            ),
          ]),
          locale: locale,
        );
        expect(
          expectReadingOrder(
            tester.renderObject<RenderParagraph>(find.text(front)),
            front,
            TextDirection.ltr,
          ),
          greaterThan(1),
        );

        await tester.tap(cardFinder);
        await tester.pumpAndSettle();
        expect(
          expectReadingOrder(
            tester.renderObject<RenderParagraph>(find.text(back)),
            back,
            TextDirection.rtl,
          ),
          greaterThan(1),
        );
      });
    }
  });

  group('dark', () {
    testWidgets('the card stays #FCFBF9 and the disc is the dark token', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)), theme: AppTheme.dark);

      final surface = tester.widget<ElevatedSurface>(
        find.descendant(of: cardFinder, matching: find.byType(ElevatedSurface)),
      );
      expect(surface.color, const Color(0xFFFCFBF9));
      expect(surface.shadows, AppElevation.dark.flashcardCardShadows);

      final disc = tester.widget<ElevatedSurface>(
        find.descendant(of: again, matching: find.byType(ElevatedSurface)),
      );
      expect(disc.color, AppColors.dark.flashcardAgainFill);
      expect(disc.color, isNot(AppColors.light.flashcardAgainFill));
      // No shadow on the disc: the frame draws none.
      expect(disc.shadows, isEmpty);
      expect(disc.glass, isNull);
    });

    testWidgets('light: the disc is the frame\'s green with a cream glyph', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)));

      final disc = tester.widget<ElevatedSurface>(
        find.descendant(of: again, matching: find.byType(ElevatedSurface)),
      );
      expect(disc.color, const Color(0xFF4B675E));
      expect(disc.shape, const CircleBorder());
      final glyph = tester.widget<SvgPicture>(
        find.descendant(of: again, matching: find.byType(SvgPicture)),
      );
      expect(
        (glyph.bytesLoader as SvgAssetLoader).assetName,
        'assets/icons/flashcard_again.svg',
      );
      expect(
        glyph.colorFilter,
        ColorFilter.mode(AppColors.light.flashcardAgainGlyph, BlendMode.srcIn),
      );
    });

    testWidgets('the card text stays the green ink on the dark canvas', (
      tester,
    ) async {
      await _open(tester, repo: _repo(_deck(10)), theme: AppTheme.dark);

      expect(
        tester.widget<Text>(find.text('Front 1')).style!.color,
        const Color(0xFF384F47),
      );
    });
  });

  group('semantics', () {
    testWidgets('the card is ONE button with the visible text', (tester) async {
      final handle = tester.ensureSemantics();
      await _open(tester, repo: _repo(_deck(10)));

      expect(
        tester.getSemantics(cardFinder),
        isSemantics(
          isButton: true,
          label: 'Front 1',
          hasTapAction: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );
      expect(find.bySemanticsLabel('Front 1'), findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(cardFinder),
        isSemantics(isButton: true, label: 'Back 1'),
      );
      expect(find.bySemanticsLabel('Back 1'), findsOneWidget);
      expect(find.bySemanticsLabel('Front 1'), findsNothing);
      handle.dispose();
    });

    testWidgets('the restart button is a labelled button; its glyph is not a '
        'node', (tester) async {
      final handle = tester.ensureSemantics();
      await _open(tester, repo: _repo(_deck(10)));

      expect(
        tester.getSemantics(again),
        isSemantics(
          isButton: true,
          label: 'Again',
          hasTapAction: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );
      expect(find.bySemanticsLabel('Again'), findsOneWidget);

      // Its glyph is not a node of its own: the button has no child nodes and
      // exactly one node carries the name.
      expect(tester.getSemantics(again).childrenCount, 0);
      expect(find.semantics.byLabel('Again').evaluate(), hasLength(1));
      // And the picture opts out on its own account, whatever the wrapper
      // above it does: drop that and TalkBack would read an unnamed image.
      final glyph = tester.widget<SvgPicture>(
        find.descendant(of: again, matching: find.byType(SvgPicture)),
      );
      expect(glyph.excludeFromSemantics, isTrue);
      handle.dispose();
    });

    testWidgets('while a grade is out the card and restart read as disabled', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      final pending = Completer<void>();
      when(
        () => repo.setSelfGrade(any(), any()),
      ).thenAnswer((_) => pending.future);
      await tester.tap(gotIt);
      await tester.pump();

      expect(
        tester.getSemantics(cardFinder),
        isSemantics(isButton: true, isEnabled: false, hasEnabledState: true),
      );
      expect(
        tester.getSemantics(again),
        isSemantics(isButton: true, isEnabled: false, hasEnabledState: true),
      );

      pending.complete();
      await tester.pumpAndSettle();
      handle.dispose();
    });

    // The spinner REPLACES the label while a grade is out, so it has to carry
    // it: without, TalkBack rests on an unnamed disabled button.
    for (final (name, locale, label) in const [
      ('EN', 'en', 'Got it'),
      ('AR', 'ar', 'فهمت'),
    ]) {
      testWidgets('$name: while a grade is out "Got it" keeps its name', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        final repo = _repo(_deck(10));
        await _open(tester, repo: repo, locale: locale);
        expect(
          tester.getSemantics(gotIt),
          isSemantics(
            isButton: true,
            label: label,
            isEnabled: true,
            hasEnabledState: true,
          ),
        );
        final pending = Completer<void>();
        when(
          () => repo.setSelfGrade(any(), any()),
        ).thenAnswer((_) => pending.future);
        await tester.tap(gotIt);
        await tester.pump();

        // Busy: the spinner is there, the visible label is not...
        expect(
          find.descendant(
            of: gotIt,
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget,
        );
        expect(find.text(label), findsNothing);
        // ...and the button still has its name, and reads as disabled.
        expect(
          tester.getSemantics(gotIt),
          isSemantics(
            isButton: true,
            label: label,
            isEnabled: false,
            hasEnabledState: true,
          ),
        );

        pending.complete();
        await tester.pumpAndSettle();
        handle.dispose();
      });
    }

    testWidgets('a screen reader can flip the card', (tester) async {
      final handle = tester.ensureSemantics();
      await _open(tester, repo: _repo(_deck(10)));

      tester.semantics.tap(find.semantics.byLabel('Front 1'));
      await tester.pumpAndSettle();

      expect(find.text('Back 1'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the error line is announced', (tester) async {
      final handle = tester.ensureSemantics();
      final repo = _repo(_deck(10));
      await _open(tester, repo: repo);
      when(
        () => repo.setSelfGrade(any(), any()),
      ).thenAnswer((_) async => throw const UnknownException());
      await tester.tap(gotIt);
      await tester.pumpAndSettle();

      final node = tester.getSemantics(errorLine);
      expect(node.label, 'Something went wrong');
      expect(node.flagsCollection.isLiveRegion, isTrue);
      handle.dispose();
    });
  });

  group('what this screen never does', () {
    testWidgets('never turns screen protection on (or off) — owner ruling', (
      tester,
    ) async {
      final h = await _open(tester, repo: _repo(_deck(3)));
      await gradeGotIt(tester);
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();
      await tester.tap(previous);
      await tester.pumpAndSettle();
      await gradeGotIt(tester);
      await gradeGotIt(tester);
      await gradeGotIt(tester); // the last card: the screen pops
      await tester.pumpAndSettle();

      expect(h.location, _setup);
      expect(h.protection.enables, 0);
      expect(h.protection.disables, 0);
    });

    for (final (name, locale) in const [('EN', 'en'), ('AR', 'ar')]) {
      testWidgets('$name: a round draws no price, upgrade or checkout wording, '
          'on either face', (tester) async {
        await _open(tester, repo: _repo(_deck(10)), locale: locale);

        // Every string on screen, whole words in any case, front and back.
        expect(drawnTextWithoutPurchaseWording(tester), contains('Front 1'));
        await tester.tap(cardFinder);
        await tester.pumpAndSettle();
        expect(drawnTextWithoutPurchaseWording(tester), contains('Back 1'));
        expect(find.byType(LimitSheet), findsNothing);
      });
    }

    test(
      'the purchase scan can fail: it flags the words and only the words',
      () {
        // Flagged: the listed words, whole, in any case, with Arabic prefixes.
        for (final text in const [
          'Upgrade to keep studying',
          'Only 50 EGP a month',
          'Price: 5',
          'Go PRO',
          'Pay now',
          'You have paid',
          'Get Premium',
          'Subscribe today',
          'Your subscription',
          'Buy it, purchase it, checkout',
          'A better plan',
          'Only £5',
          'اشترك الآن',
          'اشتراك مميز',
          'للاشتراك',
          'السعر 50 جنيه',
          'بريميوم',
          'ترقية الحساب',
          'ادفع الآن',
          'شراء',
          'مدفوع',
        ]) {
          expect(_purchaseWords(text), isNotEmpty, reason: text);
        }
        // Not flagged: ordinary copy, including words that merely CONTAIN one.
        for (final text in const [
          'You\'ve used this week\'s free flashcards.',
          'Please pronounce it',
          'The approach to a planet',
          'Something went wrong',
          'Flash cards',
          'Front 1',
          'لقد استخدمت البطاقات المجانية لهذا الأسبوع.',
          'فلاش كارد',
          'فهمت',
        ]) {
          expect(_purchaseWords(text), isEmpty, reason: text);
        }
      },
    );

    testWidgets('has no bookmark, share or AI glyph', (tester) async {
      await _open(tester, repo: _repo(_deck(10)));

      // The header's trailing cluster is absent: the ✕ is the only icon button.
      expect(find.byType(IconButton), findsOneWidget);
      // ...and the frame's glyphs are SVGs, so Material icons are not the whole
      // story: the header holds exactly one picture (the ✕), and nothing else
      // in it can be tapped.
      final pictures = find.descendant(
        of: header,
        matching: find.byType(SvgPicture),
      );
      expect(pictures, findsOneWidget);
      expect(find.descendant(of: close, matching: pictures), findsOneWidget);
      expect(
        find.descendant(of: header, matching: find.byType(Icon)),
        findsNothing,
      );
      expect(
        find.descendant(of: header, matching: find.byType(IconButton)),
        findsOneWidget,
      );
      // Nothing tappable in the header is outside the ✕'s own button.
      int tappables(Finder scope) => find
          .descendant(
            of: scope,
            matching: find.byWidgetPredicate(
              (w) => w is GestureDetector || w is InkResponse,
            ),
          )
          .evaluate()
          .length;
      expect(tappables(close), greaterThan(0));
      expect(tappables(header), tappables(close));
    });
  });
}
