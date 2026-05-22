import 'package:go_router/go_router.dart';

import 'domain/models/wod.dart';
import 'presentation/detail/wod_detail_screen.dart';
import 'presentation/home_shell.dart';
import 'presentation/onboarding/location_picker_screen.dart';

/// Builds the app router.
///
/// When no favorite branch is set the app starts at the location picker;
/// otherwise it starts on the Today screen.
GoRouter buildRouter({required bool hasFavorite}) {
  return GoRouter(
    initialLocation: hasFavorite ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const LocationPickerScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeShell(),
      ),
      GoRoute(
        path: '/wod',
        builder: (context, state) => WodDetailScreen(wod: state.extra! as Wod),
      ),
    ],
  );
}
