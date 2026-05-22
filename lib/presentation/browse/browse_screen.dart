import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/branch.dart';
import '../../domain/models/wod.dart';
import '../../domain/wod_repository.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';
import '../widgets/app_states.dart';
import '../widgets/date_strip.dart';
import '../widgets/wod_card.dart';
import 'browse_cubit.dart';

/// Browse every branch's WOD for a chosen day.
class BrowseScreen extends StatelessWidget {
  /// Creates a [BrowseScreen].
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BrowseCubit(repository: context.read<WodRepository>())..load(),
      child: const BrowseView(),
    );
  }
}

/// The Browse screen body — consumes [BrowseCubit].
class BrowseView extends StatelessWidget {
  /// Creates a [BrowseView].
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Branches')),
      body: BlocBuilder<BrowseCubit, BrowseState>(
        builder: (context, state) {
          return switch (state) {
            BrowseLoading() => const LoadingView(),
            BrowseError(:final message) => ErrorView(
              message: message,
              onRetry: () => context.read<BrowseCubit>().refresh(),
            ),
            BrowseReady() => _ReadyView(state: state),
          };
        },
      ),
    );
  }
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({required this.state});

  final BrowseReady state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BrowseCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: VogueSpace.sm),
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
            child: _branchList(context, state.wods),
          ),
        ),
      ],
    );
  }

  Widget _branchList(BuildContext context, List<Wod> wods) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      // Pad past the Android system nav bar so the last branch group
      // stays fully visible when scrolled to the end.
      padding: EdgeInsets.fromLTRB(
        VogueSpace.lg,
        VogueSpace.sm,
        VogueSpace.lg,
        VogueSpace.xxl + MediaQuery.viewPaddingOf(context).bottom,
      ),
      children: [
        for (final branch in Branch.values)
          _BranchGroup(
            branch: branch,
            wods: wods.where((w) => w.branch == branch).toList(),
          ),
      ],
    );
  }
}

class _BranchGroup extends StatelessWidget {
  const _BranchGroup({required this.branch, required this.wods});

  final Branch branch;
  final List<Wod> wods;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: VogueSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: VogueSpace.sm),
            child: Text(
              branch.displayName.toUpperCase(),
              style: VogueTypography.label.copyWith(
                color: VogueColors.inkMuted,
              ),
            ),
          ),
          if (wods.isEmpty)
            Text(
              'No WOD posted.',
              style: VogueTypography.body.copyWith(
                color: VogueColors.inkFaint,
              ),
            )
          else
            for (var i = 0; i < wods.length; i++) ...[
              if (i > 0) const SizedBox(height: VogueSpace.sm),
              WodCard(
                wod: wods[i],
                expanded: false,
                onTap: () => context.push('/wod', extra: wods[i]),
              ),
            ],
        ],
      ),
    );
  }
}
