import '../core/result.dart';
import 'models/wod.dart';

/// A point-in-time view of the WOD schedule.
class WodFeed {
  /// Creates a [WodFeed].
  const WodFeed({
    required this.wods,
    required this.fetchedAt,
    required this.stale,
  });

  /// Every WOD entry currently known (all branches, all dates).
  final List<Wod> wods;

  /// When this data was fetched from the network, if ever.
  final DateTime? fetchedAt;

  /// True when served from cache because a fresh fetch was not possible.
  final bool stale;
}

/// Port for reading the WOD schedule.
abstract class WodRepository {
  /// The cached snapshot if one exists (instant), else `null`.
  Future<WodFeed?> cached();

  /// Fetches fresh data.
  ///
  /// On network failure, falls back to the cached snapshot marked
  /// [WodFeed.stale]; only returns [Err] when there is nothing to show.
  Future<Result<WodFeed>> refresh();
}
