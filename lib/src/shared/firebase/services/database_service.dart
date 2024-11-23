import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features/journal/models/journal_entry.dart';
import '../firebase_config.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  DatabaseReference _getUserRef() {
    if (_userId.isEmpty) throw Exception('User must be logged in');
    return _database.ref('${FirebaseConfig.usersPath}/$_userId');
  }

  DatabaseReference _getEntriesRef() {
    return _getUserRef().child(FirebaseConfig.entriesPath);
  }

  Stream<List<JournalEntry>> getEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _getEntriesRef()
        .orderByChild('createdAt')
        .startAt(startOfDay.millisecondsSinceEpoch)
        .endAt(endOfDay.millisecondsSinceEpoch)
        .onValue
        .map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) return [];

      final entriesMap = snapshot.value as Map<dynamic, dynamic>;
      return entriesMap.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        return JournalEntry.fromMap(data, entry.key);
      }).toList();
    });
  }

  Future<Map<DateTime, int>> getEntryCountsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _getEntriesRef()
        .orderByChild('createdAt')
        .startAt(startDate.millisecondsSinceEpoch)
        .endAt(endDate.millisecondsSinceEpoch)
        .get();

    if (!snapshot.exists || snapshot.value == null) return {};

    final entriesMap = snapshot.value as Map<dynamic, dynamic>;
    final countByDate = <DateTime, int>{};

    for (final entry in entriesMap.values) {
      final data = entry as Map<dynamic, dynamic>;
      final timestamp = data['createdAt'] as int;
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final key = DateTime(date.year, date.month, date.day);
      countByDate[key] = (countByDate[key] ?? 0) + 1;
    }

    return countByDate;
  }

  Future<String> createEntry({
    required String content,
    String? imageUrl,
    List<String> tags = const [],
    String? aiSummary,
    String? mood,
  }) async {
    final ref = _getEntriesRef().push();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await ref.set({
      'userId': _userId,
      'username': _auth.currentUser?.displayName ?? '',
      'content': content,
      'createdAt': timestamp,
      'imageUrl': imageUrl,
      'tags': tags,
      'aiSummary': aiSummary,
      'mood': mood,
    });

    return ref.key!;
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await _getEntriesRef().child(entry.id).update(entry.toMap());
  }

  Future<void> deleteEntry(String entryId) async {
    await _getEntriesRef().child(entryId).remove();
  }

  // User settings methods
  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    await _getUserRef().child(FirebaseConfig.settingsPath).update(settings);
  }

  Stream<Map<String, dynamic>> getUserSettings() {
    return _getUserRef()
        .child(FirebaseConfig.settingsPath)
        .onValue
        .map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) return {};
      return Map<String, dynamic>.from(snapshot.value as Map);
    });
  }
}
