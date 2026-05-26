import 'wod.dart';

/// A stable string identity for a [Wod] — `YYYY-MM-DD_branch_program`.
///
/// Used as the primary key in the training log; a branch can run multiple
/// programs on one day, so date+branch alone is not enough.
extension WodKey on Wod {
  /// The stable log key.
  String get key {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}'
        '_${branch.name}_${program.name}';
  }
}
