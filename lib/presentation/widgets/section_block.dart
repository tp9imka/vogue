import 'package:flutter/material.dart';

import '../../domain/models/wod_section.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';

/// Renders one [WodSection] — an optional heading plus its lines.
class SectionBlock extends StatelessWidget {
  /// Creates a [SectionBlock] for [section], headings tinted with [accent].
  const SectionBlock(this.section, {this.accent, super.key});

  /// The section to render.
  final WodSection section;

  /// Color for the section heading; defaults to the brand accent.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final title = section.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title.toUpperCase(),
            style: VogueTypography.label.copyWith(
              color: accent ?? VogueColors.primary,
            ),
          ),
          const SizedBox(height: VogueSpace.sm),
        ],
        for (final line in section.lines)
          Padding(
            padding: const EdgeInsets.only(bottom: VogueSpace.xs),
            child: Text(
              line,
              style: VogueTypography.workout.copyWith(color: VogueColors.ink),
            ),
          ),
      ],
    );
  }
}
