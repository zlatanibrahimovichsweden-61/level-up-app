import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';

/// How a screen renders `403 insufficient_scope`.
///
/// 🔴 **The code string is identical on every route that returns it, and it
/// does not mean the same thing on all of them.** Branching on the code alone
/// is therefore wrong, and this enum is how a screen states which meaning
/// applies to the route it is showing.
///
/// The case that forced it (contract 3.10.0-m1, `openapi.yaml:925-939` vs
/// `:990-991`): `GET /me/mistakes` and `GET /me/mistakes/subjects/{id}` both
/// answer `403 insufficient_scope`, and the changelog says outright — *"it
/// means something DIFFERENT from the subject route's 403 — do not collapse
/// the two branches."* See docs/DESIGN_ISSUES.md #61.
enum ScopeErrorCopy {
  /// **The route took a subject id and refused it.** "This subject isn't part
  /// of your course" — and retry is suppressed, because tapping it would 403
  /// again with the same answer. The default, because it is what every catalog
  /// screen means.
  subjectNotYours,

  /// **The route took no id at all and refuses nothing.** The caller has no
  /// ACTIVE ENROLMENT to scope a history against — reachable in ordinary use,
  /// because a track transfer closes the old enrolment before the new one opens
  /// (adr-032).
  ///
  /// So it is not an authorization failure, not a reason to log out, and — the
  /// difference that matters — **retry is legitimate**: the state is transient
  /// and the next request may well succeed.
  enrolmentPending,
}

/// Bridges an [AsyncValue] onto the shared sealed [ScreenState] and renders it
/// through the shared [StateWidget] — which stays the ONLY place that switches
/// on the state. Screens supply the loaded body and a skeleton; loading, empty,
/// error and offline come out identical everywhere.
///
/// The four states, per the project's Definition of Done:
/// - loading  → [skeleton] (a shape, not a bare spinner)
/// - empty    → `data` that is empty is EMPTY, not a blank Loaded
/// - error    → localized copy + a USER-TAPPED retry (never a silent loop)
/// - offline  → its own view, chosen by exception type, not a generic error
class CatalogAsyncView<T> extends StatelessWidget {
  const CatalogAsyncView({
    super.key,
    required this.value,
    required this.isEmpty,
    required this.emptyMessage,
    required this.onRetry,
    required this.onLoaded,
    required this.skeleton,
    this.scopeError = ScopeErrorCopy.subjectNotYours,
  });

  final AsyncValue<T> value;
  final bool Function(T data) isEmpty;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Widget Function(T data) onLoaded;
  final Widget skeleton;

  /// Which of the two `insufficient_scope` meanings this route carries. Passed
  /// IN rather than decided here: only the caller knows its own route, and the
  /// wire gives both the same code. See [ScopeErrorCopy].
  final ScopeErrorCopy scopeError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final state = value.when<ScreenState<T>>(
      data: (data) => isEmpty(data) ? ScreenEmpty<T>() : ScreenLoaded<T>(data),
      loading: ScreenLoading<T>.new,
      error: (error, _) => isOffline(error)
          ? ScreenOffline<T>()
          : ScreenError<T>(_messageKeyFor(error), cause: error),
    );

    // Only this branch is scope-specific; everything else renders identically.
    final isScope = _isInsufficientScope(value.error);
    final scopeIsTransient = scopeError == ScopeErrorCopy.enrolmentPending;

    // adr-114, and NOT route-specific: the account is inside its deletion grace
    // window, so every route this widget serves answers the same `403` for the
    // same reason. Checked before the scope branch because it outranks it —
    // during grace the subject id is never resolved at all (`openapi.yaml:1210`).
    final isPendingDeletion = isAccountPendingDeletion(value.error);

    return StateWidget<T>(
      state: state,
      onLoaded: onLoaded,
      onRetry: onRetry,
      loading: skeleton,
      empty: CatalogMessage(icon: Icons.inbox_outlined, text: emptyMessage),
      error: CatalogMessage(
        icon: Icons.error_outline,
        text: switch ((isPendingDeletion, isScope, scopeIsTransient)) {
          (true, _, _) => l10n.accountPendingDeletion,
          (_, true, true) => l10n.mistakesEnrolmentPending,
          (_, true, false) => l10n.subjectUnavailable,
          _ => l10n.genericError,
        },
        // Retry is suppressed ONLY where it is genuinely futile — a refused
        // subject id answers the same way every time. An enrolment between
        // states resolves on its own, so the student gets the button.
        //
        // A pending deletion is futile for a third reason, and the contract
        // says so outright: "do not log the user out and do not retry"
        // (`openapi.yaml:82-83`). Nothing the student can tap changes it; only
        // cancelling the deletion does.
        onRetry: isPendingDeletion || (isScope && !scopeIsTransient)
            ? null
            : onRetry,
      ),
      offline: CatalogMessage(
        icon: Icons.wifi_off,
        text: l10n.offline,
        onRetry: onRetry,
      ),
    );
  }

  static bool _isInsufficientScope(Object? error) =>
      error is ApiException && error.code == 'insufficient_scope';

  /// `ScreenError.messageKey` is a KEY, not user-facing copy — the server's
  /// `title`/`detail` are developer-facing English and are never shown.
  /// `ScreenError.messageKey` is a KEY, not copy — so it names which of the
  /// two scope meanings was taken, not the sentence either one renders.
  String _messageKeyFor(Object error) => switch (error) {
    _ when isAccountPendingDeletion(error) => 'accountPendingDeletion',
    _ when _isInsufficientScope(error) => switch (scopeError) {
      ScopeErrorCopy.subjectNotYours => 'subjectUnavailable',
      ScopeErrorCopy.enrolmentPending => 'mistakesEnrolmentPending',
    },
    _ => 'genericError',
  };
}

/// Centred icon + localized line + optional retry. Shared by empty, error and
/// offline so the three never drift apart visually.
class CatalogMessage extends StatelessWidget {
  const CatalogMessage({
    super.key,
    required this.icon,
    required this.text,
    this.onRetry,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    // Centred when it fits; when the room under the header is short (a phone on
    // its side, the smallest phone at the largest text) it scrolls, so the Retry
    // button is always reachable instead of being drawn past the bottom edge.
    //
    // The centring floor is the room it is GIVEN. A parent that gives none (an
    // unbounded height: a ListView, a bare Column) has nothing to centre in, so
    // the floor is 0 there and the message simply takes its own height - an
    // infinite floor would throw.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.hasBoundedHeight ? constraints.maxHeight : 0,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48, color: ext.mutedText),
                  const SizedBox(height: 16),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: 20),
                    // Re-triggers the same request on tap — never a silent loop.
                    FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A grey block in the shape of real content, so the page doesn't jump when the
/// data lands.
class CatalogBlock extends StatelessWidget {
  const CatalogBlock({
    super.key,
    this.width,
    this.height = 56,
    this.radius = 10.7,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ext.progressTrack,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Loading shape for a list of rows (Units / Chapters / Lessons).
class CatalogListSkeleton extends StatelessWidget {
  const CatalogListSkeleton({super.key, this.rows = 6});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      itemCount: rows,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const CatalogBlock(height: 56),
    );
  }
}
