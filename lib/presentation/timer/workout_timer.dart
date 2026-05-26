import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/wod.dart';

part 'workout_timer.freezed.dart';

/// The supported timer formats — chosen to match how CrossFit programming
/// is written in `vfuae.com/wod/`.
enum TimerMode {
  /// As many rounds as possible in a fixed window — counts down.
  amrap('AMRAP'),

  /// Beat your last time — counts up unbounded.
  forTime('For Time'),

  /// Every minute on the minute for N minutes.
  emom('EMOM'),

  /// 20 seconds work, 10 seconds rest, N rounds.
  tabata('Tabata'),

  /// A plain countdown — used when no domain was detected.
  countdown('Countdown')
  ;

  const TimerMode(this.label);

  /// The display name shown in the timer screen.
  final String label;
}

/// A fully-specified timer configuration.
@freezed
abstract class TimerSpec with _$TimerSpec {
  /// Creates a [TimerSpec].
  const factory TimerSpec({
    required TimerMode mode,
    required Duration total,
    @Default(Duration.zero) Duration work,
    @Default(Duration.zero) Duration rest,
    @Default(1) int rounds,
  }) = _TimerSpec;
}

/// The default fallback when nothing is detected — a 10-minute countdown.
const TimerSpec defaultCountdown = TimerSpec(
  mode: TimerMode.countdown,
  total: Duration(minutes: 10),
);

/// Looks at [wod]'s text for a recognisable time domain. Returns null
/// when the programming doesn't declare one.
TimerSpec? detectTimer(Wod wod) {
  final buffer = StringBuffer();
  for (final s in wod.sections) {
    if (s.title != null) buffer.writeln(s.title);
    for (final l in s.lines) {
      buffer.writeln(l);
    }
  }
  final lower = buffer.toString().toLowerCase();

  if (lower.contains('tabata')) {
    final match = RegExp(
      r'tabata.*?(\d+)\s*rounds?',
      dotAll: true,
    ).firstMatch(lower);
    final rounds = match == null ? 8 : int.parse(match.group(1)!);
    return TimerSpec(
      mode: TimerMode.tabata,
      total: Duration(seconds: rounds * 30),
      work: const Duration(seconds: 20),
      rest: const Duration(seconds: 10),
      rounds: rounds,
    );
  }

  final emom = RegExp(
    r'(?:emom|every\s*minute(?:\s*on\s*the\s*minute)?)\s*(?:for\s*)?(\d+)',
  ).firstMatch(lower);
  if (emom != null) {
    final mins = int.parse(emom.group(1)!);
    return TimerSpec(
      mode: TimerMode.emom,
      total: Duration(minutes: mins),
      work: const Duration(minutes: 1),
      rounds: mins,
    );
  }

  final amrapInline = RegExp(
    r'(\d+)\s*(?:min(?:ute)?s?)\s*amrap',
  ).firstMatch(lower);
  final amrapTrailing = RegExp(
    r'amrap[^a-z\d]*?(\d+)\s*(?:min(?:ute)?s?)?',
  ).firstMatch(lower);
  final amrap = amrapInline ?? amrapTrailing;
  if (amrap != null) {
    final mins = int.parse(amrap.group(1)!);
    return TimerSpec(
      mode: TimerMode.amrap,
      total: Duration(minutes: mins),
    );
  }

  if (RegExp(r'for\s*time').hasMatch(lower)) {
    return const TimerSpec(mode: TimerMode.forTime, total: Duration.zero);
  }
  return null;
}

/// Live state of a running timer.
@freezed
abstract class TimerStateData with _$TimerStateData {
  /// Creates a [TimerStateData].
  const factory TimerStateData({
    required TimerSpec spec,
    required Duration elapsed,
    required bool running,
    required bool finished,
  }) = _TimerStateData;
}

/// Owns the workout-timer state. Drives an internal stopwatch and fires
/// haptics at phase / round transitions.
class TimerCubit extends Cubit<TimerStateData> {
  /// Creates a [TimerCubit] for [spec].
  TimerCubit(TimerSpec spec)
    : super(
        TimerStateData(
          spec: spec,
          elapsed: Duration.zero,
          running: false,
          finished: false,
        ),
      );

  Timer? _ticker;
  final Stopwatch _stopwatch = Stopwatch();
  Duration _base = Duration.zero;
  int _markRound = 0;
  bool _markWork = true;

  /// Starts or resumes the timer.
  void start() {
    if (state.finished) return;
    _stopwatch.start();
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 80),
      (_) => _tick(),
    );
    emit(state.copyWith(running: true));
  }

  /// Pauses the timer; elapsed time is preserved.
  void pause() {
    if (!state.running) return;
    _stopwatch.stop();
    _base += _stopwatch.elapsed;
    _stopwatch.reset();
    _ticker?.cancel();
    emit(state.copyWith(running: false));
  }

  /// Resets elapsed to zero and stops the timer.
  void reset() {
    _stopwatch
      ..stop()
      ..reset();
    _base = Duration.zero;
    _ticker?.cancel();
    _markRound = 0;
    _markWork = true;
    emit(
      state.copyWith(
        elapsed: Duration.zero,
        running: false,
        finished: false,
      ),
    );
  }

  void _tick() {
    final elapsed = _base + _stopwatch.elapsed;
    final spec = state.spec;
    var finished = false;
    if (spec.mode != TimerMode.forTime && spec.total > Duration.zero) {
      finished = elapsed >= spec.total;
    }
    if (spec.mode == TimerMode.tabata) {
      final cycle = (spec.work + spec.rest).inMilliseconds;
      if (cycle > 0) {
        final round = elapsed.inMilliseconds ~/ cycle + 1;
        final isWork =
            (elapsed.inMilliseconds % cycle) < spec.work.inMilliseconds;
        if (round != _markRound || isWork != _markWork) {
          if (_markRound != 0) HapticFeedback.mediumImpact();
          _markRound = round;
          _markWork = isWork;
        }
      }
    } else if (spec.mode == TimerMode.emom) {
      final round = elapsed.inSeconds ~/ 60 + 1;
      if (round != _markRound) {
        if (_markRound != 0) HapticFeedback.mediumImpact();
        _markRound = round;
      }
    }
    if (finished && !state.finished) {
      _stopwatch
        ..stop()
        ..reset();
      _base = spec.total;
      _ticker?.cancel();
      HapticFeedback.heavyImpact();
      emit(
        state.copyWith(
          elapsed: spec.total,
          finished: true,
          running: false,
        ),
      );
      return;
    }
    emit(state.copyWith(elapsed: elapsed, finished: finished));
  }

  @override
  Future<void> close() async {
    _ticker?.cancel();
    _stopwatch.stop();
    await super.close();
  }
}
