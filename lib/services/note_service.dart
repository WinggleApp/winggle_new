import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'notes';

  // Create a new note
  Future<String> createNote(Note note) async {
    try {
      DocumentReference docRef = await _firestore.collection(collection).add(note.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  // Get a note by ID
  Future<Note?> getNoteById(String noteId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(collection).doc(noteId).get();
      
      if (docSnapshot.exists) {
        return Note.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get note: $e');
    }
  }

  // Get all notes for a specific user
  Future<List<Note>> getUserNotes(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user notes: $e');
    }
  }

  // Get all notes for a specific subject
  Future<List<Note>> getSubjectNotes(String subjectId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get subject notes: $e');
    }
  }

  // Get all notes for a specific semester
  Future<List<Note>> getSemesterNotes(String semesterId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('semesterId', isEqualTo: semesterId)
          .get();

      // Sort locally to avoid index requirement
      List<Note> notes = querySnapshot.docs
          .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Sort by updatedAt locally (newest first)
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      return notes;
    } catch (e) {
      throw Exception('Failed to get semester notes: $e');
    }
  }

  // Get public notes
  Future<List<Note>> getPublicNotes({int limit = 20}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('isPublic', isEqualTo: true)
          .orderBy('likes', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get public notes: $e');
    }
  }

  // Search notes by title or content
  Future<List<Note>> searchNotes(String query, {String? userId}) async {
    try {
      Query queryBuilder = _firestore.collection(collection);
      
      if (userId != null) {
        queryBuilder = queryBuilder.where('userId', isEqualTo: userId);
      }

      QuerySnapshot querySnapshot = await queryBuilder.get();
      
      List<Note> allNotes = querySnapshot.docs
          .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Filter notes based on search query (case-insensitive)
      return allNotes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase()) ||
               note.content.toLowerCase().contains(query.toLowerCase()) ||
               note.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    } catch (e) {
      throw Exception('Failed to search notes: $e');
    }
  }

  // Update an existing note
  Future<void> updateNote(String noteId, Note note) async {
    try {
      await _firestore.collection(collection).doc(noteId).update(note.toMap());
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection(collection).doc(noteId).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  // Like/unlike a note
  Future<void> toggleLike(String noteId, String userId) async {
    try {
      DocumentReference docRef = _firestore.collection(collection).doc(noteId);
      
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(docRef);
        
        if (!docSnapshot.exists) {
          throw Exception('Note not found');
        }

        Note note = Note.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        List<String> likedBy = List<String>.from(note.likedBy);
        int likes = note.likes;

        if (likedBy.contains(userId)) {
          // Unlike
          likedBy.remove(userId);
          likes--;
        } else {
          // Like
          likedBy.add(userId);
          likes++;
        }

        transaction.update(docRef, {
          'likedBy': likedBy,
          'likes': likes,
        });
      });
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  // Get stream of notes for real-time updates
  Stream<List<Note>> getUserNotesStream(String userId) {
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Get stream of public notes for real-time updates
  Stream<List<Note>> getPublicNotesStream({int limit = 20}) {
    return _firestore
        .collection(collection)
        .where('isPublic', isEqualTo: true)
        .orderBy('likes', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Get stream of subject notes for real-time updates
  Stream<List<Note>> getSubjectNotesStream(String subjectId) {
    return _firestore
        .collection(collection)
        .where('subjectId', isEqualTo: subjectId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}
