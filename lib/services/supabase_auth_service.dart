import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => supabase.auth.currentUser;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<Map<String, dynamic>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Validate email format
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Invalid email format'};
      }

      // Validate phone number
      if (!_isValidPhone(phone)) {
        return {'success': false, 'message': 'Invalid phone number. Use format: +91XXXXXXXXXX'};
      }

      // Validate password strength
      if (!_isValidPassword(password)) {
        return {
          'success': false,
          'message': 'Password must be at least 8 characters with uppercase, lowercase, number and special character'
        };
      }

      // Sign up with Supabase Auth
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'display_name': name,
          'phone': phone,
        },
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException('Supabase Auth timeout');
      });

      final user = res.user;
      if (user == null) {
        return {'success': false, 'message': 'Failed to create user'};
      }

      // Store user data in Supabase 'users' table
      try {
        await supabase.from('users').insert({
          'uid': user.id,
          'name': name,
          'email': email,
          'phone': phone,
          'profile_complete': false,
        }).timeout(
          const Duration(seconds: 10),
        );
      } catch (dbError) {
        print('Warning: Could not store user profile: $dbError');
        // Don't fail signup if database insert fails
        // User can still sign in, profile creation is secondary
      }

      return {
        'success': true,
        'message': 'Account created successfully! Please verify your email.',
        'user': user
      };
    } on AuthException catch (e) {
      String message = 'An error occurred';
      if (e.message.contains('already registered')) {
        message = 'An account already exists for this email';
      } else if (e.message.contains('invalid')) {
        message = 'Invalid credentials provided';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email format first
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Invalid email format'};
      }

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException('Sign in timeout');
      });

      final user = res.user;
      if (user == null) {
        return {'success': false, 'message': 'Failed to sign in'};
      }

      // For now, allow login without email verification
      // (Supabase doesn't enforce email verification by default)
      return {
        'success': true,
        'message': 'Signed in successfully!',
        'user': user
      };
    } on AuthException catch (e) {
      String message = 'An error occurred';
      if (e.message.contains('Invalid login credentials')) {
        message = 'Email or password is incorrect';
      } else if (e.message.contains('User not found')) {
        message = 'Email not registered';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again'};
    }
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Send password reset email
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      return {'success': true, 'message': 'Password reset email sent!'};
    } on AuthException catch (e) {
      String message = 'An error occurred';
      if (e.message.contains('not found')) {
        message = 'No account found with this email';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  // Resend verification email
  Future<Map<String, dynamic>> resendVerificationEmail() async {
    try {
      User? user = supabase.auth.currentUser;
      if (user != null && user.emailConfirmedAt == null) {
        await supabase.auth.resend(
          type: OtpType.signup,
          email: user.email ?? '',
        );
        return {'success': true, 'message': 'Verification email sent!'};
      }
      return {'success': false, 'message': 'User not found or already verified'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  // Check if email is verified and refresh user
  Future<Map<String, dynamic>> checkEmailVerification() async {
    try {
      User? user = supabase.auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in', 'verified': false};
      }

      // Refresh user session to get latest data
      try {
        await supabase.auth.refreshSession().timeout(
          const Duration(seconds: 8),
        );
      } catch (e) {
        print('Error refreshing user: $e');
      }

      user = supabase.auth.currentUser;

      if (user?.emailConfirmedAt != null) {
        return {'success': true, 'message': 'Email verified!', 'verified': true};
      }

      return {'success': false, 'message': 'Email not yet verified', 'verified': false};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}', 'verified': false};
    }
  }

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      User? user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('users')
          .select()
          .eq('uid', user.id)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // Update username
  Future<Map<String, dynamic>> updateUsername(String newUsername) async {
    try {
      // Validate username
      if (!_isValidUsername(newUsername)) {
        return {
          'success': false,
          'message': 'Username must be 3-20 characters, containing only letters, numbers, and underscores'
        };
      }

      User? user = supabase.auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      // Check if username is already taken
      final response = await supabase
          .from('users')
          .select()
          .eq('username', newUsername)
          .limit(1);

      if (response.isNotEmpty && response[0]['uid'] != user.id) {
        return {'success': false, 'message': 'Username already taken'};
      }

      // Update user metadata in Supabase Auth
      await supabase.auth.updateUser(
        UserAttributes(data: {'display_name': newUsername}),
      );

      // Update username in database
      await supabase.from('users').update({
        'username': newUsername,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('uid', user.id);

      return {'success': true, 'message': 'Username updated successfully!'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      User? user = supabase.auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      Map<String, dynamic> updateData = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null && name.isNotEmpty) {
        updateData['name'] = name;
        // Also update in auth metadata
        await supabase.auth.updateUser(
          UserAttributes(data: {'display_name': name}),
        );
      }

      if (phone != null) {
        if (!_isValidPhone(phone)) {
          return {'success': false, 'message': 'Invalid phone number format'};
        }
        updateData['phone'] = phone;
      }

      if (bio != null) {
        updateData['bio'] = bio;
      }

      if (profileImageUrl != null) {
        updateData['profile_image_url'] = profileImageUrl;
      }

      await supabase.from('users').update(updateData).eq('uid', user.id);
      return {'success': true, 'message': 'Profile updated successfully!'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  // Validation helpers
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Indian phone number format: +91[6-9]XXXXXXXXX (10 digits, first must be 6-9)
    final phoneRegex = RegExp(r'^\+91[6-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
    if (password.length < 8) return false;

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  bool _isValidUsername(String username) {
    // 3-20 characters, only letters, numbers, and underscores
    if (username.length < 3 || username.length > 20) return false;
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return usernameRegex.hasMatch(username);
  }
}
