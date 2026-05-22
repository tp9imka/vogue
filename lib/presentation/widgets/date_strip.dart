import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/vogue_tokens.dart';
import '../theme/vogue_typography.dart';

const double _chipWidth = 58;
const double _chipGap = VogueSpace.sm;

/// A horizontal day picker — one tappable chip per available date.
///
/// The chip for [selected] is highlighted and scrolled into view; the chip
/// for [today] carries a small marker.
class DateStrip extends StatefulWidget {
  /// Creates a [DateStrip].
  const DateStrip({
    required this.dates,
    required this.selected,
    required this.today,
    required this.onSelected,
    super.key,
  });

  /// All selectable dates, ascending.
  final List<DateTime> dates;

  /// The currently selected date.
  final DateTime selected;

  /// The real "today", marked specially in the strip.
  final DateTime today;

  /// Called with the date the user taps.
  final ValueChanged<DateTime> onSelected;

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(DateStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) _scrollToSelected();
  }

  void _scrollToSelected() {
    if (!_controller.hasClients) return;
    final index = widget.dates.indexOf(widget.selected);
    if (index < 0) return;
    final viewport = _controller.position.viewportDimension;
    final target =
        index * (_chipWidth + _chipGap) - (viewport - _chipWidth) / 2;
    _controller.animateTo(
      target.clamp(0.0, _controller.position.maxScrollExtent),
      duration: VogueDuration.medium,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: VogueSpace.lg),
        itemCount: widget.dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: _chipGap),
        itemBuilder: (context, index) {
          final date = widget.dates[index];
          return _DateChip(
            date: date,
            isSelected: date == widget.selected,
            isToday: date == widget.today,
            onTap: () => widget.onSelected(date),
          );
        },
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? VogueColors.onPrimary : VogueColors.ink;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _chipWidth,
        decoration: BoxDecoration(
          color: isSelected ? VogueColors.primary : VogueColors.surfaceRaised,
          borderRadius: BorderRadius.circular(VogueRadius.md),
          border: Border.all(
            color: isSelected ? VogueColors.primary : VogueColors.outline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: VogueTypography.label.copyWith(
                color: isSelected
                    ? VogueColors.onPrimary
                    : VogueColors.inkMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('d').format(date),
              style: VogueTypography.title.copyWith(color: fg),
            ),
            const SizedBox(height: 3),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday ? fg : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
