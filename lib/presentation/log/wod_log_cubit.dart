import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/wod_log_store.dart';
import '../../domain/models/wod.dart';
import '../../domain/models/wod_key.dart';
import '../../domain/models/wod_log_entry.dart';

/// Owns the user's training-log state, keyed by [WodKey].
class WodLogCubit extends Cubit<Map<String, WodLogEntry>> {
  /// Creates a [WodLogCubit].
  WodLogCubit(this._store) : super(const {});

  final WodLogStore _store;

  /// Hydrates state from persistent storage.
  Future<void> load() async => emit(await _store.readAll());

  /// Marks [wod] as done, optionally with a [score] and [note].
  Future<void> mark(Wod wod, {String? score, String? note}) async {
    final entry = WodLogEntry(
      wodKey: wod.key,
      doneAt: DateTime.now(),
      wodDate: wod.date,
      branch: wod.branch,
      program: wod.program,
      score: score,
      note: note,
    );
    await _store.upsert(entry);
    emit({...state, entry.wodKey: entry});
  }

  /// Removes the log entry for [wod], if one exists.
  Future<void> unmark(Wod wod) async {
    await _store.remove(wod.key);
    emit(Map.of(state)..remove(wod.key));
  }

  /// Whether [wod] is currently in the log.
  bool isDone(Wod wod) => state.containsKey(wod.key);

  /// The entry for [wod], or null if not done.
  WodLogEntry? entryFor(Wod wod) => state[wod.key];
}
