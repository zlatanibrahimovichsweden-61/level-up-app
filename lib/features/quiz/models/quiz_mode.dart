/// The two enums that shape the `POST /quizzes` REQUEST — `mode` and `length`.
///
/// Both mirror the contract's own enums exactly. Neither carries a value the
/// server has never heard of, and neither is marked extensible by the contract
/// (contrast `EntitlementType`), so an unknown value is contract drift and must
/// throw rather than be silently coerced.
library;

/// `POST /quizzes.mode` — contract enum `[normal, retakeWrong, favorites]`
/// (`openapi.yaml:768`, and again on `Quiz.mode` at `:1430`).
///
/// **All three values live here even though Day 7 ships one.** Serialization is
/// then correct forever: a `Quiz` built in a later release with
/// `mode: "favorites"` parses today rather than throwing, and enabling a mode
/// becomes a change to [offeredQuizModes] instead of a hunt through the UI.
///
/// Wire names are already camelCase, so json_serializable maps the member names
/// directly — no `@JsonValue` bridge, per the project's no-key-bridge rule.
///
/// Every `switch` on this enum is EXHAUSTIVE with no `default:`. That is the
/// point: the day a second mode is offered, the compiler lists every site that
/// needs a decision instead of silently falling through to the `normal` branch.
enum QuizMode { normal, retakeWrong, favorites }

/// What the app OFFERS today, as opposed to what the contract DEFINES above.
///
/// Day 7 ships `normal` only (owner decision): `retakeWrong` and `favorites`
/// build from the student's own pool, which needs the favourites endpoints —
/// all `x-stability: draft` — and a My Fault flow that is its own day.
///
/// Keeping "exists" and "offered" apart is deliberate. Enabling a mode later is
/// one line HERE; nothing else about the request, the repository or the models
/// has to move.
const offeredQuizModes = <QuizMode>[QuizMode.normal];

/// `POST /quizzes.length` — contract enum `[10, 30, 50]` (`openapi.yaml:772`).
///
/// An enum rather than a bare `int` so a length the server would reject is not
/// representable: the repository takes this type, so there is no code path that
/// can put `20` on the wire.
///
/// [value] is what actually serializes — the request builder sends the integer,
/// never the member name.
enum QuizLength {
  ten(10),
  thirty(30),
  fifty(50);

  const QuizLength(this.value);

  final int value;
}

/// The frame's pre-selected length (`135:1622` / `309:5771`).
const defaultQuizLength = QuizLength.thirty;
