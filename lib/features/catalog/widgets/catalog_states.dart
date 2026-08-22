import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';

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
  });

  final AsyncValue<T> value;
  final bool Function(T data) isEmpty;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Widget Function(T data) onLoaded;
  final Widget skeleton;

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

    // `insufficient_scope` (403) means this subject is not in the student's
    // server-derived scope — tapping retry would 403 again, so no retry button.
    final scopeError = _isInsufficientScope(value.error);

    return StateWidget<T>(
      state: state,
      onLoaded: onLoaded,
      onRetry: onRetry,
      loading: skeleton,
      empty: CatalogMessage(icon: Icons.inbox_outlined, text: emptyMessage),
      error: CatalogMessage(
        icon: Icons.error_outline,
        text: scopeError ? l10n.subjectUnavailable : l10n.genericError,
        onRetry: scopeError ? null : onRetry,
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
  static String _messageKeyFor(Object error) =>
      _isInsufficientScope(error) ? 'subjectUnavailable' : 'genericError';
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

    return Center(
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
