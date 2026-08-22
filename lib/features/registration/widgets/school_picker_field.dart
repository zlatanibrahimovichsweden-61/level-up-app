import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../l10n/app_localizations.dart';
import '../models/reference_models.dart';
import '../notifier/school_search_notifier.dart';
import '../registration_error_copy.dart';
import 'city_field.dart';
import 'reference_dropdown.dart';

/// The Egyptian coded-school picker (`GET /reference/schools`).
///
/// Egypt only: the coded list is Egyptian, so this field exists on no other
/// country's flow (adr-028 §2). It is a searchable, cursor-paginated sheet
/// rather than a dropdown because the list is far too large to load at once.
///
/// Picking a school is OPTIONAL for everyone since adr-028 §2 — there is no
/// free-text alternative anywhere, in or out of Egypt.
///
/// The field itself shows the chosen school's name; tapping opens the sheet.
class SchoolPickerField extends ConsumerWidget {
  const SchoolPickerField({
    super.key,
    required this.governorateId,
    required this.cityId,
    required this.selected,
    required this.onSelected,
    required this.skipped,
    required this.onSkip,
    this.errorText,
  });

  /// Scope filters — both may be null, in which case the search is unscoped.
  ///
  /// A free-text city has no `cityId`, so the search falls back to
  /// governorate-only scoping rather than being disabled: an Egyptian student
  /// whose city is missing from the coded list can still find their school.
  final String? governorateId;
  final String? cityId;

  /// The already-chosen school (kept so the field can show its name without
  /// re-querying).
  final NamedRef? selected;

  final ValueChanged<NamedRef> onSelected;

  /// True once the student has used the skip affordance. The field then reads
  /// as RESOLVED rather than as an empty field they left unfinished — an
  /// optional step that still looks blank is one students go back and worry at.
  final bool skipped;
  final VoidCallback onSkip;

  final String? errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final school = selected;

    final (String text, Color colour) = switch (school) {
      final NamedRef row => (
        localizedRefName(context, row.nameAr, row.nameEn),
        ext.textPrimary,
      ),
      null when skipped => (l10n.schoolSkipped, ext.textSecondary),
      null => (l10n.searchSchoolsHint, ext.hint),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(l10n.schoolLabel),
        const SizedBox(height: 8),
        FieldShell(
          key: const Key('field-schoolId'),
          hasError: errorText != null,
          semanticLabel: l10n.schoolLabel,
          onTap: () async {
            final picked = await showModalBottomSheet<NamedRef>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => _SchoolSearchSheet(
                governorateId: governorateId,
                cityId: cityId,
              ),
            );
            // Picking a school after skipping un-skips — the caller clears its
            // own `skipped` flag in `onSelected`.
            if (picked != null) onSelected(picked);
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: AppType.bodyLarge.copyWith(color: colour),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.search, size: 20, color: ext.hint),
            ],
          ),
        ),
        if (errorText != null) InlineFieldError(errorText!),
        // adr-028 §2. Hidden once skipped: the field already says so, and a
        // live "I can't find my school" under a resolved field reads as an
        // action still outstanding.
        if (!skipped)
          RegistrationEscapeLink(label: l10n.schoolNotFound, onTap: onSkip),
      ],
    );
  }
}

/// The searchable, paginated sheet. Typing is debounced so a keystroke doesn't
/// become a request; scrolling to the end appends the next cursor page.
class _SchoolSearchSheet extends ConsumerStatefulWidget {
  const _SchoolSearchSheet({required this.governorateId, required this.cityId});

  final String? governorateId;
  final String? cityId;

  @override
  ConsumerState<_SchoolSearchSheet> createState() => _SchoolSearchSheetState();
}

class _SchoolSearchSheetState extends ConsumerState<_SchoolSearchSheet> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  /// The committed query (debounced) — changing it swaps the family key.
  String? _query;

  static const _debounceDelay = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  SchoolFilter get _filter =>
      (q: _query, governorateId: widget.governorateId, cityId: widget.cityId);

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDelay, () {
      final trimmed = value.trim();
      if (!mounted) return;
      setState(() => _query = trimmed.isEmpty ? null : trimmed);
    });
  }

  /// Appends the next page as the end of the list comes into view. This is
  /// paging, not a retry: a failed append surfaces its own button.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(schoolSearchProvider(_filter).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final results = ref.watch(schoolSearchProvider(_filter));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ext.fieldBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 12),
              child: PlainTextField(
                controller: _searchController,
                hint: l10n.searchSchoolsHint,
                onChanged: _onQueryChanged,
              ),
            ),
            Expanded(
              child: switch (results) {
                AsyncLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                AsyncError(:final error) => _SheetFailure(
                  message: referenceErrorMessage(l10n, error),
                  isOffline: isOffline(error),
                  onRetry: () => ref
                      .read(schoolSearchProvider(_filter).notifier)
                      .refresh(),
                ),
                AsyncData(value: final data) when data.isEmpty => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.noSchoolsFound,
                      textAlign: TextAlign.center,
                      style: AppType.bodyLarge.copyWith(color: ext.hint),
                    ),
                  ),
                ),
                AsyncData(value: final data) => ListView.builder(
                  controller: _scrollController,
                  itemCount: data.items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == data.items.length) {
                      return _ListFooter(
                        results: data,
                        onRetryAppend: () => ref
                            .read(schoolSearchProvider(_filter).notifier)
                            .loadMore(),
                      );
                    }
                    final school = data.items[index];
                    return ListTile(
                      title: Text(
                        localizedRefName(context, school.nameAr, school.nameEn),
                      ),
                      onTap: () => Navigator.of(context).pop(school),
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom-of-list slot: the appending spinner, a failed-append retry, or
/// nothing once the cursor is exhausted.
class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.results, required this.onRetryAppend});

  final SchoolSearchResults results;
  final VoidCallback onRetryAppend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (results.appendError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetryAppend,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ),
      );
    }
    if (results.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (results.hasMore) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: TextButton(
            onPressed: onRetryAppend,
            child: Text(l10n.loadMore),
          ),
        ),
      );
    }
    return const SizedBox(height: 16);
  }
}

class _SheetFailure extends StatelessWidget {
  const _SheetFailure({
    required this.message,
    required this.isOffline,
    required this.onRetry,
  });

  final String message;
  final bool isOffline;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isOffline ? Icons.wifi_off : Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(message),
          const SizedBox(height: 12),
          // User-tapped retry — never a silent auto-retry.
          FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
