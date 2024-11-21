import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../services/ai_service.dart';

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AIService _aiService;
  final _uuid = const Uuid();

  JournalService(this._aiService);

  // Create a new journal entry
  Future<JournalEntry> createEntry({
    required String content,
    String? imageUrl,
    List<String> tags = const [],
  }) async {
    final now = DateTime.now();
    final entryId = _uuid.v4();

    // Generate AI content
    final aiSummary = await _aiService.generateSummary(content);
    final mood = await _aiService.analyzeMood(content);
    final suggestedTags = await _aiService.suggestTags(content);
    
    // Merge user-provided and AI-suggested tags
    final allTags = {...tags, ...suggestedTags}.toList();

    final entry = JournalEntry(
      id: entryId,
      content: content,
      createdAt: now,
      imageUrl: imageUrl,
      tags: allTags,
      aiSummary: aiSummary,
      mood: mood,
    );

    await _firestore.collection('entries').doc(entryId).set(entry.toMap());
    return entry;
  }

  // Get all entries for a specific date
  Stream<List<JournalEntry>> getEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('entries')
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .where('createdAt', isLessThan: endOfDay)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => JournalEntry.fromFirestore(doc)).toList();
    });
  }

  // Get entry counts by date for a date range
  Future<Map<DateTime, int>> getEntryCountsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _firestore
        .collection('entries')
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .get();

    final countByDate = <DateTime, int>{};
    for (final doc in snapshot.docs) {
      final entry = JournalEntry.fromFirestore(doc);
      final date = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );
      countByDate[date] = (countByDate[date] ?? 0) + 1;
    }

    return countByDate;
  }

  // Update an existing entry
  Future<void> updateEntry(JournalEntry entry) async {
    await _firestore.collection('entries').doc(entry.id).update(entry.toMap());
  }

  // Delete an entry
  Future<void> deleteEntry(String entryId) async {
    await _firestore.collection('entries').doc(entryId).delete();
  }

  // Upload an image and get its URL
  Future<String> uploadImage(String filePath) async {
    final fileName = '${_uuid.v4()}.jpg';
    final ref = _storage.ref().child('images/$fileName');
    await ref.putFile(File(filePath));
    return await ref.getDownloadURL();
  }

  // Get AI summary for entry content
  Future<String> getAISummary(String content) async {
    // TODO: Implement Gemini AI integration
    return 'AI summary will be implemented with Gemini';
  }
}
