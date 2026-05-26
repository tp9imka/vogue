import 'package:freezed_annotation/freezed_annotation.dart';

import 'branch.dart';
import 'program.dart';

part 'wod_log_entry.freezed.dart';
part 'wod_log_entry.g.dart';

/// A user-recorded "I did this WOD" entry.
@freezed
abstract class WodLogEntry with _$WodLogEntry {
  /// Creates a [WodLogEntry].
  const factory WodLogEntry({
    required String wodKey,
    required DateTime doneAt,
    required DateTime wodDate,
    required Branch branch,
    required Program program,
    String? score,
    String? note,
  }) = _WodLogEntry;

  /// Deserialises a [WodLogEntry] from stored JSON.
  factory WodLogEntry.fromJson(Map<String, dynamic> json) =>
      _$WodLogEntryFromJson(json);
}
