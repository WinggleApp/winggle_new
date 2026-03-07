import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_init_service.dart';

class AdminDatabaseInitializer {
  // List of admin emails
  static const List<String> adminEmails = [
    'your-admin-email@example.com', // Replace with your admin email
  ];

  // Check if current user is admin
  static bool isAdmin() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null && adminEmails.contains(user.email);
  }

  // Initialize database (admin only)
  static Future<void> initializeDatabase(BuildContext context) async {
    if (!isAdmin()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Access denied: Admin only'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final dbInit = DatabaseInitService();
      
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
      
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database initialized successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize database: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
