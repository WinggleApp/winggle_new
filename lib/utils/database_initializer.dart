import 'package:flutter/material.dart';
import '../services/database_init_service.dart';

class DatabaseInitializer {
  static Future<void> initializeDatabase(BuildContext context) async {
    try {
      final dbInit = DatabaseInitService();
      
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Initializing database...'),
            ],
          ),
        ),
      );

      await dbInit.initializeDatabase();
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database initialized successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize database: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
