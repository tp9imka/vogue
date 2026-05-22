import 'package:vogue_wod/core/result.dart';
import 'package:vogue_wod/data/favorite_branch_store.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/wod_repository.dart';

/// A [WodRepository] whose responses are set up by the test.
class FakeWodRepository implements WodRepository {
  FakeWodRepository({required this.refreshResult, this.cachedFeed});

  Result<WodFeed> refreshResult;
  WodFeed? cachedFeed;

  @override
  Future<WodFeed?> cached() async => cachedFeed;

  @override
  Future<Result<WodFeed>> refresh() async => refreshResult;
}

/// An in-memory [FavoriteBranchStore].
class FakeFavoriteBranchStore implements FavoriteBranchStore {
  FakeFavoriteBranchStore([this.saved]);

  Branch? saved;

  @override
  Future<Branch?> read() async => saved;

  @override
  Future<void> write(Branch branch) async => saved = branch;
}
