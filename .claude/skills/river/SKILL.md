---
name: river
description: How to build Riverpod-powered Level Up screens — AsyncNotifier, providers-as-DI, the AsyncValue→four-states mapping, and refresh/retry. Use this skill whenever creating or editing any Level Up notifier, provider, or screen that shows server data (auth, home, track, flashcards, subscription, profile, leaderboard) — i.e., every screen except the quiz engine — even if the user doesn't say "Riverpod".
---

# Riverpod Screens — The Level Up Pattern

Riverpod is the app's primary state management AND its dependency injection (no get_it — one compile-time-typed graph). `AsyncNotifier` is used because `AsyncValue` natively represents loading/data/error, which maps directly onto the mandatory 4-state model. Bloc is reserved for the quiz engine only; `setState` only for ephemeral local UI (tab index, animation step) — never network data.

## The pipeline (every data screen)

Repository (throws typed `AppException`) → `AsyncNotifier` (catches via `AsyncValue.guard`) → widget maps `AsyncValue` through the shared `StateWidget`. The UI never sees Dio or raw exceptions.

```dart
final flashcardProvider =
    AsyncNotifierProvider<FlashcardNotifier, List<Flashcard>>(FlashcardNotifier.new);

class FlashcardNotifier extends AsyncNotifier<List<Flashcard>> {
  @override
  Future<List<Flashcard>> build() =>
      ref.watch(flashcardRepositoryProvider).getFlashcards();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(flashcardRepositoryProvider).getFlashcards());
  }
}
```

## AsyncValue → the 4 states

- `loading:` → Loading (skeleton)
- `data:` where the payload `isEmpty` → Empty (distinct view, not blank Loaded)
- `data:` otherwise → Loaded
- `error:` → inspect the exception type: `OfflineException` → Offline view; else → Error view with a retry button that calls `refresh()` (user-tapped, never silent auto-retry)

Render through the shared `StateWidget<T>` in `core/widgets/` — never re-derive per-screen switches or boolean flags (`isLoading` + `hasError` allows impossible combinations).

## Rules that keep screens correct

- **DI via providers:** repositories take dependencies from other providers (`ref.watch(dioProvider)`); tests override providers, no service locators.
- **`ref.watch` in `build`, `ref.read` in callbacks.** Watching in callbacks re-subscribes; reading in build misses updates.
- **Scope rebuilds:** `ref.watch(provider.select((u) => u.totalPoints))` when a widget needs one field of a big object.
- **Server is authoritative:** never compute or "correct" points/levels/entitlements in a notifier — display what the API returned. Entitlement state is `EntitlementState` (`GET /me/entitlements`, embedded in `GET /me`) — there is no `pending`/"Payment processing" state; an entitlement is active or it isn't (`openapi.yaml:754`).
- **Simple derived/sync state** → plain `Provider` or `Notifier`, not an AsyncNotifier wrapping nothing.
- **Naming:** glossary terms verbatim — `flashcardProvider`, `totalPoints`, `baseSubscription`. No synonyms.

## Testing the notifier

Pure-Dart tests: `ProviderContainer` with the repository provider overridden (mocktail). Assert the state sequence — initial `AsyncLoading`, then `AsyncData`/`AsyncError` — and that `OfflineException` surfaces as an error holding that exception type (the widget layer depends on it to pick the Offline view).
