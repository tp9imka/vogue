import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/favorite_branch_store.dart';
import '../../domain/models/branch.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';

/// First-run screen: pick the branch the app opens to every launch.
class LocationPickerScreen extends StatelessWidget {
  /// Creates a [LocationPickerScreen].
  const LocationPickerScreen({super.key});

  Future<void> _choose(BuildContext context, Branch branch) async {
    await context.read<FavoriteBranchStore>().write(branch);
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final cities = <String>{
      for (final branch in Branch.values) branch.city,
    }.toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(VogueSpace.lg),
          children: [
            const SizedBox(height: VogueSpace.xl),
            const Icon(
              Icons.bolt_rounded,
              size: 44,
              color: VogueColors.primary,
            ),
            const SizedBox(height: VogueSpace.md),
            Text(
              'Vogue WOD',
              style: VogueTypography.display.copyWith(color: VogueColors.ink),
            ),
            const SizedBox(height: VogueSpace.sm),
            Text(
              'Pick your home branch — the app opens here every time. '
              'You can change it whenever you like.',
              style: VogueTypography.body.copyWith(
                color: VogueColors.inkMuted,
              ),
            ),
            const SizedBox(height: VogueSpace.xl),
            for (final city in cities) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: VogueSpace.sm),
                child: Text(
                  city.toUpperCase(),
                  style: VogueTypography.label.copyWith(
                    color: VogueColors.inkFaint,
                  ),
                ),
              ),
              for (final branch in Branch.values.where(
                (b) => b.city == city,
              )) ...[
                _BranchTile(
                  branch: branch,
                  onTap: () => _choose(context, branch),
                ),
                const SizedBox(height: VogueSpace.sm),
              ],
              const SizedBox(height: VogueSpace.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _BranchTile extends StatelessWidget {
  const _BranchTile({required this.branch, required this.onTap});

  final Branch branch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(
          branch.displayName,
          style: VogueTypography.title.copyWith(color: VogueColors.ink),
        ),
        trailing: const Icon(
          Icons.arrow_forward_rounded,
          color: VogueColors.primary,
        ),
      ),
    );
  }
}
