import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/core/result.dart';
import 'package:vogue_wod/data/wod_local_cache.dart';
import 'package:vogue_wod/data/wod_remote_source.dart';
import 'package:vogue_wod/data/wod_repository_impl.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/presentation/today/today_cubit.dart';

import '../support/fakes.dart';

/// A [WodRemoteSource] that serves a fixed HTML payload — the real network
/// is the only thing stubbed; everything else is production code.
class _FixtureRemote implements WodRemoteSource {
  _FixtureRemote(this._html);

  final String _html;

  @override
  Future<Result<String>> fetchHtml() async => Ok(_html);
}

void main() {
  test(
    'end to end: live-shaped HTML flows through parser, repository and cubit',
    () async {
      final html = File(
        'test/fixtures/vfuae_wod_sample.html',
      ).readAsStringSync();

      final repository = WodRepositoryImpl(
        remote: _FixtureRemote(html),
        cache: WodLocalCache.inMemory(),
      );
      final cubit = TodayCubit(
        repository: repository,
        favoriteStore: FakeFavoriteBranchStore(Branch.jlt),
        now: DateTime(2026, 5, 22),
      );

      await cubit.load();

      // The whole schedule made it through the repository into the cache.
      final cached = await repository.cached();
      expect(cached, isNotNull);
      expect(cached!.wods.length, greaterThan(300));

      // The cubit produced a usable Today state for the favorite branch.
      expect(cubit.state, isA<TodayReady>());
      final ready = cubit.state as TodayReady;
      expect(ready.branch, Branch.jlt);
      expect(ready.availableDates.length, greaterThanOrEqualTo(20));

      // Selecting a day that has JLT programming yields only JLT WODs.
      cubit.selectDate(DateTime(2026, 5, 5));
      final selected = cubit.state as TodayReady;
      expect(selected.wods, isNotEmpty);
      expect(selected.wods.every((w) => w.branch == Branch.jlt), isTrue);

      await cubit.close();
    },
  );
}
