import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/favorite_branch_store.dart';
import 'data/wod_log_store.dart';
import 'domain/wod_repository.dart';
import 'presentation/log/wod_log_cubit.dart';
import 'presentation/theme/vogue_theme.dart';
import 'router.dart';

/// The application root.
class VogueApp extends StatefulWidget {
  /// Creates a [VogueApp] with its dependency graph already built.
  const VogueApp({
    required this.repository,
    required this.favoriteStore,
    required this.logStore,
    required this.hasFavorite,
    super.key,
  });

  /// The WOD data source.
  final WodRepository repository;

  /// Persistence for the favorite branch.
  final FavoriteBranchStore favoriteStore;

  /// Persistence for the training log.
  final WodLogStore logStore;

  /// Whether a favorite branch was already set (decides the start route).
  final bool hasFavorite;

  @override
  State<VogueApp> createState() => _VogueAppState();
}

class _VogueAppState extends State<VogueApp> {
  late final GoRouter _router = buildRouter(hasFavorite: widget.hasFavorite);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WodRepository>.value(value: widget.repository),
        RepositoryProvider<FavoriteBranchStore>.value(
          value: widget.favoriteStore,
        ),
        RepositoryProvider<WodLogStore>.value(value: widget.logStore),
      ],
      child: MaterialApp.router(
        title: 'WOD - Functional Fitness',
        debugShowCheckedModeBanner: false,
        theme: buildVogueLightTheme(),
        darkTheme: buildVogueDarkTheme(),
        themeMode: ThemeMode.dark,
        routerConfig: _router,
        // Wrap every navigated screen with a shared training-log cubit so
        // marking a WOD done from one screen updates every other.
        builder: (context, child) => BlocProvider<WodLogCubit>(
          create: (context) => WodLogCubit(context.read<WodLogStore>())..load(),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
