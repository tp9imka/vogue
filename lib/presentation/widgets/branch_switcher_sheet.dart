import 'package:flutter/material.dart';

import '../../domain/models/branch.dart';
import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';

/// Shows the branch switcher as a modal bottom sheet.
///
/// Resolves to the [Branch] the user picked, or `null` if dismissed.
Future<Branch?> showBranchSwitcher(BuildContext context, Branch current) {
  return showModalBottomSheet<Branch>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _BranchSwitcherSheet(current: current),
  );
}

class _BranchSwitcherSheet extends StatelessWidget {
  const _BranchSwitcherSheet({required this.current});

  final Branch current;

  @override
  Widget build(BuildContext context) {
    final cities = <String>{
      for (final branch in Branch.values) branch.city,
    }.toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: VogueSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                VogueSpace.lg,
                VogueSpace.sm,
                VogueSpace.lg,
                VogueSpace.md,
              ),
              child: Text(
                'Choose your branch',
                style: VogueTypography.headline.copyWith(
                  color: VogueColors.ink,
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final city in cities) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          VogueSpace.lg,
                          VogueSpace.md,
                          VogueSpace.lg,
                          VogueSpace.xs,
                        ),
                        child: Text(
                          city.toUpperCase(),
                          style: VogueTypography.label.copyWith(
                            color: VogueColors.inkFaint,
                          ),
                        ),
                      ),
                      for (final branch in Branch.values.where(
                        (b) => b.city == city,
                      ))
                        _BranchRow(
                          branch: branch,
                          selected: branch == current,
                          onTap: () => Navigator.of(context).pop(branch),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchRow extends StatelessWidget {
  const _BranchRow({
    required this.branch,
    required this.selected,
    required this.onTap,
  });

  final Branch branch;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        branch.displayName,
        style: VogueTypography.title.copyWith(
          color: selected ? VogueColors.primary : VogueColors.ink,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: VogueColors.primary)
          : null,
    );
  }
}
