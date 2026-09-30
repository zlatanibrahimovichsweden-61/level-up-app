import 'package:flutter/foundation.dart';

import '../../../core/network/exceptions.dart';
import '../../../l10n/app_localizations.dart';

/// What a flashcards failure shows: the sentence, and whether the student is
/// offered a Retry.
///
/// A value, not a widget, so a screen can render it in its own chrome. Today
/// only the study screen does. The Lectures tab fetches no flashcards (it reads
/// `Lecture.flashcardCount` from the subject tree), and Setup shows
/// [AppLocalizations.errorInsufficientScope] directly for a lecture that is not
/// in the tree, so a change to an outcome below reaches the study screen alone.
@immutable
class FlashcardsErrorCopy {
  const FlashcardsErrorCopy({required this.message, required this.canRetry});

  /// Localised copy. The server's `title`/`detail` are developer-facing English
  /// and are never rendered — only the stable `code` is mapped, here.
  final String message;

  /// False where a retry can only fail the same way again. The message still
  /// shows; only the button is withheld, as in `_RetryRow` on the quiz screen.
  final bool canRetry;

  @override
  bool operator ==(Object other) =>
      other is FlashcardsErrorCopy &&
      other.message == message &&
      other.canRetry == canRetry;

  @override
  int get hashCode => Object.hash(message, canRetry);

  @override
  String toString() => 'FlashcardsErrorCopy($message, canRetry: $canRetry)';
}

/// The ONE place a flashcards error becomes copy a student reads — for
/// `GET /flashcards/lectures/{lectureId}/cards` (`getFlashcardsForLecture`) and
/// `PUT /flashcards/cards/{flashcardId}/self-grade` (`setFlashcardSelfGrade`).
///
/// Five outcomes, in the order they are matched:
///
/// - `403 flashcard_subscription_required` → [AppLocalizations.flashcardPreviewUsedUp],
///   **no Retry**: the free weekly preview is used up, so the identical request
///   403s again. It is NOT the quiz's `weekly_question_limit_reached` and never
///   opens the `LimitSheet`; the app is purchase-silent (adr-049 §3), so the
///   line carries no price, no upgrade link and no button. Only
///   `getFlashcardsForLecture` can return it — the grade route deliberately
///   does not (`openapi.yaml:1948`).
/// - `403 insufficient_scope` → [AppLocalizations.errorInsufficientScope],
///   **no Retry**. The body is byte-identical for four causes — School track,
///   another cohort's lecture, a term not released for the cohort, a UUID that
///   names nothing — and the contract says they are permanently
///   indistinguishable: *do not try to tell them apart*
///   (`openapi.yaml:1883-1889`). So this maps the code and nothing finer, and
///   must not be split by lecture, track or cohort.
/// - `403 account_pending_deletion` → [AppLocalizations.accountPendingDeletion],
///   **no Retry**: the contract says "do not log the user out and do not retry"
///   (`openapi.yaml:82-83`). Matched through [isAccountPendingDeletion], the
///   predicate every other error-copy funnel uses.
/// - Offline or a transport failure ([isOffline]) → [AppLocalizations.offline],
///   Retry: the state is transient.
/// - Anything else → [AppLocalizations.genericError], Retry, rather than
///   leaking a raw code.
///
/// A screen that draws offline as its own view (icon, banner) should ask
/// [isOffline] itself and use this for the sentence and the button.
FlashcardsErrorCopy flashcardsErrorCopy(AppLocalizations l10n, Object? error) =>
    switch (error) {
      ApiException(code: 'flashcard_subscription_required') =>
        FlashcardsErrorCopy(
          message: l10n.flashcardPreviewUsedUp,
          canRetry: false,
        ),
      ApiException(code: 'insufficient_scope') => FlashcardsErrorCopy(
        message: l10n.errorInsufficientScope,
        canRetry: false,
      ),
      _ when isAccountPendingDeletion(error) => FlashcardsErrorCopy(
        message: l10n.accountPendingDeletion,
        canRetry: false,
      ),
      _ when isOffline(error) => FlashcardsErrorCopy(
        message: l10n.offline,
        canRetry: true,
      ),
      _ => FlashcardsErrorCopy(message: l10n.genericError, canRetry: true),
    };
