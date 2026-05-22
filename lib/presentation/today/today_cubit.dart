import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../data/favorite_branch_store.dart';
import '../../domain/models/branch.dart';
import '../../domain/models/wod.dart';
import '../../domain/wod_repository.dart';

part 'today_cubit.freezed.dart';

/// State for the Today screen.
@freezed
sealed class TodayState with _$TodayState {
  /// Nothing to show yet — first load with no cache.
  const factory TodayState.loading() = TodayLoading;

  /// Loaded: the WODs for [branch] on [selectedDate].
  const factory TodayState.ready({
    required Branch branch,
    required DateTime selectedDate,
    required DateTime today,
    required List<Wod> wods,
    required List<DateTime> availableDates,
    required bool stale,
    DateTime? fetchedAt,
  }) = TodayReady;

  /// Load failed and there was no cached data to fall back to.
  const factory TodayState.error(String message) = TodayError;
}

DateTime _dayOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Owns the Today screen's state: the favorite branch, the selected day,
/// and the WODs filtered for that branch and day from the cached feed.
class TodayCubit extends Cubit<TodayState> {
  /// Creates a [TodayCubit]. [now] is injectable for tests.
  TodayCubit({
    required WodRepository repository,
    required FavoriteBranchStore favoriteStore,
    DateTime? now,
  }) : _repository = repository,
       _favoriteStore = favoriteStore,
       _today = _dayOnly(now ?? DateTime.now()),
       super(const TodayState.loading()) {
    _selectedDate = _today;
  }

  final WodRepository _repository;
  final FavoriteBranchStore _favoriteStore;
  final DateTime _today;

  WodFeed? _feed;
  Branch _branch = Branch.yasMarina;
  late DateTime _selectedDate;

  /// Loads the favorite branch, paints cached data instantly, then refreshes.
  Future<void> load() async {
    _branch = await _favoriteStore.read() ?? Branch.yasMarina;
    final cached = await _repository.cached();
    if (cached != null) {
      _feed = cached;
      _emitReady();
    }
    await refresh();
  }

  /// Fetches fresh data from the network.
  Future<void> refresh() async {
    final result = await _repository.refresh();
    switch (result) {
      case Ok<WodFeed>(:final value):
        _feed = value;
        _emitReady();
      case Err<WodFeed>(:final failure):
        if (_feed == null) emit(TodayState.error(failure.message));
    }
  }

  /// Selects a different day without re-fetching.
  void selectDate(DateTime date) {
    _selectedDate = _dayOnly(date);
    _emitReady();
  }

  /// Switches the branch, persists it as the new favorite, and re-filters.
  Future<void> selectBranch(Branch branch) async {
    _branch = branch;
    await _favoriteStore.write(branch);
    _emitReady();
  }

  void _emitReady() {
    final feed = _feed;
    if (feed == null) return;
    final dates = feed.wods.map((w) => _dayOnly(w.date)).toSet().toList()
      ..sort();
    final wods =
        feed.wods
            .where(
              (w) => w.branch == _branch && _dayOnly(w.date) == _selectedDate,
            )
            .toList()
          ..sort((a, b) => a.program.index.compareTo(b.program.index));
    emit(
      TodayState.ready(
        branch: _branch,
        selectedDate: _selectedDate,
        today: _today,
        wods: wods,
        availableDates: dates,
        stale: feed.stale,
        fetchedAt: feed.fetchedAt,
      ),
    );
  }
}
