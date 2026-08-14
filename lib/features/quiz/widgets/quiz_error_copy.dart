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
  _ => l10n.genericError,
};

/// The two codes that open the paywall sheet instead of showing an inline
/// error. Both are 403s on `POST /quizzes`; the sheet's copy differs by which.
bool opensLimitSheet(Object? error) =>
    error is ApiException &&
    (error.code == 'weekly_question_limit_reached' ||
        error.code == 'subscription_required');
