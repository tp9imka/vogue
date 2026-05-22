import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/core/result.dart';
import 'package:vogue_wod/data/favorite_branch_store.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';
import 'package:vogue_wod/domain/models/wod.dart';
import 'package:vogue_wod/domain/models/wod_section.dart';
import 'package:vogue_wod/domain/wod_repository.dart';
import 'package:vogue_wod/presentation/theme/vogue_theme.dart';
import 'package:vogue_wod/presentation/today/today_screen.dart';

import '../support/fakes.dart';

void main() {
  testWidgets('Today screen renders the favorite branch WOD for today', (
    tester,
  ) async {
    final now = DateTime.now();
    final feed = WodFeed(
      wods: [
        Wod(
          date: DateTime(now.year, now.month, now.day),
          branch: Branch.yasMarina,
          program: Program.metcon,
          sections: const [
            WodSection(title: 'Metcon', lines: ['100 cal row']),
          ],
        ),
      ],
      fetchedAt: now,
      stale: false,
    );

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<WodRepository>.value(
            value: FakeWodRepository(refreshResult: Ok(feed)),
          ),
          RepositoryProvider<FavoriteBranchStore>.value(
            value: FakeFavoriteBranchStore(),
          ),
        ],
        child: MaterialApp(
          theme: buildVogueDarkTheme(),
          home: const TodayScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('100 cal row'), findsOneWidget);
  });
}
