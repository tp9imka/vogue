import 'package:flutter/material.dart';

import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';

/// A centered loading spinner.
class LoadingView extends StatelessWidget {
  /// Creates a [LoadingView].
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// A centered empty-state with an icon and a message.
class EmptyView extends StatelessWidget {
  /// Creates an [EmptyView] showing [message].
  const EmptyView({required this.message, this.icon, super.key});

  /// The message explaining why there is nothing to show.
  final String message;

  /// Optional leading icon; defaults to a "no events" glyph.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VogueSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.event_busy_rounded,
              size: 48,
              color: VogueColors.inkFaint,
            ),
            const SizedBox(height: VogueSpace.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: VogueTypography.body.copyWith(
                color: VogueColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A centered error-state with a retry button.
class ErrorView extends StatelessWidget {
  /// Creates an [ErrorView] showing [message] with an [onRetry] action.
  const ErrorView({required this.message, required this.onRetry, super.key});

  /// The error message to show.
  final String message;

  /// Called when the user taps retry.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VogueSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: VogueColors.error,
            ),
            const SizedBox(height: VogueSpace.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: VogueTypography.body.copyWith(
                color: VogueColors.inkMuted,
              ),
            ),
            const SizedBox(height: VogueSpace.lg),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
