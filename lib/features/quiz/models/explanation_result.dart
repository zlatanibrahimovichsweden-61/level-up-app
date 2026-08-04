/// What `GET /questions/{questionId}/explanation` said, once.
///
/// The endpoint discriminates on HTTP STATUS, not on a field: `200` carries
/// `{status: "ready", text}` and `202` carries `{status: "generating"}` with no
/// text. A single nullable-text model would let a caller read `text!` on a 202
/// and crash; a sealed pair makes the generating case impossible to ignore.
///
/// Hand-written rather than freezed: this is a transport-shaped union the
/// repository builds from a status code, not a JSON model with a `fromJson` —
/// the same reasoning that makes `AppException` and `ScreenState` plain sealed
/// classes.
library;

sealed class ExplanationResult {
  const ExplanationResult();
}

/// `200` — generated once by GPT-4o-mini and cached server-side, so a second
/// request for the same question returns this immediately.
class ExplanationReady extends ExplanationResult {
  const ExplanationReady(this.text);

  final String text;
}

/// `202` — the server is still generating. The contract's instruction is to
/// poll, suggested 2s backoff. This is a normal step in the happy path, not an
/// error: the first student to reach a question always sees it.
class ExplanationGenerating extends ExplanationResult {
  const ExplanationGenerating();
}
