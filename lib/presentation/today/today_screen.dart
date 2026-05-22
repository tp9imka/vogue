import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/favorite_branch_store.dart';
import '../../domain/models/wod.dart';
import '../../domain/wod_repository.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';
import '../widgets/app_states.dart';
import '../widgets/branch_switcher_sheet.dart';
import '../widgets/date_strip.dart';
import '../widgets/wod_card.dart';
import 'today_cubit.dart';

/// The launch screen: today's WOD for the user's favorite branch.
class TodayScreen extends StatelessWidget {
  /// Creates a [TodayScreen].
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodayCubit(
        repository: context.read<WodRepository>(),
        favoriteStore: context.read<FavoriteBranchStore>(),
      )..load(),
      child: const TodayView(),
    );
  }
}

/// The Today screen body — consumes [TodayCubit].
class TodayView extends StatelessWidget {
  /// Creates a [TodayView].
  const TodayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TodayCubit, TodayState>(
        builder: (context, state) {
          return switch (state) {
            TodayLoading() => const _Chrome(child: LoadingView()),
            TodayError(:final message) => _Chrome(
              child: ErrorView(
                message: message,
                onRetry: () => context.read<TodayCubit>().refresh(),
              ),
            ),
            TodayReady() => _ReadyView(state: state),
          };
        },
      ),
    );
  }
}

/// A bare scaffold body used for the loading / error states.
class _Chrome extends StatelessWidget {
  const _Chrome({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 56),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({required this.state});

  final TodayReady state;

  Future<void> _pickBranch(BuildContext context) async {
    final cubit = context.read<TodayCubit>();
    final picked = await showBranchSwitcher(context, state.branch);
    if (picked != null) await cubit.selectBranch(picked);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodayCubit>();
    final isToday = state.selectedDate == state.today;
    final eyebrow = isToday
        ? 'TODAY'
        : DateFormat('EEEE').format(state.selectedDate).toUpperCase();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BranchBar(
            branchName: state.branch.displayName,
            onTap: () => _pickBranch(context),
            onJumpToToday: isToday ? null : () => cubit.selectDate(state.today),
          ),
          if (state.stale) _StaleBar(fetchedAt: state.fetchedAt),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VogueSpace.lg,
              VogueSpace.sm,
              VogueSpace.lg,
              VogueSpace.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: VogueTypography.label.copyWith(
                    color: VogueColors.primary,
                  ),
                ),
                const SizedBox(height: VogueSpace.xs),
                Text(
                  DateFormat('d MMMM').format(state.selectedDate),
                  style: VogueTypography.display.copyWith(
                    color: VogueColors.ink,
                  ),
                ),
              ],
            ),
          ),
          DateStrip(
            dates: state.availableDates,
            selected: state.selectedDate,
            today: state.today,
            onSelected: cubit.selectDate,
          ),
          const SizedBox(height: VogueSpace.sm),
          Expanded(
            child: RefreshIndicator(
              onRefresh: cubit.refresh,
              color: VogueColors.primary,
              child: _wodList(context, state.wods),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wodList(BuildContext context, List<Wod> wods) {
    if (wods.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 360,
            child: EmptyView(
              message:
                  'No WOD posted for this branch on this day.\n'
                  'Pick another day from the strip above.',
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        VogueSpace.lg,
        0,
        VogueSpace.lg,
        VogueSpace.xxl,
      ),
      itemCount: wods.length,
      separatorBuilder: (_, _) => const SizedBox(height: VogueSpace.md),
      itemBuilder: (context, index) {
        final wod = wods[index];
        return WodCard(
          wod: wod,
          onTap: () => context.push('/wod', extra: wod),
        );
      },
    );
  }
}

class _BranchBar extends StatelessWidget {
  const _BranchBar({
    required this.branchName,
    required this.onTap,
    required this.onJumpToToday,
  });

  final String branchName;
  final VoidCallback onTap;
  final VoidCallback? onJumpToToday;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VogueSpace.lg,
        VogueSpace.sm,
        VogueSpace.sm,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(VogueRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: VogueSpace.sm,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      size: 18,
                      color: VogueColors.primary,
                    ),
                    const SizedBox(width: VogueSpace.xs),
                    Flexible(
                      child: Text(
                        branchName,
                        style: VogueTypography.title.copyWith(
                          color: VogueColors.ink,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.expand_more_rounded,
                      size: 20,
                      color: VogueColors.inkMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (onJumpToToday != null)
            TextButton(
              onPressed: onJumpToToday,
              child: const Text('TODAY'),
            ),
        ],
      ),
    );
  }
}

class _StaleBar extends StatelessWidget {
  const _StaleBar({required this.fetchedAt});

  final DateTime? fetchedAt;

  @override
  Widget build(BuildContext context) {
    final at = fetchedAt;
    final suffix = at == null
        ? ''
        : ' · updated ${DateFormat('d MMM, HH:mm').format(at)}';
    return Container(
      width: double.infinity,
      color: VogueColors.warning.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(
        horizontal: VogueSpace.lg,
        vertical: VogueSpace.sm,
      ),
      child: Text(
        'Offline — showing saved schedule$suffix',
        style: VogueTypography.label.copyWith(color: VogueColors.warning),
      ),
    );
  }
}
