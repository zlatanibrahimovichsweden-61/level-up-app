/// What the AI EXPLANATION panel is showing for one question.
///
/// Distinct from [ExplanationResult] (`explanation_result.dart`), which is what
/// a single HTTP call returned. This is the accumulated UI position across a
/// poll that may take several calls: `Idle → Pending → Loaded | Failed`.
///
/// Kept per question in the session, so going back to an earlier question shows
/// the explanation already fetched instead of starting the poll again.
library;

sealed class ExplanationState {
  const ExplanationState();
}

/// Never requested. The panel is collapsed — the contract charges for
/// generation, so nothing is fetched until the student asks.
class ExplanationIdle extends ExplanationState {
  const ExplanationIdle();
}

/// Requested, and the server is still generating (`202`). The panel shows a
/// generating state while the poll runs; the Next button stays live throughout.
class ExplanationPending extends ExplanationState {
  const ExplanationPending();
}

class ExplanationLoaded extends ExplanationState {
  const ExplanationLoaded(this.text);

  final String text;
}

/// [code] is an error-codes.md code (or `explanation_timeout` when the poll gave
/// up), resolved to copy at the widget. Rendered as "not available" rather than
/// as a failure: an explanation is an extra, and losing it must never look like
/// the quiz broke.
class ExplanationFailed extends ExplanationState {
  const ExplanationFailed(this.code);

  final String code;
}
