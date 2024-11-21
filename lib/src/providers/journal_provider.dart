import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/ai_service.dart';
import 'ai_provider.dart';

final journalServiceProvider = Provider((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return JournalService(aiService);
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final entriesForDateProvider = StreamProvider.family<List<JournalEntry>, DateTime>(
  (ref, date) {
    final journalService = ref.watch(journalServiceProvider);
    return journalService.getEntriesForDate(date);
  },
);

final entryCountsProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  final journalService = ref.watch(journalServiceProvider);
  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month - 1, 1);
  final endDate = DateTime(now.year, now.month + 1, 0);
  return journalService.getEntryCountsByDateRange(startDate, endDate);
});

class JournalNotifier extends StateNotifier<AsyncValue<void>> {
  final JournalService _journalService;

  JournalNotifier(this._journalService) : super(const AsyncValue.data(null));

  Future<void> createEntry({
    required String content,
    String? imageUrl,
    List<String> tags = const [],
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _journalService.createEntry(
        content: content,
        imageUrl: imageUrl,
        tags: tags,
      );
    });
  }

  Future<void> updateEntry(JournalEntry entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _journalService.updateEntry(entry);
    });
  }

  Future<void> deleteEntry(String entryId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _journalService.deleteEntry(entryId);
    });
  }

  Future<String?> uploadImage(String filePath) async {
    state = const AsyncValue.loading();
    try {
      final url = await _journalService.uploadImage(filePath);
      state = const AsyncValue.data(null);
      return url;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }
}

final journalNotifierProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<void>>((ref) {
  final journalService = ref.watch(journalServiceProvider);
  return JournalNotifier(journalService);
});
