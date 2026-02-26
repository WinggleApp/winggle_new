import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Returns the initials of the logged-in user.
/// Uses displayName first, then email as fallback.
/// Returns '?' if no user is logged in.
String getUserInitials() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return '?';

  final name = user.displayName ?? '';
  if (name.isNotEmpty) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  // Fallback to email
  final email = user.email ?? '';
  if (email.isNotEmpty) {
    return email[0].toUpperCase();
  }

  return '?';
}

/// Returns the display name of the logged-in user.
/// Falls back to email username, then 'User'.
String getUserDisplayName() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'User';

  print(user);

  if (user.displayName != null && user.displayName!.isNotEmpty) {
    return user.displayName!;
  }

  // Fallback to email username
  final email = user.email ?? '';
  if (email.contains('@')) {
    return email.split('@')[0];
  }

  return 'User';
}

/// Returns just the first name of the logged-in user.
String getUserFirstName() {
  final fullName = getUserDisplayName();
  return fullName.split(' ')[0];
}

/// A reusable avatar widget that shows the logged-in user's initials.
class UserAvatar extends StatelessWidget {
  final double size;
  final double fontSize;
  final double borderRadius;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.size = 40,
    this.fontSize = 14,
    this.borderRadius = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = getUserInitials();

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF10b981),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }
    return avatar;
  }
}
