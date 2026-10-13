import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/widgets/school_picker_field.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

/// The school picker sheet pages by scrolling, and a page that fails must wait
/// for its own Retry button: [SchoolSearchNotifier.loadMore] promises "never a
/// silent retry", and the scroll listener used to break that for every kind of
/// failure - each tick near the bottom sent the failed request again, to an
/// unauthenticated `/reference/*` route that has a per-IP limit.
///
/// Requests are counted at the repository, so the test sees what the server
/// would see.
void main() {
  late MockReferenceRepository reference;
  var secondPageAsks = 0;
  var thirdPageAsks = 0;

  setUp(() {
    reference = MockReferenceRepository();
    secondPageAsks = 0;
    thirdPageAsks = 0;
  });

  /// A second page that fails on its first ask and is answered on the next
  /// (the sheet's Retry), followed by a third and last page.
  void givenRecoveringSecondPage(Object error) {
    when(
      () => reference.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: null,
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => CursorPage<NamedRef>(
        items: [
          for (var n = 1; n <= 20; n++)
            NamedRef(id: 'school-$n', nameAr: 'مدرسة $n', nameEn: 'School $n'),
        ],
        hasMore: true,
        nextCursor: 'cursor-2',
      ),
    );
    when(
      () => reference.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: 'cursor-2',
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async {
      secondPageAsks++;
      if (secondPageAsks == 1) throw error;
      return CursorPage<NamedRef>(
        items: [
          for (var n = 21; n <= 40; n++)
            NamedRef(id: 'school-$n', nameAr: 'مدرسة $n', nameEn: 'School $n'),
        ],
        hasMore: true,
        nextCursor: 'cursor-3',
      );
    });
    when(
      () => reference.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: 'cursor-3',
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async {
      thirdPageAsks++;
      return const CursorPage<NamedRef>(
        items: [NamedRef(id: 'school-41', nameAr: 'مدرسة 41', nameEn: 'S 41')],
        hasMore: false,
      );
    });
  }

  void givenFailingSecondPage(Object error) {
    when(
      () => reference.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: null,
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => CursorPage<NamedRef>(
        items: [
          for (var n = 1; n <= 20; n++)
            NamedRef(id: 'school-$n', nameAr: 'مدرسة $n', nameEn: 'School $n'),
        ],
        hasMore: true,
        nextCursor: 'cursor-2',
      ),
    );
    when(
      () => reference.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: 'cursor-2',
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async {
      secondPageAsks++;
      throw error;
    });
  }

  Future<void> openSheet(WidgetTester tester, {String locale = 'en'}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [referenceRepositoryProvider.overrideWithValue(reference)],
        child: MaterialApp(
          locale: Locale(locale),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SchoolPickerField(
              governorateId: 'gov-cairo',
              cityId: 'city-nasr',
              selected: null,
              onSelected: (_) {},
              skipped: false,
              onSkip: () {},
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('field-schoolId')));
    await tester.pumpAndSettle();
  }

  /// To the end of the sheet's list, the way a student gets there.
  Future<void> scrollToFooter(WidgetTester tester) async {
    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pumpAndSettle();
  }

  final failures = <String, Object>{
    'network error': const NetworkException(),
    'server error': const ApiException(status: 500, code: 'internal_error'),
    'rate limited': const RateLimitedException(),
  };

  for (final MapEntry(key: name, value: error) in failures.entries) {
    for (final locale in ['en', 'ar']) {
      testWidgets(
        '$name · $locale · one failed append is one request; scrolling asks no '
        'more, only Retry does',
        (tester) async {
          givenFailingSecondPage(error);
          await openSheet(tester, locale: locale);
          final l10n = await AppLocalizations.delegate.load(Locale(locale));

          await scrollToFooter(tester);
          expect(find.text(l10n.retry), findsOneWidget);
          expect(secondPageAsks, 1);

          // Up and down again, twice over: the button is the only way to ask
          // again, so none of this reaches the server.
          await tester.drag(find.byType(ListView), const Offset(0, 3000));
          await tester.pumpAndSettle();
          await scrollToFooter(tester);
          await scrollToFooter(tester);
          expect(secondPageAsks, 1);
          expect(find.text(l10n.retry), findsOneWidget);

          // The button asks exactly once, and its failure waits again.
          await tester.tap(find.text(l10n.retry));
          await tester.pumpAndSettle();
          expect(secondPageAsks, 2);
          await scrollToFooter(tester);
          expect(secondPageAsks, 2);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  // The other half of "only Retry asks again": once a Retry has been answered
  // the failure is over, and paging by scroll must work again. A stale
  // `appendError` would stall the sheet for good, and the tests above (which
  // only ever see failures) would stay green.
  for (final MapEntry(key: name, value: error) in failures.entries) {
    for (final locale in ['en', 'ar']) {
      testWidgets(
        '$name · $locale · after a Retry that succeeds, scrolling pages again',
        (tester) async {
          givenRecoveringSecondPage(error);
          await openSheet(tester, locale: locale);
          final l10n = await AppLocalizations.delegate.load(Locale(locale));

          await scrollToFooter(tester);
          expect(find.text(l10n.retry), findsOneWidget);
          expect(secondPageAsks, 1);

          // The button's ask is answered: the failure is gone, and nothing but
          // the student's scroll has asked for the next page.
          await tester.tap(find.text(l10n.retry));
          await tester.pumpAndSettle();
          expect(secondPageAsks, 2);
          expect(find.text(l10n.retry), findsNothing);
          expect(thirdPageAsks, 0);

          // Now a scroll to the new end is paging again - exactly once.
          await scrollToFooter(tester);
          expect(thirdPageAsks, 1);
          expect(secondPageAsks, 2);
          expect(
            find.text(locale == 'en' ? 'S 41' : 'مدرسة 41'),
            findsOneWidget,
          );
          expect(find.text(l10n.retry), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('a page that succeeds still appends as the end comes into view', (
    tester,
  ) async {
    // The guard must be narrow: paging itself is untouched.
    when(
      () => reference.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: null,
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => CursorPage<NamedRef>(
        items: [
          for (var n = 1; n <= 20; n++)
            NamedRef(id: 'school-$n', nameAr: 'مدرسة $n', nameEn: 'School $n'),
        ],
        hasMore: true,
        nextCursor: 'cursor-2',
      ),
    );
    when(
      () => reference.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: 'cursor-2',
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async {
      secondPageAsks++;
      return const CursorPage<NamedRef>(
        items: [NamedRef(id: 'school-21', nameAr: 'مدرسة ٢١', nameEn: 'S 21')],
        hasMore: false,
      );
    });
    await openSheet(tester);

    await scrollToFooter(tester);

    expect(secondPageAsks, 1);
    expect(find.text('S 21'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });
}
