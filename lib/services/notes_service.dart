import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class NotesService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Upload a note file to Firebase Storage and save metadata to Firestore
  Future<Map<String, dynamic>?> uploadNote({
    required File file,
    required String departmentAbbr,
    required int semesterNum,
    required String subjectCode,
    required String subjectName,
    String? fileName,
  }) async {
    try {
      // Get current user
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Validate file
      if (!file.existsSync()) {
        throw Exception('File does not exist');
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        throw Exception('File is empty');
      }

      // Create upload path: /notes/CSE/Semester1/MA101/
      final uploadPath =
          'notes/$departmentAbbr/Semester$semesterNum/$subjectCode';
      final fileNameToUse = fileName ?? file.path.split('/').last;
      final storagePath = '$uploadPath/$fileNameToUse';

      // Upload file to Firebase Storage
      final Reference ref = _storage.ref(storagePath);
      final UploadTask uploadTask = ref.putFile(file);

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Create metadata document in Firestore
      final noteData = {
        'fileName': fileNameToUse,
        'downloadUrl': downloadUrl,
        'fileSize': fileSize,
        'departmentAbbr': departmentAbbr,
        'semesterNum': semesterNum,
        'subjectCode': subjectCode,
        'subjectName': subjectName,
        'uploaderName': currentUser.displayName ?? currentUser.email ?? 'Anonymous',
        'uploaderUid': currentUser.uid,
        'uploadedAt': Timestamp.now(),
        'views': 0,
        'downloads': 0,
        'rating': 0,
        'ratingCount': 0,
      };

      // Save to Firestore under subcollections: users/{uid}/notes
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('notes')
          .add(noteData);

      // Also save to general course notes collection for sharing
      await _firestore
          .collection('courseNotes')
          .doc('$departmentAbbr-Semester$semesterNum-$subjectCode')
          .collection('notes')
          .add(noteData);

      return {
        'success': true,
        'message': 'Note uploaded successfully',
        'downloadUrl': downloadUrl,
        'noteData': noteData,
      };
    } on FirebaseException catch (e) {
      return {
        'success': false,
        'message': 'Firebase error: ${e.message}',
        'error': e,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error uploading note: $e',
        'error': e,
      };
    }
  }

  /// Get all notes for a specific subject
  Future<List<Map<String, dynamic>>> getNotesForSubject({
    required String departmentAbbr,
    required int semesterNum,
    required String subjectCode,
  }) async {
    try {
      final collection = _firestore
          .collection('courseNotes')
          .doc('$departmentAbbr-Semester$semesterNum-$subjectCode')
          .collection('notes');

      final snapshot = await collection.orderBy('uploadedAt', descending: true).get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching notes: $e');
      return [];
    }
  }

  /// Get user's uploaded notes
  Future<List<Map<String, dynamic>>> getUserNotes() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('notes')
          .orderBy('uploadedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching user notes: $e');
      return [];
    }
  }

  /// Update note view count
  Future<void> incrementViewCount(String docId, String departmentAbbr,
      int semesterNum, String subjectCode) async {
    try {
      final docPath =
          'courseNotes/$departmentAbbr-Semester$semesterNum-$subjectCode/notes/$docId';
      await _firestore.doc(docPath).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing view count: $e');
    }
  }

  /// Update note download count
  Future<void> incrementDownloadCount(String docId, String departmentAbbr,
      int semesterNum, String subjectCode) async {
    try {
      final docPath =
          'courseNotes/$departmentAbbr-Semester$semesterNum-$subjectCode/notes/$docId';
      await _firestore.doc(docPath).update({
        'downloads': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing download count: $e');
    }
  }

  /// Update note rating
  Future<void> updateRating(String docId, String departmentAbbr,
      int semesterNum, String subjectCode, double newRating) async {
    try {
      final docPath =
          'courseNotes/$departmentAbbr-Semester$semesterNum-$subjectCode/notes/$docId';
      final doc = await _firestore.doc(docPath).get();
      
      final currentRating = doc['rating'] ?? 0;
      final ratingCount = (doc['ratingCount'] ?? 0) + 1;
      final updatedRating = (currentRating + newRating) / ratingCount;

      await _firestore.doc(docPath).update({
        'rating': updatedRating,
        'ratingCount': ratingCount,
      });
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  /// Delete a note (only by uploader)
  Future<bool> deleteNote(String docId, String fileName,
      String departmentAbbr, int semesterNum, String subjectCode) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Delete from Storage
      final storagePath =
          'notes/$departmentAbbr/Semester$semesterNum/$subjectCode/$fileName';
      await _storage.ref(storagePath).delete();

      // Delete from user's collection
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('notes')
          .doc(docId)
          .delete();

      // Delete from course notes collection
      await _firestore
          .collection('courseNotes')
          .doc('$departmentAbbr-Semester$semesterNum-$subjectCode')
          .collection('notes')
          .doc(docId)
          .delete();

      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }
}
