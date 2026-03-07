import 'package:firebase_auth/firebase_auth.dart';
import 'semester_service.dart';
import 'subject_service.dart';

class DatabaseInitService {
  final SemesterService _semesterService = SemesterService();
  final SubjectService _subjectService = SubjectService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize the database with common data
  Future<void> initializeDatabase() async {
    try {
      print('🚀 Initializing database...');
      
      // Check if user is authenticated
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ No authenticated user found');
        throw Exception('User must be authenticated to initialize database');
      }
      
      print('✅ User authenticated: ${user.email}');
      
      // Initialize semesters first
      await _semesterService.initializeCommonSemesters();
      print('✅ Semesters initialized successfully');
      
      // Initialize subjects
      await _subjectService.initializeCommonSubjects();
      print('✅ Subjects initialized successfully');
      
      print('🎉 Database initialization completed successfully');
    } catch (e) {
      print('❌ Database initialization failed: $e');
      throw Exception('Failed to initialize database: $e');
    }
  }

  // Check if database is already initialized
  Future<bool> isDatabaseInitialized() async {
    try {
      // Check if we have any semesters
      final semesters = await _semesterService.getAllSemesters();
      return semesters.isNotEmpty;
    } catch (e) {
      print('Error checking database initialization: $e');
      return false;
    }
  }

  // Force reinitialize database (useful for development)
  Future<void> forceReinitializeDatabase() async {
    try {
      print('Force reinitializing database...');
      
      // Note: In production, you might want to be more careful about this
      // For now, we'll just add the common data again without clearing existing data
      
      await initializeDatabase();
      print('Database force reinitialization completed');
    } catch (e) {
      print('Database force reinitialization failed: $e');
      throw Exception('Failed to force reinitialize database: $e');
    }
  }

  // Initialize database for a specific user
  Future<void> initializeUserDatabase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      print('Initializing database for user: ${user.email}');
      
      // Ensure the main database is initialized first
      if (!await isDatabaseInitialized()) {
        await initializeDatabase();
      }
      
      print('User database initialization completed');
    } catch (e) {
      print('User database initialization failed: $e');
      throw Exception('Failed to initialize user database: $e');
    }
  }

  // Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final semesters = await _semesterService.getAllSemesters();
      final subjects = await _subjectService.getAllSubjects();
      
      return {
        'totalSemesters': semesters.length,
        'totalSubjects': subjects.length,
        'activeSemesters': semesters.where((s) => s.isActive).length,
        'branches': subjects.map((s) => s.department).toSet().length,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Error getting database stats: $e');
      return {
        'error': e.toString(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    }
  }
}
