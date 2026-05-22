import 'package:freezed_annotation/freezed_annotation.dart';

part 'wod_section.freezed.dart';
part 'wod_section.g.dart';

/// One block of a workout — an optional heading plus its lines.
///
/// A WOD description is a sequence of these (e.g. `Prep`, `Metcon`,
/// `Strength`). A block with no [title] is loose lines under no heading.
@freezed
abstract class WodSection with _$WodSection {
  /// Creates a [WodSection].
  const factory WodSection({
    required List<String> lines,
    String? title,
  }) = _WodSection;

  /// Deserialises a [WodSection] from cached JSON.
  factory WodSection.fromJson(Map<String, dynamic> json) =>
      _$WodSectionFromJson(json);
}
