import '../../../core/network/exceptions.dart';
import '../../../l10n/app_localizations.dart';

/// The ONE place a quiz error code becomes copy a student reads.
///
/// The server's `title`/`detail` are documented as developer-facing English and
/// are never rendered — only the stable `code` is mapped, here, to localized
/// strings in both ARBs.
///
/// Every code the four quiz endpoints can return is listed. Anything else falls
/// through to the shared generic message rather than leaking a raw code.
String quizErrorMessage(
  AppLocalizations l10n,
  Object? error,
) => switch (error) {
  OfflineException() || NetworkException() => l10n.offline,
  ApiException(code: 'not_enough_questions') => l10n.errorNotEnoughQuestions,
  ApiException(code: 'weekly_question_limit_reached') =>
    l10n.errorWeeklyQuestionLimitReached,
  ApiException(code: 'subscription_required') => l10n.errorSubscriptionRequired,
  ApiException(code: 'quiz_already_finished') => l10n.errorQuizAlreadyFinished,
  ApiException(code: 'insufficient_scope') => l10n.errorInsufficientScope,
  // adr-114. None of the four quiz endpoints is on the deletion allowlist, so
  // all four can answer it — but only `getExplanation` DECLARES it
  // (`openapi.yaml:1629`, `:1656`). `createQuiz`, `submitAnswer` and
  // `finishQuiz` do not, which is why the code was absent from a list that
  // otherwise names every code the quiz can see. What makes it reachable on
  // all four is the contract's default-deny rule, not a response block. See
  // [isAccountPendingDeletion].
  ApiException() when isAccountPendingDeletion(error) =>
    l10n.accountPendingDeletion,
  _ => l10n.genericError,
};

/// Whether this failure must be shown WITHOUT a Retry button.
///
/// Only `account_pending_deletion` qualifies today: the contract says outright
/// "do not log the user out and do not retry" (`openapi.yaml:82-83`), and
/// nothing the student taps clears it — only cancelling the deletion does.
///
/// Deliberately separate from [opensLimitSheet]: that one routes a failure to a
/// different SURFACE, this one removes an affordance from the surface already
/// showing. A single predicate covering both would conflate "show it elsewhere"
/// with "show it without a button".
bool suppressesRetry(Object? error) => isAccountPendingDeletion(error);

/// The two codes that open the paywall sheet instead of showing an inline
/// error. Both are 403s on `POST /quizzes`; the sheet's copy differs by which.
bool opensLimitSheet(Object? error) =>
    error is ApiException &&
    (error.code == 'weekly_question_limit_reached' ||
        error.code == 'subscription_required');
