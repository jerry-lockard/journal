import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../widgets/custom_calendar.dart';
import '../widgets/journal_entry_form.dart';
import '../widgets/journal_entry_card.dart';
import '../providers/journal_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Firebase Analytics instance
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    // Log screen view when this screen is loaded
    analytics.logScreenView(
      screenName: 'HomeScreen',
      screenClass: 'HomeScreen',
    );

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800;

    final selectedDate = ref.watch(selectedDateProvider);
    final entriesForDate = ref.watch(entriesForDateProvider(selectedDate));
    final entryCounts = ref.watch(entryCountsProvider);
    final journalNotifier = ref.watch(journalNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              // Example: Log an event when the home button is pressed
              analytics.logEvent(
                name: 'home_button_clicked',
                parameters: {
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
            },
            tooltip: 'Home',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Example: Log an event when the settings button is pressed
              analytics.logEvent(
                name: 'settings_button_clicked',
                parameters: {
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
            },
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (isMediumScreen)
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: entriesForDate.when(
                      data: (entries) {
                        // Log event for entries loaded
                        analytics.logEvent(
                          name: 'entries_loaded',
                          parameters: {
                            'date': selectedDate.toIso8601String(),
                            'entry_count': entries.length,
                          },
                        );

                        return Text(
                          '${entries.length} entries',
                          style: theme.textTheme.titleMedium,
                        );
                      },
                      loading: () => const Text('Loading...'),
                      error: (_, __) => const Text('Error loading entries'),
                    ),
                  ),
                  Expanded(
                    child: entryCounts.when(
                      data: (counts) => CustomCalendar(
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          // Log event for date selected
                          analytics.logEvent(
                            name: 'date_selected',
                            parameters: {
                              'selected_date': date.toIso8601String()
                            },
                          );

                          ref.read(selectedDateProvider.notifier).state = date;
                        },
                        entryCountByDate: counts,
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (_, __) => const Center(
                        child: Text('Error loading calendar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWideScreen ? screenWidth * 0.1 : 16,
                      vertical: 16,
                    ),
                    child: JournalEntryForm(
                      onSubmit: (content, imageUrl, tags) async {
                        // Log event when a journal entry is created
                        analytics.logEvent(
                          name: 'entry_created',
                          parameters: {
                            'content_length': content.length,
                            'image_provided': imageUrl != null,
                            'tag_count': tags.length,
                          },
                        );

                        await journalNotifier.createEntry(
                          content: content,
                          imageUrl: imageUrl,
                          tags: tags,
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWideScreen ? screenWidth * 0.1 : 0,
                  ),
                  sliver: entriesForDate.when(
                    data: (entries) => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final entry = entries[index];
                          return JournalEntryCard(
                            entry: entry,
                            onTap: () {
                              // Log event when an entry is viewed
                              analytics.logEvent(
                                name: 'entry_viewed',
                                parameters: {'entry_id': entry.id},
                              );
                            },
                            onEdit: () {
                              // Log event when an entry is edited
                              analytics.logEvent(
                                name: 'entry_edited',
                                parameters: {'entry_id': entry.id},
                              );
                            },
                            onDelete: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Entry'),
                                  content: const Text(
                                    'Are you sure you want to delete this entry?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                // Log event when an entry is deleted
                                analytics.logEvent(
                                  name: 'entry_deleted',
                                  parameters: {'entry_id': entry.id},
                                );

                                await journalNotifier.deleteEntry(entry.id);
                              }
                            },
                          );
                        },
                        childCount: entries.length,
                      ),
                    ),
                    loading: () => const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => const SliverFillRemaining(
                      child: Center(
                        child: Text('Error loading entries'),
                      ),
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
