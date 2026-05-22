import 'package:flutter/material.dart';

import '../../domain/models/program.dart';
import '../theme/program_palette.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';

/// A small, color-coded pill naming a [Program] type.
class ProgramBadge extends StatelessWidget {
  /// Creates a [ProgramBadge] for [program].
  const ProgramBadge(this.program, {super.key});

  /// The program whose label and color this badge shows.
  final Program program;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VogueSpace.md,
        vertical: VogueSpace.xs,
      ),
      decoration: BoxDecoration(
        color: programAccent(program),
        borderRadius: BorderRadius.circular(VogueRadius.pill),
      ),
      child: Text(
        program.label.toUpperCase(),
        style: VogueTypography.label.copyWith(color: VogueColors.onSemantic),
      ),
    );
  }
}
