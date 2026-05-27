import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';
import 'workout_timer.dart';

/// Full-screen workout timer for the supplied [TimerSpec].
class WorkoutTimerScreen extends StatefulWidget {
  /// Creates a [WorkoutTimerScreen].
  const WorkoutTimerScreen({required this.spec, super.key});

  /// The configured timer.
  final TimerSpec spec;

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
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
    return BlocProvider(
      create: (_) => TimerCubit(widget.spec),
      child: const _TimerView(),
    );
  }
}

class _TimerView extends StatelessWidget {
  const _TimerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VogueColors.surface,
      appBar: AppBar(
        title: const Text('Timer'),
        leading: const CloseButton(),
      ),
      body: BlocBuilder<TimerCubit, TimerStateData>(
        builder: (context, state) {
          final phase = _phaseFor(state);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VogueSpace.xl,
                VogueSpace.lg,
                VogueSpace.xl,
                VogueSpace.lg,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    state.spec.mode.label.toUpperCase(),
                    style: VogueTypography.label.copyWith(
                      color: VogueColors.primary,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  if (phase.roundLabel != null) ...[
                    const SizedBox(height: VogueSpace.sm),
                    Text(
                      phase.roundLabel!,
                      style: VogueTypography.title.copyWith(
                        color: VogueColors.inkMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: VogueSpace.xl),
                  Text(
                    _formatDuration(phase.display),
                    style: VogueTypography.timer.copyWith(
                      color: VogueColors.ink,
                    ),
                  ),
                  if (phase.subLabel != null) ...[
                    const SizedBox(height: VogueSpace.lg),
                    Text(
                      phase.subLabel!,
                      style: VogueTypography.headline.copyWith(
                        color: phase.subColor ?? VogueColors.ink,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                  if (state.finished) ...[
                    const SizedBox(height: VogueSpace.md),
                    Text(
                      'TIME',
                      style: VogueTypography.display.copyWith(
                        color: VogueColors.primary,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(VogueRadius.pill),
                    child: LinearProgressIndicator(
                      value: phase.progress,
                      minHeight: 10,
                      color: phase.subColor ?? VogueColors.primary,
                      backgroundColor: VogueColors.surfaceHigh,
                    ),
                  ),
                  const SizedBox(height: VogueSpace.xl),
                  _Controls(state: state),
                  const SizedBox(height: VogueSpace.md),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.state});

  final TimerStateData state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TimerCubit>();
    if (state.finished) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: cubit.reset,
          child: const Text('RESET'),
        ),
      );
    }
    final canReset = state.elapsed > Duration.zero;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: canReset ? cubit.reset : null,
            child: const Text('RESET'),
          ),
        ),
        const SizedBox(width: VogueSpace.md),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: state.running ? cubit.pause : cubit.start,
            child: Text(
              state.running
                  ? 'PAUSE'
                  : (state.elapsed == Duration.zero ? 'START' : 'RESUME'),
            ),
          ),
        ),
      ],
    );
  }
}

class _Phase {
  const _Phase({
    required this.display,
    required this.progress,
    this.roundLabel,
    this.subLabel,
    this.subColor,
  });

  final Duration display;
  final double progress;
  final String? roundLabel;
  final String? subLabel;
  final Color? subColor;
}

_Phase _phaseFor(TimerStateData s) {
  final spec = s.spec;
  switch (spec.mode) {
    case TimerMode.forTime:
      return _Phase(display: s.elapsed, progress: 0);

    case TimerMode.amrap:
    case TimerMode.countdown:
      final totalMs = spec.total.inMilliseconds;
      final remaining = spec.total - s.elapsed;
      final progress = totalMs == 0
          ? 0.0
          : (s.elapsed.inMilliseconds / totalMs).clamp(0.0, 1.0);
      return _Phase(
        display: remaining.isNegative ? Duration.zero : remaining,
        progress: progress,
      );

    case TimerMode.emom:
      var round = (s.elapsed.inSeconds ~/ 60) + 1;
      if (round > spec.rounds) round = spec.rounds;
      final phaseMs = s.elapsed.inMilliseconds - (round - 1) * 60000;
      final phaseRemaining = Duration(milliseconds: 60000 - phaseMs);
      return _Phase(
        display: phaseRemaining.isNegative ? Duration.zero : phaseRemaining,
        progress: (phaseMs / 60000).clamp(0.0, 1.0),
        roundLabel: 'Round $round / ${spec.rounds}',
      );

    case TimerMode.tabata:
      final cycleMs = (spec.work + spec.rest).inMilliseconds;
      var round = (s.elapsed.inMilliseconds ~/ cycleMs) + 1;
      if (round > spec.rounds) round = spec.rounds;
      final inCycle = s.elapsed.inMilliseconds % cycleMs;
      final isWork = inCycle < spec.work.inMilliseconds;
      final phaseTotal = isWork
          ? spec.work.inMilliseconds
          : spec.rest.inMilliseconds;
      final phaseElapsed = isWork
          ? inCycle
          : inCycle - spec.work.inMilliseconds;
      final phaseRemaining = Duration(milliseconds: phaseTotal - phaseElapsed);
      return _Phase(
        display: phaseRemaining.isNegative ? Duration.zero : phaseRemaining,
        progress: phaseTotal == 0
            ? 0.0
            : (phaseElapsed / phaseTotal).clamp(0.0, 1.0),
        roundLabel: 'Round $round / ${spec.rounds}',
        subLabel: isWork ? 'WORK' : 'REST',
        subColor: isWork ? VogueColors.primary : VogueColors.warning,
      );
  }
}

String _formatDuration(Duration d) {
  final secs = d.inSeconds < 0 ? 0 : d.inSeconds;
  final mm = (secs ~/ 60).toString().padLeft(2, '0');
  final ss = (secs % 60).toString().padLeft(2, '0');
  return '$mm:$ss';
}
