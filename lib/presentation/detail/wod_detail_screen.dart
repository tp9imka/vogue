import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/wod.dart';
import '../theme/program_palette.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';
import '../widgets/program_badge.dart';
import '../widgets/section_block.dart';

/// A full-screen view of a single [Wod].
class WodDetailScreen extends StatelessWidget {
  /// Creates a [WodDetailScreen] for [wod].
  const WodDetailScreen({required this.wod, super.key});

  /// The workout to display in full.
  final Wod wod;

  @override
  Widget build(BuildContext context) {
    final accent = programAccent(wod.program);
    final note = wod.note;

    return Scaffold(
      appBar: AppBar(title: Text(wod.branch.displayName)),
      body: ListView(
        // Pad past the Android system nav bar so the last lines of the
        // workout stay fully visible when scrolled to the end.
        padding: EdgeInsets.fromLTRB(
          VogueSpace.lg,
          VogueSpace.lg,
          VogueSpace.lg,
          VogueSpace.lg + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          Row(
            children: [
              ProgramBadge(wod.program),
              const SizedBox(width: VogueSpace.md),
              Expanded(
                child: Text(
                  DateFormat('EEEE, d MMMM').format(wod.date),
                  style: VogueTypography.body.copyWith(
                    color: VogueColors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: VogueSpace.xl),
          for (var i = 0; i < wod.sections.length; i++) ...[
            if (i > 0) const SizedBox(height: VogueSpace.xl),
            SectionBlock(wod.sections[i], accent: accent),
          ],
          if (note != null) ...[
            const Divider(height: VogueSpace.xxl),
            Text(
              note,
              style: VogueTypography.body.copyWith(
                color: VogueColors.inkFaint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
