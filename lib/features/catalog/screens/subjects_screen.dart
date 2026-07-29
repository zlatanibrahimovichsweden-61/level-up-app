import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/subject.dart';
import '../notifier/subjects_notifier.dart';
import '../widgets/catalog_scaffold.dart';
import '../widgets/catalog_states.dart';
import '../widgets/subject_card.dart';

/// Subjects — the Learn tab's landing screen · Figma `337:5702`.
///
/// Powered by ONE call, `GET /catalog/subjects`, which the server scopes to the
/// authenticated student (adr-013) — this screen sends no scope parameters and
/// must never start.
///
/// Tapping a card opens `/learn/subject/{id}`, which triggers the single tree
/// fetch that the whole drill-down then reads from.
class SubjectsScreen extends ConsumerStatefulWidget {
  const SubjectsScreen({super.key});

  @override
  ConsumerState<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends ConsumerState<SubjectsScreen> {
  /// Ephemeral local UI only — the query never leaves the device. `setState` is
  /// correct here precisely because there is no network state involved.
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subjects = ref.watch(subjectsProvider);
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    return CatalogScaffold(
      title: l10n.subjectsTitle,
      action: const _MistakesButton(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 25),
            child: _SearchField(
              controller: _controller,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: CatalogAsyncView<List<Subject>>(
              value: subjects,
              isEmpty: (data) => data.isEmpty,
              emptyMessage: l10n.noSubjects,
              onRetry: () => ref.read(subjectsProvider.notifier).refresh(),
              skeleton: const _SubjectsSkeleton(),
              onLoaded: (data) => _SubjectsGrid(
                subjects: filterSubjects(data, _query),
                // The list has rows but the FILTER matched none — a different
                // message from "you have no subjects", and not an error.
                noMatchMessage: l10n.noSubjectsMatch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Day-6 stub. The "retake your wrong answers" pool is not built yet, so this
/// says so instead of quietly doing nothing — a button that swallows taps reads
/// as a bug to the student.
class _MistakesButton extends StatelessWidget {
  const _MistakesButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 35),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        foregroundColor: cs.error,
        side: BorderSide(color: cs.error, width: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      child: Text(
        l10n.mistakes,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Figma `337:5723` — 56 tall, radius 15, no border. Deliberately not the shared
/// `FieldShell` (60 tall, radius 20, bordered): bending that component to fit
/// would change every registration field with it.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: 16, color: ext.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: ext.cardFill,
        hintText: l10n.searchSubjects,
        hintStyle: TextStyle(fontSize: 16, color: ext.mutedText),
        prefixIcon: Icon(Icons.search, color: ext.mutedText),
        contentPadding: const EdgeInsetsDirectional.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SubjectsGrid extends StatelessWidget {
  const _SubjectsGrid({required this.subjects, required this.noMatchMessage});

  final List<Subject> subjects;
  final String noMatchMessage;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return CatalogMessage(
        icon: Icons.search_off,
        text: noMatchMessage,
      );
    }

    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16.5,
        childAspectRatio: SubjectCard.aspectRatio,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return SubjectCard(
          subject: subject,
          // The ONE tree fetch for this subject starts here.
          onTap: () => context.go('/learn/subject/${subject.id}'),
        );
      },
    );
  }
}

class _SubjectsSkeleton extends StatelessWidget {
  const _SubjectsSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16.5,
        childAspectRatio: SubjectCard.aspectRatio,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => const CatalogBlock(height: 89),
    );
  }
}
