import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  late User? _currentUser;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;
  bool _isEditingUsername = false;
  bool _isEditingName = false;
  bool _isEditingBio = false;

  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    
    final profile = await _authService.getUserProfile();
    
    if (mounted) {
      setState(() {
        _userProfile = profile;
        if (profile != null) {
          _usernameController.text = profile['username'] ?? '';
          _nameController.text = profile['name'] ?? '';
          _bioController.text = profile['bio'] ?? '';
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUsername() async {
    if (_usernameController.text.trim().isEmpty) {
      _showErrorSnackBar('Username cannot be empty');
      return;
    }

    if (_usernameController.text == (_userProfile?['username'] ?? '')) {
      setState(() => _isEditingUsername = false);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.updateUsername(_usernameController.text.trim());

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      setState(() {
        _userProfile?['username'] = _usernameController.text.trim();
        _isEditingUsername = false;
      });
      _showSuccessSnackBar('Username updated successfully!');
      _loadUserProfile();
    } else {
      _showErrorSnackBar(result['message']);
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    final result = await _authService.updateUserProfile(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      setState(() {
        _isEditingName = false;
        _isEditingBio = false;
      });
      _showSuccessSnackBar('Profile updated successfully!');
      _loadUserProfile();
    } else {
      _showErrorSnackBar(result['message']);
    }
  }

  Future<void> _handleSignOut() async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text('Sign Out', style: TextStyle(color: Color(0xFFF0F0F0))),
        content: const Text('Are you sure you want to sign out?', style: TextStyle(color: Color(0xFF888888))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF1DB954))),
          ),
          // ignore: use_build_context_synchronously
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _authService.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1DB954),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1DB954)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: const Color(0xFF0A0A0A),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0A0A0A),
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF2A2A2A),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Avatar
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1DB954),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  (_userProfile?['name'] ?? _currentUser?.displayName ?? 'U')[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Display Name
                            Text(
                              _userProfile?['name'] ?? _currentUser?.displayName ?? 'User',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFF0F0F0),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Email
                            Text(
                              _currentUser?.email ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
                            ),
                            // Email Verification Status
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _currentUser?.emailVerified ?? false
                                    ? const Color(0xFF1DB954).withValues(alpha: 0.15)
                                    : Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _currentUser?.emailVerified ?? false
                                        ? Icons.verified
                                        : Icons.warning_outlined,
                                    size: 14,
                                    color: _currentUser?.emailVerified ?? false
                                        ? const Color(0xFF1DB954)
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _currentUser?.emailVerified ?? false
                                        ? 'Email Verified'
                                        : 'Email Not Verified',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _currentUser?.emailVerified ?? false
                                          ? const Color(0xFF1DB954)
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Edit Fields
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Username Section
                            _buildEditableField(
                              label: 'Username',
                              controller: _usernameController,
                              isEditing: _isEditingUsername,
                              onEdit: () => setState(() => _isEditingUsername = true),
                              onSave: _updateUsername,
                              onCancel: () {
                                _usernameController.text = _userProfile?['username'] ?? '';
                                setState(() => _isEditingUsername = false);
                              },
                              hint: 'Enter your username (3-20 characters)',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username cannot be empty';
                                }
                                if (value.length < 3 || value.length > 20) {
                                  return 'Username must be 3-20 characters';
                                }
                                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                  return 'Only letters, numbers, and underscores allowed';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Name Section
                            _buildEditableField(
                              label: 'Full Name',
                              controller: _nameController,
                              isEditing: _isEditingName,
                              onEdit: () => setState(() => _isEditingName = true),
                              onSave: _updateProfile,
                              onCancel: () {
                                _nameController.text = _userProfile?['name'] ?? '';
                                setState(() => _isEditingName = false);
                              },
                              hint: 'Enter your full name',
                            ),
                            const SizedBox(height: 20),
                            // Bio Section
                            _buildEditableField(
                              label: 'Bio',
                              controller: _bioController,
                              isEditing: _isEditingBio,
                              onEdit: () => setState(() => _isEditingBio = true),
                              onSave: _updateProfile,
                              onCancel: () {
                                _bioController.text = _userProfile?['bio'] ?? '';
                                setState(() => _isEditingBio = false);
                              },
                              hint: 'Tell us about yourself',
                              maxLines: 3,
                            ),
                            const SizedBox(height: 20),
                            // Account Info
                            _buildSectionTitle('Account Information'),
                            const SizedBox(height: 12),
                            _buildInfoTile(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: _currentUser?.email ?? 'Not set',
                            ),
                            const SizedBox(height: 12),
                            _buildInfoTile(
                              icon: Icons.calendar_today_outlined,
                              label: 'Account Created',
                              value: _currentUser?.metadata.creationTime?.toString().split('.')[0] ?? 'Unknown',
                            ),
                            const SizedBox(height: 20),
                            // Danger Zone
                            _buildSectionTitle('Danger Zone'),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _handleSignOut,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.withValues(alpha: 0.15),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    String? hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF0F0F0),
              ),
            ),
            if (!isEditing)
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1DB954),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (isEditing)
          Column(
            children: [
              TextField(
                controller: controller,
                maxLines: maxLines,
                style: const TextStyle(color: Color(0xFFF0F0F0)),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Color(0xFF555555)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2A2A2A),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF1DB954),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF161616),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF1DB954))),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Text(
              controller.text.isEmpty ? 'Not set' : controller.text,
              style: TextStyle(
                fontSize: 14,
                color: controller.text.isEmpty ? const Color(0xFF555555) : const Color(0xFFF0F0F0),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF0F0F0),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1DB954), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF0F0F0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
