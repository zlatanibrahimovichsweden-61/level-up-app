import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/content_text_direction.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/notifier/me_notifier.dart';
import '../notifier/support_thread_notifier.dart';
import '../support_error_copy.dart';
import '../widgets/support_composer.dart';
import '../widgets/support_message_row.dart';
import '../widgets/support_state_message.dart';

/// A support ticket's thread · routed at `/support/tickets/:ticketId`, pushed
/// from a list row and, on success, in place of the create screen. Figma
/// `178:3378` (Customer support chat).
///
/// The student's own ticket, text only (CW12a): the ticket (`GET
/// /support/tickets/{ticketId}`) and its replies (`GET .../messages`), and a
/// text reply (`POST .../messages`).
///
/// **The first row is the ticket's `details`**, written as the student: the
/// contract keeps the opening text out of the message list, the frame draws
/// only messages, and a thread that began at the first reply would hide what
/// was actually asked. Then the replies, oldest first, staff as "Customer
/// Support" (the contract gives a staff reply no identity).
///
/// **The header is not `TitledChrome`.** The frame's header (`178:3398`) is 63
/// high with a 1.18 divider and an 18 SemiBold green title that is the
/// ticket's own subject, which `TitledChrome` (centred 20 Bold, no divider)
/// cannot express; it is built from the same shared [CircleBackButton]. The 63
/// is a minimum and the subject may take two lines (see `_Header`).
///
/// **Closed** swaps the composer for a bar: a closed ticket refuses a reply and
/// cannot be reopened (`openapi.yaml:3911-3922`), so there is nothing to type
/// into. A `409 ticket_closed` while sending turns the composer into that bar
/// the same way.
///
/// **A failed send keeps the text** and says why above the field; the student
/// taps send again (or the keyboard's Send), never a silent retry.
///
/// Scrolls to the end after the first load and after a send.
class SupportTicketScreen extends ConsumerStatefulWidget {
  const SupportTicketScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  ConsumerState<SupportTicketScreen> createState() =>
      _SupportTicketScreenState();
}

