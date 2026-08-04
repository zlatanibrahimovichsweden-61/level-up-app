import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/subject_tree.dart';
import '../widgets/tree_list_row.dart';

/// Units — level 1 of the SCHOOL drill-down · Figma `337:5894`.
///
/// The loaded body of [SubjectTreeScreen] at `/learn/subject/:subjectId`, which
/// owns the header and the loading/empty/error/offline chrome for both tracks.
/// This widget is only ever built with a school tree already in hand.
///
/// No fetch happens here: the chapters behind every row are already inside the
/// object this list was built from.
class UnitsView extends StatelessWidget {
  const UnitsView({super.key, required this.subjectId, required this.units});

  final String subjectId;
  final List<Unit> units;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      itemCount: units.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final unit = units[index];
        return TreeListRow(
          index: index + 1,
          name: unit.name,
          // No `progress`: the contract gives units no questionCounter, and
          // summing their lessons' counters would be exactly the client-side
          // math the contract forbids. See docs/DESIGN_ISSUES.md #16.
          onTap: () => context.go('/learn/subject/$subjectId/unit/${unit.id}'),
        );
      },
    );
  }
}
