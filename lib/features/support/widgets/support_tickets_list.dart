import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../notifier/support_tickets_notifier.dart';
import '../support_error_copy.dart';
import 'support_create_card.dart';
import 'support_state_message.dart';
import 'support_ticket_row.dart';

/// The support list's whole body · Figma `178:2800`: the create card, the
/// "Recent Tickets" heading, and under them the student's tickets in one of
/// the four states.
///
/// **The create card and the heading are part of every state**, not of the
/// loaded one: a student with no tickets, a failed list or no connection must
/// still be able to open a new one. They scroll with the list, so a large text
/// scale cannot push the rows off a screen that does not scroll.
///
/// The states are the shared `StateWidget` over the notifier's `AsyncValue`,
/// exactly as the notifications inbox maps them; the Retry button is withheld
/// for a rate-limited call, a pending deletion and an unknown ticket
/// ([supportRetryAllowed]), the reasons living on that predicate.
class SupportTicketsList extends ConsumerWidget {
  const SupportTicketsList({super.key});

  /// The list route keeps the title bar's own 8 under it; the frame puts the
  /// card 25 under the bar, so 17 more.
  static const _top = 17.0;

  /// Between the card and the heading, and between the heading and the first
  /// row (`178:3079`).
  static const _headingGap = 25.0;

  /// The frame's gap between rows (`178:3104`).
  static const _rowGap = 10.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tickets = ref.watch(supportTicketsProvider);
    final notifier = ref.read(supportTicketsProvider.notifier);

    final state = tickets.when<ScreenState<SupportTicketsResults>>(
      // Empty ONLY when there is nothing and the server has nothing more: a
      // first page with no rows but `hasMore` is not an empty list.
      data: (data) => data.isEmpty
          ? ScreenEmpty<SupportTicketsResults>()
          : ScreenLoaded(data),
      loading: ScreenLoading<SupportTicketsResults>.new,
      error: (error, _) => isOffline(error)
          ? ScreenOffline<SupportTicketsResults>()
          : ScreenError<SupportTicketsResults>('genericError', cause: error),
    );

    Widget fill(Widget child) =>
        SliverFillRemaining(hasScrollBody: false, child: child);

    return StateWidget<SupportTicketsResults>(
      state: state,
      onRetry: notifier.refresh,
      loading: _Scroll(
        slivers: [fill(const Center(child: CircularProgressIndicator()))],
      ),
      empty: _Scroll(
        slivers: [
          fill(
            SupportStateMessage(
              icon: Icons.inbox_outlined,
              text: l10n.nothingHere,
            ),
          ),
        ],
      ),
      error: _Scroll(
        slivers: [
          fill(
            SupportStateMessage(
              icon: Icons.error_outline,
              text: supportLoadFailureText(l10n, tickets.error),
              retryKey: const Key('support_retry'),
              onRetry: supportRetryAllowed(tickets.error)
                  ? notifier.refresh
                  : null,
            ),
          ),
        ],
      ),
      offline: _Scroll(
        slivers: [
          fill(
            SupportStateMessage(
              icon: Icons.wifi_off,
              text: l10n.offline,
              retryKey: const Key('support_retry'),
              onRetry: notifier.refresh,
            ),
          ),
        ],
      ),
      onLoaded: (data) => _Scroll(
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: data.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: _rowGap),
              itemBuilder: (context, index) {
                final ticket = data.items[index];
                return SupportTicketRow(
                  // Keyed by the server id: a row keeps its identity (and its
                  // ink) when a page is appended or the list is refetched.
                  key: Key('support_ticket_row_${ticket.ticketId}'),
                  ticket: ticket,
                  onTap: () => context.push(
                    '/support/tickets/${Uri.encodeComponent(ticket.ticketId)}',
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _Footer(results: data, onLoadMore: notifier.loadMore),
          ),
        ],
      ),
    );
  }
}

/// The scroll view every state shares: the create card and the heading first,
/// then the state's own slivers.
class _Scroll extends StatelessWidget {
  const _Scroll({required this.slivers});

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            20,
            SupportTicketsList._top,
            20,
            0,
          ),
          sliver: SliverList.list(
            children: [
              SupportCreateCard(
                key: const Key('support_create_card'),
                onTap: () => context.push('/support/new'),
              ),
              const SizedBox(height: SupportTicketsList._headingGap),
              Semantics(
                header: true,
                child: Text(
                  l10n.supportRecentTickets,
                  style: AppType.h3.copyWith(color: ext.textPrimary),
                ),
              ),
              const SizedBox(height: SupportTicketsList._headingGap),
            ],
          ),
        ),
        ...slivers,
      ],
    );
  }
}

/// After the last row: a spinner while appending, the append's own Retry when
/// it failed, Load more while the server says there is more and gave a cursor
/// to follow, and nothing once the list is finished. Branches on `hasMore`,
/// never on the row count.
class _Footer extends StatelessWidget {
  const _Footer({required this.results, required this.onLoadMore});

  final SupportTicketsResults results;
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
      // on the first page: a pending deletion answers the same 403 on every
      // tap and a rate-limited call recovers on its own clock, so both keep the
      // text and offer no button.
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Center(
          child: supportRetryAllowed(appendError)
              ? TextButton(
                  key: const Key('support_append_retry'),
                  onPressed: onLoadMore,
                  child: Text(l10n.retry),
                )
              : Text(
                  supportLoadFailureText(l10n, appendError),
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
            key: const Key('support_load_more'),
            onPressed: onLoadMore,
            child: Text(l10n.loadMore),
          ),
        ),
      );
    }

    return const SizedBox(height: 24);
  }
}
