import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _emailVerified = false;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _otpController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showSnackBar('Please enter the OTP sent to your email', isSuccess: false);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.verifyEmailOtp(
      email: widget.email,
      otp: otp,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _emailVerified = result['success'] == true;
    });

    _showSnackBar(
      result['message'] ?? 'Verification failed',
      isSuccess: result['success'] == true,
    );

    if (result['success'] == true) {
      _showSuccessDialog();
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() => _isLoading = true);

    final result = await _authService.resendVerificationEmail();

    if (!mounted) return;

    setState(() => _isLoading = false);

    _showSnackBar(
      result['message'] ?? 'Failed to resend OTP',
      isSuccess: result['success'] == true,
    );

    if (result['success'] == true) {
      setState(() => _resendCountdown = 60);
      _startCountdown();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendCountdown <= 1) {
        setState(() => _resendCountdown = 0);
        timer.cancel();
        return;
      }

      setState(() => _resendCountdown--);
    });
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? const Color(0xFF1DB954) : Colors.red,
      ),
    );
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
              Navigator.pop(context);
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      size: 50,
                      color: Color(0xFF1DB954),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Verify With OTP',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter the OTP sent to',
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
                  const SizedBox(height: 28),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '000000',
                      hintStyle: TextStyle(
                        letterSpacing: 8,
                        color: subtleColor,
                        fontWeight: FontWeight.w600,
                      ),
                      filled: true,
                      fillColor: inputBackBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: inputBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: inputBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: Color(0xFF1DB954), width: 2),
                      ),
                    ),
                    onSubmitted: (_) => _isLoading ? null : _handleVerifyOtp(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1DB954).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF1DB954), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _emailVerified
                                ? 'Email verified. Redirecting to login.'
                                : 'Did not get OTP? Tap resend to receive a new code.',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleVerifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954),
                        disabledBackgroundColor: const Color(0xFF1DB954).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: (_isLoading || _resendCountdown > 0) ? null : _handleResendOtp,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1DB954), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _resendCountdown > 0
                            ? 'Resend OTP in ${_resendCountdown}s'
                            : 'Resend OTP',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1DB954),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
}
