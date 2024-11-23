import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';
import '../../../shared/firebase/services/database_service.dart';
import '../../../shared/firebase/services/storage_service.dart';
import '../../ai/providers/ai_provider.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

final databaseServiceProvider = Provider((ref) {
  return DatabaseService();
});

final storageServiceProvider = Provider((ref) {
  return StorageService();
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final entriesForDateProvider =
    StreamProvider.family<List<JournalEntry>, DateTime>((ref, date) {
  final databaseService = ref.watch(databaseServiceProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return databaseService.getEntriesForDate(date);
});

final entryCountsProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};

  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month - 1, 1);
  final endDate = DateTime(now.year, now.month + 1, 0);
  return databaseService.getEntryCountsByDateRange(startDate, endDate);
});

class JournalNotifier extends StateNotifier<AsyncValue<void>> {
  JournalNotifier(this._databaseService, this._storageService, this._aiService)
      : super(const AsyncValue.data(null));

  final DatabaseService _databaseService;
  final StorageService _storageService;
  final AIService _aiService;

  Future<String?> uploadImage(File imageFile) async {
    return _storageService.uploadJournalImage(imageFile);
  }

  Future<void> createEntry({
    required String content,
    String? imageUrl,
    List<String> tags = const [],
  }) async {
    state = const AsyncValue.loading();

    try {
      // Generate AI content
      final aiSummary = await _aiService.generateSummary(content);
      final mood = await _aiService.analyzeMood(content);
      final suggestedTags = await _aiService.suggestTags(content);

      // Merge user-provided and AI-suggested tags
      final allTags = {...tags, ...suggestedTags}.toList();

      await _databaseService.createEntry(
        content: content,
        imageUrl: imageUrl,
        tags: allTags,
        aiSummary: aiSummary,
        mood: mood,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateEntry(JournalEntry entry) async {
    state = const AsyncValue.loading();

    try {
      await _databaseService.updateEntry(entry);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteEntry(String entryId) async {
    state = const AsyncValue.loading();

    try {
      await _databaseService.deleteEntry(entryId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final journalNotifierProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<void>>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  final aiService = ref.watch(aiServiceProvider);
  return JournalNotifier(databaseService, storageService, aiService);
});
