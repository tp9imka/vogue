import 'package:flutter/material.dart';

import '../../domain/models/wod.dart';
import '../theme/program_palette.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';
import 'program_badge.dart';
import 'section_block.dart';

/// A card showing one [Wod] — branch, program badge and workout content.
///
/// When [expanded] is true every section is shown (used on the Today
/// screen); when false only the first section is previewed and tapping
/// the card opens the full WOD (used on the Browse screen).
class WodCard extends StatelessWidget {
  /// Creates a [WodCard] for [wod].
  const WodCard({
    required this.wod,
    this.expanded = true,
    this.onTap,
    super.key,
  });

  /// The workout this card shows.
  final Wod wod;

  /// Whether to render every section or just the first as a preview.
  final bool expanded;

  /// Tapped-card callback — typically navigates to the WOD detail screen.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = programAccent(wod.program);
    final sections = expanded ? wod.sections : wod.sections.take(1).toList();
    final hasMore = !expanded && wod.sections.length > 1;
    final note = wod.note;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VogueSpace.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              wod.branch.displayName,
                              style: VogueTypography.title.copyWith(
                                color: VogueColors.ink,
                              ),
                            ),
                          ),
                          ProgramBadge(wod.program),
                        ],
                      ),
                      const SizedBox(height: VogueSpace.md),
                      for (var i = 0; i < sections.length; i++) ...[
                        if (i > 0) const SizedBox(height: VogueSpace.md),
                        SectionBlock(sections[i], accent: accent),
                      ],
                      if (hasMore) ...[
                        const SizedBox(height: VogueSpace.md),
                        Row(
                          children: [
                            Text(
                              'View full WOD',
                              style: VogueTypography.label.copyWith(
                                color: accent,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: accent,
                            ),
                          ],
                        ),
                      ],
                      if (expanded && note != null) ...[
                        const SizedBox(height: VogueSpace.md),
                        Text(
                          note,
                          style: VogueTypography.body.copyWith(
                            color: VogueColors.inkFaint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
