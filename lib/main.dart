import 'package:flutter/widgets.dart';

import 'app.dart';
import 'data/favorite_branch_store.dart';
import 'data/wod_local_cache.dart';
import 'data/wod_remote_source.dart';
import 'data/wod_repository_impl.dart';

/// App entrypoint — builds the dependency graph and starts [VogueApp].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favoriteStore = FavoriteBranchStore();
  final hasFavorite = await favoriteStore.read() != null;

  runApp(
    VogueApp(
      repository: WodRepositoryImpl(
        remote: WodRemoteSource(),
        cache: WodLocalCache.file(),
      ),
      favoriteStore: favoriteStore,
      hasFavorite: hasFavorite,
    ),
  );
}
