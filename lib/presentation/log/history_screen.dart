import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/models/wod_log_entry.dart';
import '../theme/program_palette.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';
import '../widgets/app_states.dart';
import '../widgets/program_badge.dart';
import 'wod_log_cubit.dart';

/// The History tab — every WOD the user has marked done.
class HistoryScreen extends StatelessWidget {
  /// Creates a [HistoryScreen].
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: BlocBuilder<WodLogCubit, Map<String, WodLogEntry>>(
        builder: (context, entries) {
          if (entries.isEmpty) {
            return const EmptyView(
              icon: Icons.history_rounded,
              message:
                  'No WODs logged yet.\n'
                  'Tap DONE on a workout to start your training log.',
            );
          }
          final list = entries.values.toList()
            ..sort((a, b) => b.doneAt.compareTo(a.doneAt));
          final now = DateTime.now();
          final weekStart = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: now.weekday - 1));
          final thisWeek = list
              .where((e) => !e.doneAt.isBefore(weekStart))
              .length;
          return ListView(
            padding: EdgeInsets.fromLTRB(
              VogueSpace.lg,
              VogueSpace.lg,
              VogueSpace.lg,
              VogueSpace.xxl + MediaQuery.viewPaddingOf(context).bottom,
            ),
            children: [
              _StatsCard(thisWeek: thisWeek, total: list.length),
              const SizedBox(height: VogueSpace.xl),
              for (final entry in list) ...[
                _LogTile(entry: entry),
                const SizedBox(height: VogueSpace.sm),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.thisWeek, required this.total});

  final int thisWeek;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(VogueSpace.lg),
      decoration: BoxDecoration(
        color: VogueColors.primarySoft,
        borderRadius: BorderRadius.circular(VogueRadius.md),
        border: Border.all(color: VogueColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(label: 'THIS WEEK', value: thisWeek.toString()),
          ),
          Container(
            width: 1,
            height: 48,
            color: VogueColors.outline,
          ),
          Expanded(
            child: _Stat(label: 'TOTAL', value: total.toString()),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: VogueTypography.display.copyWith(
            color: VogueColors.primary,
            fontSize: 40,
          ),
        ),
        const SizedBox(height: VogueSpace.xs),
        Text(
          label,
          style: VogueTypography.label.copyWith(color: VogueColors.inkMuted),
        ),
      ],
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final WodLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final accent = programAccent(entry.program);
    return Container(
      padding: const EdgeInsets.all(VogueSpace.md),
      decoration: BoxDecoration(
        color: VogueColors.surfaceRaised,
        borderRadius: BorderRadius.circular(VogueRadius.md),
        border: Border(left: BorderSide(color: accent, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.branch.displayName,
                  style: VogueTypography.title.copyWith(color: VogueColors.ink),
                ),
              ),
              ProgramBadge(entry.program),
            ],
          ),
          const SizedBox(height: VogueSpace.xs),
          Text(
            DateFormat('EEE, d MMM').format(entry.wodDate),
            style: VogueTypography.body.copyWith(color: VogueColors.inkMuted),
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
                color: VogueColors.inkFaint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
