import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const JournalEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  entry.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('MMM d, yyyy').format(entry.createdAt),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: onEdit,
                          tooltip: 'Edit',
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: onDelete,
                          tooltip: 'Delete',
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.content,
                    style: theme.textTheme.bodyLarge,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (entry.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: entry.tags.map((tag) {
                        return Chip(
                          label: Text(
                            tag,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                  if (entry.aiSummary != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.aiSummary!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
