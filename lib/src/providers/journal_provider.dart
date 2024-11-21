import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/ai_service.dart';
import 'ai_provider.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

final journalServiceProvider = Provider((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return JournalService(aiService);
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final entriesForDateProvider = StreamProvider.family<List<JournalEntry>, DateTime>(
  (ref, date) {
    final journalService = ref.watch(journalServiceProvider);
    final user = ref.watch(currentUserProvider);
    if (user == null) return Stream.value([]);
    return journalService.getEntriesForDate(date);
  },
);

final entryCountsProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  final journalService = ref.watch(journalServiceProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};
  
  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month - 1, 1);
  final endDate = DateTime(now.year, now.month + 1, 0);
  return journalService.getEntryCountsByDateRange(startDate, endDate);
});

class JournalNotifier extends StateNotifier<AsyncValue<void>> {
  final JournalService _journalService;
  final Ref _ref;

  JournalNotifier(this._journalService, this._ref) : super(const AsyncValue.data(null));

  Future<void> createEntry({
    required String content,
    String? imageUrl,
    List<String> tags = const [],
  }) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        Exception('Must be logged in to create entries'),
        StackTrace.current,
      );
      return;
    }

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
    final user = _ref.read(currentUserProvider);
    if (user == null || user.uid != entry.userId) {
      state = AsyncValue.error(
        Exception('Unauthorized to update this entry'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _journalService.updateEntry(entry);
    });
  }

  Future<void> deleteEntry(String entryId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        Exception('Must be logged in to delete entries'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _journalService.deleteEntry(entryId);
    });
  }

  Future<String?> uploadImage(String filePath) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        Exception('Must be logged in to upload images'),
        StackTrace.current,
      );
      return null;
    }

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
  return JournalNotifier(journalService, ref);
});
