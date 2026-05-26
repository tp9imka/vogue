import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../domain/models/wod.dart';
import '../theme/program_palette.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';

/// A distraction-free, arm's-length-readable view of one [Wod].
///
/// Huge type, dark background, no app chrome — designed for glancing
/// down at the phone mid-session. Keeps the screen awake while open.
class WodFocusScreen extends StatefulWidget {
  /// Creates a [WodFocusScreen].
  const WodFocusScreen({required this.wod, super.key});

  /// The workout to show.
  final Wod wod;

  @override
  State<WodFocusScreen> createState() => _WodFocusScreenState();
}

class _WodFocusScreenState extends State<WodFocusScreen> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = programAccent(widget.wod.program);
    return Scaffold(
      backgroundColor: VogueColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(
                VogueSpace.lg,
                VogueSpace.xxl + 24,
                VogueSpace.lg,
                VogueSpace.xxl + MediaQuery.viewPaddingOf(context).bottom,
              ),
              children: [
                for (final section in widget.wod.sections) ...[
                  if (section.title != null) ...[
                    Text(
                      section.title!.toUpperCase(),
                      style: VogueTypography.label.copyWith(
                        color: accent,
                        fontSize: 18,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: VogueSpace.md),
                  ],
                  for (final line in section.lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: VogueSpace.sm),
                      child: Text(
                        line,
                        style: const TextStyle(
                          fontSize: 32,
                          height: 1.32,
                          fontWeight: FontWeight.w700,
                          color: VogueColors.ink,
                        ),
                      ),
                    ),
                  const SizedBox(height: VogueSpace.xl),
                ],
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 28),
                color: VogueColors.inkMuted,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
