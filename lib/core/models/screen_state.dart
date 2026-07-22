/// The shared, sealed screen-state model. Lives here ONCE.
///
/// Every data screen renders one of these through `StateWidget`. Booleans like
/// `isLoading`/`hasError` are banned — they permit impossible combinations.
/// Definition of Done (see screen-states skill): loading / empty / error /
/// offline, each in AR (RTL) + EN (LTR).
library;

sealed class ScreenState<T> {
  const ScreenState();
}

class ScreenLoading<T> extends ScreenState<T> {
  const ScreenLoading();
}

/// `data` present but empty (e.g. an empty list) — distinct from error.
class ScreenEmpty<T> extends ScreenState<T> {
  const ScreenEmpty();
}

class ScreenLoaded<T> extends ScreenState<T> {
  const ScreenLoaded(this.data);
  final T data;
}

/// [messageKey] is a localization key, not user-facing English.
class ScreenError<T> extends ScreenState<T> {
  const ScreenError(this.messageKey, {this.cause});
  final String messageKey;
  final Object? cause;
}

class ScreenOffline<T> extends ScreenState<T> {
  const ScreenOffline();
}
