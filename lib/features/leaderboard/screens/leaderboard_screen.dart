import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/models/student_profile.dart';
import '../../profile/notifier/me_notifier.dart';
import '../models/leaderboard_models.dart';
import '../notifier/leaderboard_notifier.dart';
import '../widgets/leaderboard_row.dart';
import '../widgets/podium.dart';
import '../widgets/scope_toggle.dart';

/// The Leaderboard tab · Figma "Leaderboard for school student" /
/// "Leaderboard for Uni student".
///
/// One endpoint, `GET /leaderboard`, scoped by a switcher whose options come
/// from the caller's own profile — the server derives the concrete board from
/// the caller's registration, so nothing here can ask for someone else's.
///
/// The screen depends on `GET /me` before it can name a single scope, so the
/// profile is awaited first and its failure is the screen's failure. That is
/// not an extra call: `meProvider` is already warm from Home.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  /// Ephemeral local UI: which segment is selected. It never leaves the device
  /// and there is no network state in it, which is what makes `setState`
  /// correct here rather than a provider.
  LeaderboardScope? _scope;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final me = ref.watch(meProvider);
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    return Scaffold(
      backgroundColor: ext.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            if (offline) const OfflineBanner(),
            Expanded(
              child: switch (me) {
                AsyncData(value: final profile) => _Board(
                  profile: profile,
                  scope: _scopeFor(profile),
                  onScopeChanged: (scope) => setState(() => _scope = scope),
                ),
                AsyncError(error: final error) => _Message(
                  icon: isOffline(error) ? Icons.wifi_off : Icons.error_outline,
                  text: isOffline(error) ? l10n.offline : l10n.genericError,
                  onRetry: () => ref.invalidate(meProvider),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }

  /// The selected scope, defaulting to the first one this student's track and
  /// country allow. Re-derived on every build so that a profile change which
  /// removes a scope (a country edit that drops `governorate`) cannot leave the
  /// screen holding one the server would reject.
  LeaderboardScope _scopeFor(StudentProfile profile) {
    final allowed = LeaderboardScope.scopesFor(profile);
    final current = _scope;
    return current != null && allowed.contains(current)
        ? current
        : allowed.first;
  }
}

/// Back chip · title · share. The frame's own header, not an [AppBar].
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 16),
      child: Row(
        children: [
          CircleBackButton(
            // This is a root tab of the shell, so there is nothing on this
            // branch's stack to pop — `Navigator.pop` would be a no-op. Back
            // here means "go to Home", which switches the shell branch and
            // moves the nav bar's selection with it.
            onPressed: () => context.go('/home'),
          ),
          Expanded(
            child: Text(
              // NOT `navLeaderboard`: the frames use different words for the
              // tab and the heading, and in Arabic they are visibly different
              // (المتصدرون vs لوحة الصدارة). One key for both shipped the
              // wrong Arabic heading.
              l10n.leaderboardTitle,
              textAlign: TextAlign.center,
              // Figma `134:3512` is Inter 600 / 22px. [AppType.h3] is 18/600 —
              // the weight matches, the size does not, and there is no 22pt
              // token. Adding one would raise the hardcoded-fontSize ratchet
              // that Wave 3D is blocked on, so the divergence is recorded here
              // rather than paid for with a new scale entry.
              style: AppType.h3.copyWith(color: ext.textPrimary),
            ),
          ),
          // Disabled on purpose: the frame draws a share affordance, but there
          // is no sharing surface in the contract, and a board carries other
          // students' names and scores — minors' data. It stays visible and
          // inert until that is settled with the backend.
          //
          // TODO(design-asset): the frame's glyph is `ic:baseline-share`, a
          // sibling of the title in `133:3117`, and has not been exported.
          // `Icons.share` is the same shape from Material — three connected
          // nodes — where `Icons.ios_share` was a box-and-arrow and simply the
          // wrong icon.
          Semantics(
            button: true,
            enabled: false,
            label: l10n.leaderboardShare,
            child: IconButton(
              onPressed: null,
              icon: Icon(Icons.share, color: ext.mutedText),
              tooltip: l10n.leaderboardShare,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scope switcher + the board itself.
class _Board extends ConsumerWidget {
  const _Board({
    required this.profile,
    required this.scope,
    required this.onScopeChanged,
  });

  final StudentProfile profile;
  final LeaderboardScope scope;
  final ValueChanged<LeaderboardScope> onScopeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final board = ref.watch(leaderboardProvider(scope));
    final notifier = ref.read(leaderboardProvider(scope).notifier);

    final state = board.when<ScreenState<LeaderboardResults>>(
      data: (data) => data.isEmpty
          ? ScreenEmpty<LeaderboardResults>()
          : ScreenLoaded<LeaderboardResults>(data),
      loading: ScreenLoading<LeaderboardResults>.new,
      error: (error, _) => isOffline(error)
          ? ScreenOffline<LeaderboardResults>()
          : ScreenError<LeaderboardResults>('genericError', cause: error),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
          child: ScopeToggle(
            scopes: LeaderboardScope.scopesFor(profile),
            selected: scope,
            onChanged: onScopeChanged,
            labelFor: (s) => _label(l10n, s),
          ),
        ),
        Expanded(
          child: StateWidget<LeaderboardResults>(
            state: state,
            onRetry: notifier.refresh,
            loading: const Center(child: CircularProgressIndicator()),
            empty: _Message(
              icon: Icons.leaderboard_outlined,
              text: l10n.leaderboardEmpty,
            ),
            error: _Message(
              icon: Icons.error_outline,
              text: _errorText(l10n, board.error),
              // A rate-limited board recovers on its own clock, and the
              // contract is explicit: do not retry in a tight loop. The button
              // is withheld rather than handed to the student to hammer.
              onRetry: _isRateLimited(board.error) ? null : notifier.refresh,
            ),
            offline: _Message(
              icon: Icons.wifi_off,
              text: l10n.offline,
              onRetry: notifier.refresh,
            ),
            onLoaded: (data) =>
                _BoardList(results: data, onLoadMore: notifier.loadMore),
          ),
        ),
      ],
    );
  }

  static bool _isRateLimited(Object? error) => error is RateLimitedException;

  /// `403 account_pending_deletion` is not a leaderboard failure — the account
  /// is inside its 30-day deletion grace window, during which every
  /// authenticated endpoint but four answers this. The contract's instruction
  /// is to route to the cancel screen and neither log out nor retry. That
  /// screen does not exist yet, so the board says what is actually wrong
  /// instead of showing a generic error, and withholds the retry that the
  /// contract says would be pointless.
  static String _errorText(AppLocalizations l10n, Object? error) {
    if (error is ApiException && error.code == 'account_pending_deletion') {
      return l10n.accountPendingDeletion;
    }
    return l10n.genericError;
  }

  static String _label(AppLocalizations l10n, LeaderboardScope scope) =>
      switch (scope) {
        LeaderboardScope.system => l10n.leaderboardScopeSystem,
        LeaderboardScope.governorate => l10n.leaderboardScopeGovernorate,
        LeaderboardScope.cohort => l10n.leaderboardScopeCohort,
        LeaderboardScope.global => l10n.leaderboardScopeGlobal,
      };
}

/// Podium + ranked rows, as one scrolling list.
///
/// The podium scrolls with the rows rather than pinning above them, because it
/// IS the first three rows — pinning it would present the board as two lists.
class _BoardList extends StatefulWidget {
  const _BoardList({required this.results, required this.onLoadMore});

  final LeaderboardResults results;
  final Future<void> Function() onLoadMore;

  @override
  State<_BoardList> createState() => _BoardListState();
}

class _BoardListState extends State<_BoardList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      // The notifier already no-ops when exhausted or in flight, so this can
      // fire freely on scroll without guarding here too.
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final items = widget.results.items;
    final top = items.take(3).toList();
    final rest = items.skip(3).toList();

    return ListView.separated(
      controller: _controller,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      // podium + rows + trailing footer slot
      itemCount: rest.length + 2,
      separatorBuilder: (_, index) => SizedBox(height: index == 0 ? 24 : 10),
      itemBuilder: (context, index) {
        if (index == 0) return Podium(top: top);
        if (index <= rest.length) return LeaderboardRow(entry: rest[index - 1]);

        // Footer: the append spinner, the append's own retry, or the note that
        // the published display bound has been reached.
        if (widget.results.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (widget.results.appendError != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: TextButton(
                onPressed: widget.onLoadMore,
                child: Text(l10n.retry),
              ),
            ),
          );
        }
        if (!widget.results.hasMore && items.isNotEmpty) {
          // `hasMore: false` has two causes — the end of the board, or the
          // 200-row display bound — and the contract says a client cannot tell
          // them apart and does not need to. One neutral line covers both.
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              l10n.leaderboardEndOfBoard,
              textAlign: TextAlign.center,
              style: AppType.captionRegular.copyWith(color: ext.mutedText),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// Centred icon + localized line + optional retry — shared by empty, error and
/// offline so the three never drift apart visually.
class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: ext.mutedText),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              // Retry re-triggers the same request on tap — never a silent loop.
              FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}
