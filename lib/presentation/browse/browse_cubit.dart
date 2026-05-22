import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/models/wod.dart';
import '../../domain/wod_repository.dart';

part 'browse_cubit.freezed.dart';

/// State for the Browse (all branches) screen.
@freezed
sealed class BrowseState with _$BrowseState {
  /// Nothing to show yet.
  const factory BrowseState.loading() = BrowseLoading;

  /// Loaded: every branch's WOD for [selectedDate].
  const factory BrowseState.ready({
    required DateTime selectedDate,
    required DateTime today,
    required List<DateTime> availableDates,
    required List<Wod> wods,
    required bool stale,
  }) = BrowseReady;

  /// Load failed with no cached data to fall back to.
  const factory BrowseState.error(String message) = BrowseError;
}

DateTime _dayOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Owns the Browse screen's state: the selected day and every branch's
/// WODs for that day.
class BrowseCubit extends Cubit<BrowseState> {
  /// Creates a [BrowseCubit]. [now] is injectable for tests.
  BrowseCubit({required WodRepository repository, DateTime? now})
    : _repository = repository,
      _today = _dayOnly(now ?? DateTime.now()),
      super(const BrowseState.loading()) {
    _selectedDate = _today;
  }

  final WodRepository _repository;
  final DateTime _today;

  WodFeed? _feed;
  late DateTime _selectedDate;

  /// Paints cached data instantly, then refreshes from the network.
  Future<void> load() async {
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
        if (_feed == null) emit(BrowseState.error(failure.message));
    }
  }

  /// Selects a different day without re-fetching.
  void selectDate(DateTime date) {
    _selectedDate = _dayOnly(date);
    _emitReady();
  }

  void _emitReady() {
    final feed = _feed;
    if (feed == null) return;
    final dates = feed.wods.map((w) => _dayOnly(w.date)).toSet().toList()
      ..sort();
    final wods =
        feed.wods.where((w) => _dayOnly(w.date) == _selectedDate).toList()
          ..sort((a, b) => a.branch.index.compareTo(b.branch.index));
    emit(
      BrowseState.ready(
        selectedDate: _selectedDate,
        today: _today,
        availableDates: dates,
        wods: wods,
        stale: feed.stale,
      ),
    );
  }
}
