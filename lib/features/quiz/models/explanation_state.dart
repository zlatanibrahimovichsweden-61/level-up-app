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

/// `403 subscription_required`: explanations are a paid feature and this
/// student has no base subscription for the question's track.
///
/// Its own state, not an [ExplanationFailed], because the contract gives it
/// its own UX: "Show this popup, using this approved copy verbatim". The
/// screen opens that popup on the transition into this state, once per tap;
/// the panel keeps the "Show explanation" button, which the contract renders
/// from `explanationAvailable` alone; and asking again asks the server again,
/// since the student may have subscribed on the website meanwhile. API→UI
/// Wave 12, owner ruling 2026-09-26.
class ExplanationSubscriptionRequired extends ExplanationState {
  const ExplanationSubscriptionRequired();
}

/// [code] is an error-codes.md code (or `explanation_timeout` when the poll gave
/// up), resolved to copy at the widget. Rendered as "not available" rather than
/// as a failure: an explanation is an extra, and losing it must never look like
/// the quiz broke.
class ExplanationFailed extends ExplanationState {
  const ExplanationFailed(this.code);

  final String code;

  /// Whether the panel offers a "try again", and whether the Bloc will honour
  /// one. Only two codes qualify, and the list is an ALLOWLIST on purpose:
  /// default-deny means a code added later cannot quietly acquire a retry
  /// button, which is the mistake adr-114 already cost this app once.
  ///
  /// - [explanationTimeoutCode] — the poll cap. The contract is explicit that
  ///   this is the failure UX: "after roughly 10 polls (~20s), stop and show a
  ///   'try again' affordance. Re-tapping simply re-issues the GET; the server
  ///   side is idempotent, so a retry never causes a duplicate generation."
  /// - `rate_limited` — the `429`. The contract says do NOT treat it as a
  ///   generation failure: "the explanation is unaffected and the same GET
  ///   succeeds after the window."
  ///
  /// Everything else is terminal for this question, and deliberately:
  /// `insufficient_scope` means no explanation is available to this caller at
  /// all ("no popup, no error toast"); and `account_pending_deletion` must
  /// never show a retry —
  /// the contract says outright do not retry, and nothing the student taps
  /// here clears it.
  bool get isRetryable =>
      code == explanationTimeoutCode || code == 'rate_limited';
}

/// Not an error-codes.md code — the client's own name for giving up after the
/// contract's poll cap. There is deliberately no terminal failure status on the
/// wire: a generation that fails keeps answering `202`, so the cap IS the
/// failure.
const explanationTimeoutCode = 'explanation_timeout';
