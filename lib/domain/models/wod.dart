import 'package:freezed_annotation/freezed_annotation.dart';

import 'branch.dart';
import 'program.dart';
import 'wod_section.dart';

part 'wod.freezed.dart';
part 'wod.g.dart';

/// A single workout-of-the-day entry for one branch on one date.
@freezed
abstract class Wod with _$Wod {
  /// Creates a [Wod].
  const factory Wod({
    required DateTime date,
    required Branch branch,
    required Program program,
    required List<WodSection> sections,
    String? note,
  }) = _Wod;

  /// Deserialises a [Wod] from cached JSON.
  factory Wod.fromJson(Map<String, dynamic> json) => _$WodFromJson(json);
}
