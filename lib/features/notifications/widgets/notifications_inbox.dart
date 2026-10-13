import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../models/notification_models.dart';
import '../notifications_error_copy.dart';
import '../notifier/notifications_notifier.dart';
import 'notification_filter_chips.dart';
import 'notification_row.dart';

/// The inbox itself: the filter chips over one tab's list, with every state.
///
/// A widget of its own rather than the body of `NotificationsScreen`, so the
/// Message tab can host it later (CW07b, H-17) without a second copy of the
/// states, the paging or the read marking.
///
/// The selected category is ephemeral local UI — it never leaves the device and
/// carries no network state, which is what makes `setState` correct here.
/// `null` is **All**. Each category is its own `notificationsProvider` family
/// member, with its own list, cursor and read marks.
class NotificationsInbox extends ConsumerStatefulWidget {
  const NotificationsInbox({super.key});

  @override
  ConsumerState<NotificationsInbox> createState() => _NotificationsInboxState();
}

class _NotificationsInboxState extends ConsumerState<NotificationsInbox> {
  NotificationCategory? _category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NotificationFilterChips(
          selected: _category,
          onChanged: (category) => setState(() => _category = category),
        ),
        // Keyed by category so each tab starts at the top rather than at
        // whatever offset the previous one was scrolled to.
        Expanded(
          child: _Tab(key: ValueKey(_category), category: _category),
        ),
      ],
    );
  }
}

/// One tab: maps the family member's `AsyncValue` onto the four states.
class _Tab extends ConsumerWidget {
  const _Tab({super.key, required this.category});

  final NotificationCategory? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final inbox = ref.watch(notificationsProvider(category));
    final notifier = ref.read(notificationsProvider(category).notifier);

    final state = inbox.when<ScreenState<InboxResults>>(
      // Empty ONLY when nothing renderable is left AND the server has nothing
      // more — `InboxResults.isEmpty`. An all-ignored page with `hasMore` is not
      // an empty inbox (`openapi.yaml:1165`).
      data: (data) =>
          data.isEmpty ? ScreenEmpty<InboxResults>() : ScreenLoaded(data),
      loading: ScreenLoading<InboxResults>.new,
      error: (error, _) => isOffline(error)
          ? ScreenOffline<InboxResults>()
          : ScreenError<InboxResults>('genericError', cause: error),
    );

    return StateWidget<InboxResults>(
      state: state,
      onRetry: notifier.refresh,
      loading: const Center(child: CircularProgressIndicator()),
      empty: _Message(icon: Icons.notifications_none, text: l10n.nothingHere),
      error: _Message(
        icon: Icons.error_outline,
        text: notificationsFailureText(l10n, inbox.error),
        // No Retry for a rate-limited call or a pending deletion: the reasons
        // live on [notificationsRetryAllowed].
        onRetry: notificationsRetryAllowed(inbox.error)
            ? notifier.refresh
            : null,
      ),
      offline: _Message(
        icon: Icons.wifi_off,
        text: l10n.offline,
        onRetry: notifier.refresh,
      ),
      onLoaded: (data) => _InboxList(
        results: data,
        onMarkRead: notifier.markRead,
        onLoadMore: notifier.loadMore,
      ),
    );
  }
}

/// The rows, then a footer slot for Load more / its spinner / its own Retry.
class _InboxList extends StatelessWidget {
  const _InboxList({
    required this.results,
    required this.onMarkRead,
    required this.onLoadMore,
  });

  final InboxResults results;
  final Future<void> Function(String id) onMarkRead;
  final Future<void> Function() onLoadMore;

  /// The frame's gap between rows (`180:8844`).
  static const _gap = 16.0;

  @override
  Widget build(BuildContext context) {
    // ONLY what the app can render: an ignored kind has no row, no
    // placeholder and no count (`openapi.yaml:1165-1167`).
    final rows = results.visibleItems;

    return ListView.separated(
      // 25 under the chips, less the slack their tap targets already leave.
      padding: const EdgeInsetsDirectional.fromSTEB(
        20,
        NotificationFilterChips.bottomGap,
        20,
        24,
      ),
      itemCount: rows.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: _gap),
      itemBuilder: (context, index) {
        if (index == rows.length) return _Footer(results, onLoadMore);

        final item = rows[index];
        return NotificationRow(
          // Keyed by the server id, so a row keeps its identity (and its
          // ink) when a page is appended or a sibling is marked read.
          key: ValueKey(item.notificationId),
          item: item,
          unread: results.isUnread(item),
          onMarkRead: () => onMarkRead(item.notificationId),
        );
      },
    );
  }
}

/// After the last row: a spinner while appending, the append's own Retry when
/// it failed, Load more while the server says there is more and gave a cursor
/// to follow, and nothing once the inbox is finished. Branches on `hasMore`,
/// never on the row count.
class _Footer extends StatelessWidget {
  const _Footer(this.results, this.onLoadMore);

  final InboxResults results;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    if (results.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final appendError = results.appendError;
    if (appendError != null) {
      // The rows stay. Whether the failure may be retried is the same call as
      // on the first page ([notificationsRetryAllowed]): a pending deletion
      // answers the same 403 on every tap, and a rate-limited call recovers on
      // its own clock and must not be hammered. Both keep the text and offer
      // no button — leaving the screen and coming back asks again from page
      // one.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: notificationsRetryAllowed(appendError)
              ? TextButton(
                  key: const Key('notifications_append_retry'),
                  onPressed: onLoadMore,
                  child: Text(l10n.retry),
                )
              : Text(
                  notificationsFailureText(l10n, appendError),
                  textAlign: TextAlign.center,
                  style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
                ),
        ),
      );
    }

    // `hasMore` without a cursor cannot be followed: the notifier answers a tap
    // with nothing, so the button would be dead. Show it only when it can work.
    if (results.hasMore && results.nextCursor != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: TextButton(
            key: const Key('notifications_load_more'),
            onPressed: onLoadMore,
            child: Text(l10n.loadMore),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Centred icon + localized line + optional Retry — shared by empty, error and
/// offline so the three never drift apart visually. Same shape as the
/// leaderboard's, kept private to this feature like every other screen's.
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
              FilledButton(
                key: const Key('notifications_retry'),
                onPressed: onRetry,
                child: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
