import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../domain/models/wod.dart';
import '../../domain/models/wod_key.dart';
import '../../domain/models/wod_log_entry.dart';
import '../log/wod_log_cubit.dart';
import '../theme/program_palette.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';
import '../timer/workout_timer.dart';
import '../timer/workout_timer_screen.dart';
import '../widgets/program_badge.dart';
import '../widgets/section_block.dart';
import 'wod_focus_screen.dart';

/// A full-screen view of a single [Wod] with share, focus and timer
/// actions, plus a done toggle that writes into the training log.
class WodDetailScreen extends StatefulWidget {
  /// Creates a [WodDetailScreen] for [wod].
  const WodDetailScreen({required this.wod, super.key});

  /// The workout to display in full.
  final Wod wod;

  @override
  State<WodDetailScreen> createState() => _WodDetailScreenState();
}

class _WodDetailScreenState extends State<WodDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Keep the screen awake while you're reading the workout.
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _share() {
    Share.share(_shareText(widget.wod));
  }

  void _openFocus() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WodFocusScreen(wod: widget.wod),
        fullscreenDialog: true,
      ),
    );
  }

  void _openTimer() {
    final spec = detectTimer(widget.wod) ?? defaultCountdown;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkoutTimerScreen(spec: spec),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wod = widget.wod;
    final accent = programAccent(wod.program);
    final note = wod.note;

    return Scaffold(
      appBar: AppBar(
        title: Text(wod.branch.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.crop_free_rounded),
            tooltip: 'Focus mode',
            onPressed: _openFocus,
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Share',
            onPressed: _share,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTimer,
        icon: const Icon(Icons.timer_outlined),
        label: const Text('START TIMER'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          VogueSpace.lg,
          VogueSpace.lg,
          VogueSpace.lg,
          // Pad past the Android system nav bar and the FAB.
          VogueSpace.xxl * 3 + MediaQuery.viewPaddingOf(context).bottom,
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
          const Divider(height: VogueSpace.xxl),
          _LogSection(wod: wod, accent: accent),
        ],
      ),
    );
  }
}

class _LogSection extends StatelessWidget {
  const _LogSection({required this.wod, required this.accent});

  final Wod wod;
  final Color accent;

  Future<void> _markWithDetails(
    BuildContext context, {
    WodLogEntry? edit,
  }) async {
    final result = await showModalBottomSheet<_LogDetails>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DetailsSheet(initial: edit),
    );
    if (result == null) return;
    if (!context.mounted) return;
    await context.read<WodLogCubit>().mark(
      wod,
      score: result.score,
      note: result.note,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WodLogCubit, Map<String, WodLogEntry>>(
      builder: (context, entries) {
        final entry = entries[wod.key];
        if (entry == null) {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.read<WodLogCubit>().mark(wod),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('DONE'),
                ),
              ),
              const SizedBox(width: VogueSpace.md),
              OutlinedButton(
                onPressed: () => _markWithDetails(context),
                child: const Text('+ DETAILS'),
              ),
            ],
          );
        }
        return Container(
          padding: const EdgeInsets.all(VogueSpace.md),
          decoration: BoxDecoration(
            color: VogueColors.primarySoft,
            borderRadius: BorderRadius.circular(VogueRadius.md),
            border: Border.all(
              color: VogueColors.primary.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: VogueColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: VogueSpace.sm),
                  Text(
                    'Done · ${DateFormat('d MMM, HH:mm').format(entry.doneAt)}',
                    style: VogueTypography.label.copyWith(
                      color: VogueColors.primary,
                    ),
                  ),
                ],
              ),
              if (entry.score != null && entry.score!.isNotEmpty) ...[
                const SizedBox(height: VogueSpace.sm),
                Text(
                  entry.score!,
                  style: VogueTypography.workout.copyWith(color: accent),
                ),
              ],
              if (entry.note != null && entry.note!.isNotEmpty) ...[
                const SizedBox(height: VogueSpace.xs),
                Text(
                  entry.note!,
                  style: VogueTypography.body.copyWith(
                    color: VogueColors.inkMuted,
                  ),
                ),
              ],
              const SizedBox(height: VogueSpace.sm),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _markWithDetails(context, edit: entry),
                    child: const Text('EDIT'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.read<WodLogCubit>().unmark(wod),
                    child: const Text('REMOVE'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LogDetails {
  const _LogDetails({this.score, this.note});

  final String? score;
  final String? note;
}

class _DetailsSheet extends StatefulWidget {
  const _DetailsSheet({this.initial});

  final WodLogEntry? initial;

  @override
  State<_DetailsSheet> createState() => _DetailsSheetState();
}

class _DetailsSheetState extends State<_DetailsSheet> {
  late final TextEditingController _score = TextEditingController(
    text: widget.initial?.score ?? '',
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.initial?.note ?? '',
  );

  @override
  void dispose() {
    _score.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        VogueSpace.lg,
        VogueSpace.lg,
        VogueSpace.lg,
        VogueSpace.lg + viewInsets,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initial == null ? 'Log this WOD' : 'Edit log',
            style: VogueTypography.headline.copyWith(color: VogueColors.ink),
          ),
          const SizedBox(height: VogueSpace.lg),
          TextField(
            controller: _score,
            decoration: const InputDecoration(
              labelText: 'Score',
              hintText: 'e.g. 12+3 rounds, 8:45 Rx, 135#',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: VogueSpace.md),
          TextField(
            controller: _note,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Note',
              hintText: 'How it felt, what to remember…',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: VogueSpace.lg),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(
                  _LogDetails(
                    score: _score.text.trim().isEmpty
                        ? null
                        : _score.text.trim(),
                    note: _note.text.trim().isEmpty ? null : _note.text.trim(),
                  ),
                ),
                child: const Text('SAVE'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _shareText(Wod wod) {
  final buf = StringBuffer()
    ..writeln('${wod.branch.displayName} — ${wod.program.label}')
    ..writeln(DateFormat('EEEE, d MMMM').format(wod.date))
    ..writeln();
  for (final s in wod.sections) {
    if (s.title != null) buf.writeln(s.title!.toUpperCase());
    for (final l in s.lines) {
      buf.writeln(l);
    }
    buf.writeln();
  }
  return buf.toString().trim();
}
