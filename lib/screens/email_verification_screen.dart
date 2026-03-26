import 'package:flutter/material.dart';
import 'dart:async';
import '../services/supabase_auth_service.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? userId;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.userId,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _authService = SupabaseAuthService();
  bool _isLoading = false;
  bool _emailVerified = false;
  int _resendCountdown = 0;
  late Timer _timer;
  int _checkAttempts = 0;
  static const int _maxCheckAttempts = 30; // Check for 30 seconds

  @override
  void initState() {
    super.initState();
    _startAutoCheck();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startAutoCheck() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (_checkAttempts < _maxCheckAttempts && !_emailVerified) {
        _checkAttempts++;
        await _checkEmailVerification();
      } else if (_checkAttempts >= _maxCheckAttempts) {
        _timer.cancel();
      }
    });
  }

  Future<void> _checkEmailVerification() async {
    if (!mounted) return;

    try {
      final result = await _authService.checkEmailVerification();

      if (!mounted) return;

      if (result['verified'] == true) {
        setState(() {
          _emailVerified = true;
        });
        _timer.cancel();

        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        // Still waiting for verification
        print('Waiting for email verification... (Attempt ${_checkAttempts}/$_maxCheckAttempts)');
      }
    } catch (e) {
      print('Error checking email verification: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF1DB954), size: 32),
            SizedBox(width: 12),
            Text('Verified!', style: TextStyle(color: Color(0xFFF0F0F0))),
          ],
        ),
        content: const Text(
          'Your email has been verified successfully. You can now log in to your account.',
          style: TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResendEmail() async {
    setState(() => _isLoading = true);

    final result = await _authService.resendVerificationEmail();

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor:
            result['success'] ? const Color(0xFF1DB954) : Colors.red,
      ),
    );

    if (result['success']) {
      setState(() => _resendCountdown = 60);
      _startCountdown();
    }
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() => _resendCountdown--);

      if (_resendCountdown == 0) {
        timer.cancel();
      }
    });
  }

  Future<void> _handleManualCheck() async {
    setState(() => _isLoading = true);
    
    print('Manually checking email verification...');
    await _checkEmailVerification();
    
    setState(() => _isLoading = false);
    
    if (!_emailVerified && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please click the verification link in your email'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.white;
    final textColor = isDark ? const Color(0xFFF0F0F0) : const Color(0xFF111111);
    final subtleColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);
    final inputBackBg = isDark ? const Color(0xFF161616) : const Color(0xFFF5F5F5);
    final inputBorder = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFDDDDDD);
    
    return Scaffold(
      body: Container(
        color: bgColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Illustration or Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.mail_outline,
                      size: 50,
                      color: Color(0xFF1DB954),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    'Verify Your Email',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'We\'ve sent a verification link to',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtleColor.withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1DB954),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Status message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1DB954).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF1DB954),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Please verify your email',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _emailVerified
                                    ? 'Email verified! You can now sign in.'
                                    : 'Waiting for email verification... ($_checkAttempts/$_maxCheckAttempts checks)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Check button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleManualCheck,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954),
                        disabledBackgroundColor:
                            const Color(0xFF1DB954).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Check Verification Status',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Resend button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: (_isLoading || _resendCountdown > 0)
                          ? null
                          : _handleResendEmail,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF1DB954),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _resendCountdown > 0
                            ? 'Resend Email in ${_resendCountdown}s'
                            : 'Resend Verification Email',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1DB954),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Help section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: inputBackBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: inputBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Verification tips:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF0F0F0),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTipItem('Check your spam/junk folder if you don\'t see the email'),
                        const SizedBox(height: 6),
                        _buildTipItem('The verification link expires in 24 hours'),
                        const SizedBox(height: 6),
                        _buildTipItem('Make sure you\'re using the email you registered with'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Back to login button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1DB954),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF888888),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF888888),
            ),
          ),
        ),
      ],
    );
  }
}
