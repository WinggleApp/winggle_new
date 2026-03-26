import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onEventsPressed;
  final VoidCallback? onLibraryPressed;
  final VoidCallback? onThemeToggle;

  const HomeScreen({
    super.key,
    this.onNotificationPressed,
    this.onEventsPressed,
    this.onLibraryPressed,
    this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final initials = (user?.userMetadata?['display_name'] ?? user?.email ?? 'U')
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join()
        .toUpperCase();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = isDark ? const Color(0xFF141414) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8);
    final innerBg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F5);
    final storyBg = isDark ? const Color(0xFF181818) : const Color(0xFFF0F0F0);
    final inactiveBorder = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFDDDDDD);
    final primaryText = isDark ? const Color(0xFFF0F0F0) : const Color(0xFF111111);
    final subtitleText = isDark ? const Color(0xFF555555) : const Color(0xFF888888);
    final dimText = isDark ? const Color(0xFF444444) : const Color(0xFFAAAAAA);
    final notifBg = isDark ? const Color(0xFF161616) : const Color(0xFFF0F0F0);
    final notifBorder = isDark ? const Color(0xFF222222) : const Color(0xFFDDDDDD);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Winggle',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1DB954),
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Center(
              child: _SlidingThemeToggle(isDark: isDark, onToggle: onThemeToggle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: onNotificationPressed,
              child: Center(
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: notifBg,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: notifBorder),
                  ),
                  child: const Icon(Icons.notifications_none, color: Color(0xFF888888), size: 18),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
              },
              child: Center(
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DB954),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF0D0D0D),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '// GOOD MORNING',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1DB954),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(user?.userMetadata?['display_name'] as String?)?.split(' ').first ?? 'User'} 👋',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: primaryText,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your campus is live right now',
                        style: TextStyle(
                          fontSize: 12,
                          color: subtitleText,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatBox('2.5k', 'students', innerBg, borderColor, dimText),
                          _buildStatBox('48', 'new jobs', innerBg, borderColor, dimText),
                          _buildStatBox('12', 'events', innerBg, borderColor, dimText),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Explore Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EXPLORE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'See all →',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1DB954),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Stories/Categories
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStoryItem('💼', 'Jobs', '48 new', true, primaryText, storyBg, inactiveBorder),
                    GestureDetector(
                      onTap: onLibraryPressed,
                      child: _buildStoryItem('📖', 'Library', '500+', true, primaryText, storyBg, inactiveBorder),
                    ),
                    _buildStoryItem('📍', 'Campus', '24 spots', true, primaryText, storyBg, inactiveBorder),
                    _buildStoryItem('💬', 'Nexus', 'Active', false, primaryText, storyBg, inactiveBorder),
                    GestureDetector(
                      onTap: onEventsPressed,
                      child: _buildStoryItem('📅', 'Events', '12', false, primaryText, storyBg, inactiveBorder),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // For You Section
              Text(
                'FOR YOU',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),

              _buildFeedCard('💬', 'Community Post', 'Amazing opportunity for freshers', '2m ago', true, surfaceColor, borderColor, dimText, primaryText),
              const SizedBox(height: 8),
              _buildFeedCard('📢', 'Announcement', 'New workshop announced', '1h ago', true, surfaceColor, borderColor, dimText, primaryText),
              const SizedBox(height: 8),
              _buildFeedCard('🔥', 'Trending', 'Check out the latest discussion', '3h ago', true, surfaceColor, borderColor, dimText, primaryText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String value, String label, Color bg, Color border, Color dimText) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1DB954),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: dimText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(String emoji, String label, String subtitle, bool active,
      Color primaryText, Color bg, Color inactiveBorder) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(
                color: active ? const Color(0xFF1DB954) : inactiveBorder,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: active ? const Color(0xFF1DB954) : const Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCard(String icon, String type, String title, String time, bool isPrimary,
      Color bg, Color border, Color dimText, Color primaryText) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPrimary ? const Color(0xFF1DB954).withValues(alpha: 0.1) : border,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isPrimary ? const Color(0xFF1DB954) : const Color(0xFF888888),
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: dimText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: primaryText,
                    letterSpacing: -0.2,
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

class _SlidingThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onToggle;

  const _SlidingThemeToggle({required this.isDark, this.onToggle});

  @override
  Widget build(BuildContext context) {
    const trackW = 58.0;
    const trackH = 30.0;
    const thumbSize = 24.0;
    const pad = 3.0;
    final thumbLeft = isDark ? pad : trackW - pad - thumbSize;

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        width: trackW,
        height: trackH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(trackH / 2),
          color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
          border: Border.all(
            color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFCCCCCC),
          ),
        ),
        child: Stack(
          children: [
            // Moon icon — left side
            const Positioned(
              left: 7,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(Icons.dark_mode_outlined, size: 13, color: Color(0xFF666666)),
              ),
            ),
            // Sun icon — right side
            const Positioned(
              right: 7,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(Icons.light_mode_outlined, size: 13, color: Color(0xFF999999)),
              ),
            ),
            // Animated thumb
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              left: thumbLeft,
              top: pad,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1DB954),
                ),
                child: Center(
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
