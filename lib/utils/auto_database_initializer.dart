import '../services/database_init_service.dart';

class AutoDatabaseInitializer {
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  // Initialize database automatically on app start
  static Future<void> initializeOnAppStart() async {
    if (_isInitialized || _isInitializing) return; // Prevent multiple initializations

    try {
      _isInitializing = true;
      final dbInit = DatabaseInitService();
      
      // Check if already initialized
      bool isAlreadyInitialized = await dbInit.isDatabaseInitialized();
      
      if (!isAlreadyInitialized) {
        print('🗄️ Initializing database for first time...');
        await dbInit.initializeDatabase();
        print('✅ Database initialized successfully');
      } else {
        print('📚 Database already initialized');
      }
      
      _isInitialized = true;
    } catch (e) {
      print('❌ Database initialization failed: $e');
      // Don't throw error - app should still work even if initialization fails
    } finally {
      _isInitializing = false;
    }
  }

  // Call this in your main.dart
  static Future<void> ensureInitialized() async {
    if (!_isInitialized && !_isInitializing) {
      await initializeOnAppStart();
    }
  }

  // Force reinitialize (for development/debugging)
  static Future<void> forceReinitialize() async {
    _isInitialized = false;
    await initializeOnAppStart();
  }

  // Check initialization status
  static bool get isInitialized => _isInitialized;
  static bool get isInitializing => _isInitializing;
}
