import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final List<String> tags;
  final String? aiSummary;
  final String? mood;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.tags = const [],
    this.aiSummary,
    this.mood,
  });

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      imageUrl: data['imageUrl'],
      tags: List<String>.from(data['tags'] ?? []),
      aiSummary: data['aiSummary'],
      mood: data['mood'],
    );
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map, String id) {
    return JournalEntry(
      id: id,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'].toString()),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] is Timestamp 
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(map['updatedAt'].toString()))
          : null,
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      aiSummary: map['aiSummary'],
      mood: map['mood'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'imageUrl': imageUrl,
      'tags': tags,
      'aiSummary': aiSummary,
      'mood': mood,
    };
  }

  JournalEntry copyWith({
    String? userId,
    String? username,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    List<String>? tags,
    String? aiSummary,
    String? mood,
  }) {
    return JournalEntry(
      id: id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      aiSummary: aiSummary ?? this.aiSummary,
      mood: mood ?? this.mood,
    );
  }
}
