import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String subjectId;
  final String semesterId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final bool isPublic;
  final int likes;
  final List<String> likedBy;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.subjectId,
    required this.semesterId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.isPublic = false,
    this.likes = 0,
    this.likedBy = const [],
  });

  // Create Note from Firestore document
  factory Note.fromMap(Map<String, dynamic> data, String documentId) {
    return Note(
      id: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      subjectId: data['subjectId'] ?? '',
      semesterId: data['semesterId'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      tags: List<String>.from(data['tags'] ?? []),
      isPublic: data['isPublic'] ?? false,
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  // Convert Note to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'subjectId': subjectId,
      'semesterId': semesterId,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
      'isPublic': isPublic,
      'likes': likes,
      'likedBy': likedBy,
    };
  }

  // Create a copy with updated fields
  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? subjectId,
    String? semesterId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isPublic,
    int? likes,
    List<String>? likedBy,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      subjectId: subjectId ?? this.subjectId,
      semesterId: semesterId ?? this.semesterId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}
