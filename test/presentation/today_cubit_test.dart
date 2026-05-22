import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/core/failure.dart';
import 'package:vogue_wod/core/result.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';
import 'package:vogue_wod/domain/models/wod.dart';
import 'package:vogue_wod/domain/models/wod_section.dart';
import 'package:vogue_wod/domain/wod_repository.dart';
import 'package:vogue_wod/presentation/today/today_cubit.dart';

import '../support/fakes.dart';

Wod _wod(Branch branch, Program program, DateTime date) => Wod(
  date: date,
  branch: branch,
  program: program,
  sections: const [
    WodSection(lines: ['row']),
  ],
);

WodFeed _feed(List<Wod> wods, {bool stale = false}) =>
    WodFeed(wods: wods, fetchedAt: DateTime(2026, 5, 22), stale: stale);

void main() {
  final today = DateTime(2026, 5, 22);
  final tomorrow = DateTime(2026, 5, 23);

  group('TodayCubit', () {
    blocTest<TodayCubit, TodayState>(
      'load emits ready with the favorite branch WODs for today',
      build: () => TodayCubit(
        repository: FakeWodRepository(
          refreshResult: Ok(
            _feed([
              _wod(Branch.jlt, Program.metcon, today),
              _wod(Branch.yasMarina, Program.wod, today),
            ]),
          ),
        ),
        favoriteStore: FakeFavoriteBranchStore(Branch.jlt),
        now: today,
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<TodayReady>()
            .having((s) => s.branch, 'branch', Branch.jlt)
            .having((s) => s.wods.length, 'wods', 1)
            .having((s) => s.wods.first.program, 'program', Program.metcon),
      ],
    );

    blocTest<TodayCubit, TodayState>(
      'load paints cached data, then the refreshed data',
      build: () {
        final feed = _feed([_wod(Branch.jlt, Program.metcon, today)]);
        return TodayCubit(
          repository: FakeWodRepository(
            refreshResult: Ok(feed),
            cachedFeed: _feed(feed.wods, stale: true),
          ),
          favoriteStore: FakeFavoriteBranchStore(Branch.jlt),
          now: today,
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [isA<TodayReady>(), isA<TodayReady>()],
    );

    blocTest<TodayCubit, TodayState>(
      'selectDate re-filters to the chosen day',
      build: () => TodayCubit(
        repository: FakeWodRepository(
          refreshResult: Ok(
            _feed([
              _wod(Branch.jlt, Program.metcon, today),
              _wod(Branch.jlt, Program.stamina, tomorrow),
            ]),
          ),
        ),
        favoriteStore: FakeFavoriteBranchStore(Branch.jlt),
        now: today,
      ),
      act: (cubit) async {
        await cubit.load();
        cubit.selectDate(tomorrow);
      },
      skip: 1,
      expect: () => [
        isA<TodayReady>()
            .having((s) => s.selectedDate, 'selectedDate', tomorrow)
            .having((s) => s.wods.first.program, 'program', Program.stamina),
      ],
    );

    blocTest<TodayCubit, TodayState>(
      'load emits error when the network fails with no cache',
      build: () => TodayCubit(
        repository: FakeWodRepository(
          refreshResult: const Err<WodFeed>(NetworkFailure()),
        ),
        favoriteStore: FakeFavoriteBranchStore(Branch.jlt),
        now: today,
      ),
      act: (cubit) => cubit.load(),
      expect: () => [isA<TodayError>()],
    );

    test('selectBranch persists the new favorite', () async {
      final store = FakeFavoriteBranchStore(Branch.jlt);
      final cubit = TodayCubit(
        repository: FakeWodRepository(
          refreshResult: Ok(
            _feed([_wod(Branch.saadiyat, Program.wod, today)]),
          ),
        ),
        favoriteStore: store,
        now: today,
      );

      await cubit.load();
      await cubit.selectBranch(Branch.saadiyat);

      expect(store.saved, Branch.saadiyat);
      expect((cubit.state as TodayReady).branch, Branch.saadiyat);
      await cubit.close();
    });
  });
}
