import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Map<DateTime, int> entryCountByDate;

  const CustomCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.entryCountByDate = const {},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(now.year, now.month - 1);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthSection(theme, currentMonth),
          const SizedBox(height: 16),
          _buildMonthSection(theme, previousMonth),
        ],
      ),
    );
  }

  Widget _buildMonthSection(ThemeData theme, DateTime month) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            DateFormat('MMM yyyy').format(month),
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _getDaysInMonth(month),
          itemBuilder: (context, index) {
            final date = DateTime(month.year, month.month, index + 1);
            final isSelected = _isSameDay(date, selectedDate);
            final isToday = _isSameDay(date, DateTime.now());
            final entryCount = entryCountByDate[date] ?? 0;

            return _DateTile(
              date: date,
              isSelected: isSelected,
              isToday: isToday,
              entryCount: entryCount,
              onTap: () => onDateSelected(date),
            );
          },
        ),
      ],
    );
  }

  int _getDaysInMonth(DateTime month) {
    final nextMonth = DateTime(month.year, month.month + 1, 0);
    return nextMonth.day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DateTile extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final int entryCount;
  final VoidCallback onTap;

  const _DateTile({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.entryCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isToday
        ? theme.colorScheme.primary
        : isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                date.day.toString(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: isToday || isSelected ? FontWeight.bold : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('E').format(date)[0],
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            ),
            if (entryCount > 0) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.onPrimary.withOpacity(0.2)
                      : theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entryCount.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
