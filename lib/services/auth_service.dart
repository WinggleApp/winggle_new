import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

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

      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'profileComplete': false,
        'verified': false,
      });

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      return {
        'success': true,
        'message': 'Account created successfully! Please verify your email.',
        'user': userCredential.user
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/password accounts are not enabled';
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

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        return {
          'success': false,
          'message': 'Please verify your email before signing in',
          'needsVerification': true,
        };
      }

      return {
        'success': true,
        'message': 'Signed in successfully!',
        'user': userCredential.user
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'Email not registered';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many failed attempts. Please try again later';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/password accounts are not enabled';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again'};
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true, 'message': 'Password reset email sent!'};
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No account found with this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  // Resend verification email
  Future<Map<String, dynamic>> resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
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
      User? user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in', 'verified': false};
      }
      
      // Reload user to get latest verification status
      await user.reload();
      user = _auth.currentUser;
      
      if (user!.emailVerified) {
        // Update Firestore to mark as verified
        await _firestore.collection('users').doc(user.uid).update({
          'verified': true,
          'emailVerifiedAt': FieldValue.serverTimestamp(),
        });
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
      User? user = _auth.currentUser;
      if (user == null) return null;
      
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data() as Map<String, dynamic>?;
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

      User? user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      // Check if username is already taken
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: newUsername)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty && snapshot.docs.first.id != user.uid) {
        return {'success': false, 'message': 'Username already taken'};
      }

      // Update display name in Firebase Auth
      await user.updateDisplayName(newUsername);

      // Update username in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'username': newUsername,
        'updatedAt': FieldValue.serverTimestamp(),
      });

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
      User? user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null && name.isNotEmpty) {
        updateData['name'] = name;
        await user.updateDisplayName(name);
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
        updateData['profileImageUrl'] = profileImageUrl;
      }

      await _firestore.collection('users').doc(user.uid).update(updateData);
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
