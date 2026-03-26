import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseNotesService {
  final supabase = Supabase.instance.client;

  /// Upload a note file to Supabase Storage and save metadata to database
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
      final User? currentUser = supabase.auth.currentUser;
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

      // Upload file to Supabase Storage
      await supabase.storage.from('notes_bucket').upload(
        storagePath,
        file,
      );

      // Get download URL
      final downloadUrl =
          supabase.storage.from('notes_bucket').getPublicUrl(storagePath);

      // Get uploader info
      final uploaderName =
          currentUser.userMetadata?['display_name'] as String? ??
              currentUser.email ??
              'Anonymous';

      // Create metadata record in database
      final noteData = {
        'file_name': fileNameToUse,
        'download_url': downloadUrl,
        'file_size': fileSize,
        'department_abbr': departmentAbbr,
        'semester_num': semesterNum,
        'subject_code': subjectCode,
        'subject_name': subjectName,
        'uploader_name': uploaderName,
        'uploader_uid': currentUser.id,
        'views': 0,
        'downloads': 0,
        'rating': 0,
        'rating_count': 0,
      };

      // Save to database
      await supabase.from('notes').insert(noteData);

      return {
        'success': true,
        'message': 'Note uploaded successfully',
        'downloadUrl': downloadUrl,
        'noteData': noteData,
      };
    } on StorageException catch (e) {
      return {
        'success': false,
        'message': 'Storage error: ${e.message}',
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
      final response = await supabase
          .from('notes')
          .select()
          .eq('department_abbr', departmentAbbr)
          .eq('semester_num', semesterNum)
          .eq('subject_code', subjectCode)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching notes: $e');
      return [];
    }
  }

  /// Get user's uploaded notes
  Future<List<Map<String, dynamic>>> getUserNotes() async {
    try {
      final User? currentUser = supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await supabase
          .from('notes')
          .select()
          .eq('uploader_uid', currentUser.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user notes: $e');
      return [];
    }
  }

  /// Update note view count
  Future<void> incrementViewCount(
    String noteId,
    String departmentAbbr,
    int semesterNum,
    String subjectCode,
  ) async {
    try {
      // Get current view count
      final response =
          await supabase.from('notes').select('views').eq('id', noteId).single();

      final currentViews = (response['views'] as int?) ?? 0;

      // Update with incremented count
      await supabase
          .from('notes')
          .update({'views': currentViews + 1}).eq('id', noteId);
    } catch (e) {
      print('Error incrementing view count: $e');
    }
  }

  /// Update note download count
  Future<void> incrementDownloadCount(
    String noteId,
    String departmentAbbr,
    int semesterNum,
    String subjectCode,
  ) async {
    try {
      // Get current download count
      final response = await supabase
          .from('notes')
          .select('downloads')
          .eq('id', noteId)
          .single();

      final currentDownloads = (response['downloads'] as int?) ?? 0;

      // Update with incremented count
      await supabase
          .from('notes')
          .update({'downloads': currentDownloads + 1}).eq('id', noteId);
    } catch (e) {
      print('Error incrementing download count: $e');
    }
  }

  /// Update note rating
  Future<void> updateRating(
    String noteId,
    String departmentAbbr,
    int semesterNum,
    String subjectCode,
    double newRating,
  ) async {
    try {
      // Get current rating and count
      final response = await supabase
          .from('notes')
          .select('rating, rating_count')
          .eq('id', noteId)
          .single();

      final currentRating = (response['rating'] as num?)?.toDouble() ?? 0.0;
      final ratingCount = (response['rating_count'] as int?) ?? 0;

      final updatedCount = ratingCount + 1;
      final updatedRating = (currentRating + newRating) / updatedCount;

      // Update with new rating
      await supabase.from('notes').update({
        'rating': updatedRating,
        'rating_count': updatedCount,
      }).eq('id', noteId);
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  /// Delete a note (only by uploader)
  Future<bool> deleteNote(
    String noteId,
    String fileName,
    String departmentAbbr,
    int semesterNum,
    String subjectCode,
  ) async {
    try {
      final User? currentUser = supabase.auth.currentUser;
      if (currentUser == null) return false;

      // Verify ownership and get file name for deletion
      final response =
          await supabase.from('notes').select().eq('id', noteId).single();

      if (response['uploader_uid'] != currentUser.id) {
        throw Exception('You do not have permission to delete this note');
      }

      // Delete from Storage
      final storagePath =
          'notes/$departmentAbbr/Semester$semesterNum/$subjectCode/$fileName';
      await supabase.storage.from('notes_bucket').remove([storagePath]);

      // Delete from database
      await supabase.from('notes').delete().eq('id', noteId);

      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }
}