class _SupportTicketScreenState extends ConsumerState<SupportTicketScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  final _scroll = ScrollController();

  bool _didInitialScroll = false;

  /// The last send's failure, shown above the field until the student edits.
  Object? _sendError;

  /// The text in the field is worth sending (non-empty after trimming).
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  /// Jumps to the end of the thread once the frame that adds to it is laid
  /// out. Two passes: a lazy list only knows its true length after it has
  /// built what it jumped over.
  void _scrollToEnd({bool animate = false, int passes = 2}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final end = _scroll.position.maxScrollExtent;
      if (animate && passes == 2) {
        _scroll.animateTo(
          end,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else {
        _scroll.jumpTo(end);
      }
      if (passes > 1 && !animate) _scrollToEnd(passes: passes - 1);
    });
  }

  Future<void> _send() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    final notifier = ref.read(supportThreadProvider(widget.ticketId).notifier);
    final outcome = await notifier.sendReply(text);
    if (!mounted) return;

    switch (outcome) {
      case SendReplySent():
        // Clear only what was sent: text typed while it was in flight stays.
        if (_controller.text == text) _controller.clear();
        setState(() => _sendError = null);
        _scrollToEnd(animate: true);
        _focus.requestFocus();
      case SendReplyClosed():
        // The thread is now closed; the bar replaces the composer.
        setState(() => _sendError = null);
      case SendReplyFailed(:final error):
        setState(() => _sendError = error);
      case SendReplyIgnored():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final thread = ref.watch(supportThreadProvider(widget.ticketId));
    final notifier = ref.read(supportThreadProvider(widget.ticketId).notifier);
    // The student's own avatar, off `GET /me`. Null until it lands (or if it
    // fails): the disc then shows its gradient.
    final avatarUrl = ref.watch(
      meProvider.select((me) => me.value?.avatar.url),
    );

    final state = thread.when<ScreenState<SupportThread>>(
      // Never empty: the ticket's own details are always the first row.
      data: ScreenLoaded.new,
      loading: ScreenLoading<SupportThread>.new,
      error: (error, _) => isOffline(error)
          ? ScreenOffline<SupportThread>()
          : ScreenError<SupportThread>('genericError', cause: error),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(title: thread.value?.ticket.subject),
            Expanded(
              child: StateWidget<SupportThread>(
                state: state,
                onRetry: notifier.refresh,
                loading: const Center(child: CircularProgressIndicator()),
                error: SupportStateMessage(
                  icon: Icons.error_outline,
                  text: supportLoadFailureText(l10n, thread.error),
                  retryKey: const Key('support_thread_retry'),
                  // Withheld for a rate-limited call, a pending deletion and
                  // an unknown ticket (404 not_found): none of them is cured
                  // by asking again.
                  onRetry: supportRetryAllowed(thread.error)
                      ? notifier.refresh
                      : null,
                ),
                offline: SupportStateMessage(
                  icon: Icons.wifi_off,
                  text: l10n.offline,
                  retryKey: const Key('support_thread_retry'),
                  onRetry: notifier.refresh,
                ),
                onLoaded: (data) {
                  if (!_didInitialScroll) {
                    _didInitialScroll = true;
                    _scrollToEnd();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _Messages(
                          thread: data,
                          avatarUrl: avatarUrl,
                          controller: _scroll,
                          onLoadMore: notifier.loadMore,
                        ),
                      ),
                      if (data.isClosed)
                        SupportClosedBar(
                          key: const Key('support_closed_bar'),
                          onNewTicket: () => context.push('/support/new'),
                        )
                      else
                        SupportComposer(
                          controller: _controller,
                          focusNode: _focus,
                          canSend: _hasText && !data.isSending,
                          sending: data.isSending,
                          onSend: _send,
                          onChanged: (_) {
                            if (_sendError != null) {
                              setState(() => _sendError = null);
                            }
                          },
                          errorText: _sendError == null
                              ? null
                              : supportActionFailureText(l10n, _sendError),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The thread header · Figma `178:3398`: at least 63 high, a 1.18 divider at the
/// bottom, the shared back chip 21 from the start edge and the ticket's subject
/// centred, 18 SemiBold.
///
/// **The frame draws one line; the build allows two.** The subject (up to 120
/// characters) is shown nowhere else on the thread - the first row is the
/// ticket's `details`, not its subject - so one ellipsised line would hide what
/// the student titled their ticket. The title wraps to at most two lines (an
/// ellipsis after that) and the 63 is a MINIMUM: a short subject gives exactly
/// the frame's header, a longer one or a larger text scale grows it, the title
/// and the chip staying centred and the divider at the bottom.
///
/// The subject is the student's own text, in whatever language they wrote it,
/// so it is laid out in the direction of its first strong character (BUG-020's
/// rule), like the list's rows.
///
/// The title is empty until the ticket loads: the chip is always there, so the
/// student can leave from a loading, failed or offline thread.
class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String? title;

  static const _minHeight = 63.0;
  static const _divider = 1.18;
  static const _chipStart = 21.0;
  static const _chip = 35.0;

  /// The title keeps clear of the chip on both sides, so it stays centred.
  static const _titleInset = _chipStart + _chip + 12;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final title = this.title;

    return Container(
      key: const Key('support_thread_header'),
      constraints: const BoxConstraints(minHeight: _minHeight),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ext.supportThreadDivider, width: _divider),
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // Always present, so the stack has an in-flow child to take its
          // height from; empty until the ticket loads.
          if (title == null)
            const SizedBox.shrink()
          else
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: _titleInset,
              ),
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  textDirection: contentTextDirection(
                    title,
                    fallback: Directionality.of(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppType.h3.copyWith(color: ext.supportInk),
                ),
              ),
            ),
          PositionedDirectional(
            start: _chipStart,
            child: CircleBackButton(
              key: const Key('support_thread_back'),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}

/// The messages · Figma `178:3410`: 21 either side, 42 under the header, 20
/// between rows. The ticket's details first, then the replies; then a footer
/// slot for Load more / its spinner / its own Retry.
class _Messages extends StatelessWidget {
  const _Messages({
    required this.thread,
    required this.avatarUrl,
    required this.controller,
    required this.onLoadMore,
  });

  final SupportThread thread;
  final String? avatarUrl;
  final ScrollController controller;
  final Future<void> Function() onLoadMore;

  static const _gap = 20.0;

  @override
  Widget build(BuildContext context) {
    final replies = thread.messages;

    return ListView.separated(
      controller: controller,
      padding: const EdgeInsetsDirectional.fromSTEB(21, 42, 21, 20),
      // The details, every reply, and the footer slot.
      itemCount: replies.length + 2,
      separatorBuilder: (_, _) => const SizedBox(height: _gap),
      itemBuilder: (context, index) {
        if (index == 0) {
          return SupportMessageRow(
            key: const Key('support_ticket_details'),
            author: SupportMessageAuthor.student,
            body: thread.ticket.details,
            avatarUrl: avatarUrl,
          );
        }
        if (index == replies.length + 1) {
          return _Footer(thread: thread, onLoadMore: onLoadMore);
        }

        final reply = replies[index - 1];
        return SupportMessageRow(
          key: Key('support_message_${reply.messageId}'),
          author: reply.isStudent
              ? SupportMessageAuthor.student
              : SupportMessageAuthor.staff,
          body: reply.body,
          avatarUrl: avatarUrl,
        );
      },
    );
  }
}

/// After the last message: a spinner while appending, the append's own Retry
/// when it failed, Load more while the server says there is more and gave a
/// cursor to follow, and nothing once the thread is finished. Branches on
/// `hasMore`, never on the row count.
class _Footer extends StatelessWidget {
  const _Footer({required this.thread, required this.onLoadMore});

  final SupportThread thread;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    if (thread.isLoadingMore) {
      return const Center(child: CircularProgressIndicator());
    }

    final appendError = thread.appendError;
    if (appendError != null) {
      return Center(
        child: supportRetryAllowed(appendError)
            ? TextButton(
                key: const Key('support_thread_append_retry'),
                onPressed: onLoadMore,
                child: Text(l10n.retry),
              )
            : Text(
                supportLoadFailureText(l10n, appendError),
                textAlign: TextAlign.center,
                style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
              ),
      );
    }

    if (thread.hasMore && thread.nextCursor != null) {
      return Center(
        child: TextButton(
          key: const Key('support_thread_load_more'),
          onPressed: onLoadMore,
          child: Text(l10n.loadMore),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
