import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final initials = ((user?.userMetadata?['display_name'] as String?) ?? 'U').split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF141414) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8);
    final primaryText = isDark ? const Color(0xFFF0F0F0) : const Color(0xFF111111);
    final subtitleText = isDark ? const Color(0xFF888888) : const Color(0xFF666666);
    final dimText = isDark ? const Color(0xFF555555) : const Color(0xFFAAAAAA);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Color(0xFF1DB954), size: 24),
        ),
        title: const Text(
          'Winggle',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1DB954),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
              },
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
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
                        fontSize: 14,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Stay updated with everything',
                style: TextStyle(
                  fontSize: 13,
                  color: subtitleText,
                ),
              ),
              const SizedBox(height: 20),

              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryTab('Academic', 5, 0),
                    const SizedBox(width: 8),
                    _buildCategoryTab('Job', 4, 1),
                    const SizedBox(width: 8),
                    _buildCategoryTab('Competitive', 1, 2),
                    const SizedBox(width: 8),
                    _buildCategoryTab('App', 0, 3),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Notifications List
              _buildNotificationItem(
                icon: Icons.menu_book,
                title: 'Resource Library',
                description: 'New study materials uploaded',
                time: '10 min ago',
                badgeCount: 1,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, descColor: subtitleText, timeColor: dimText,
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                icon: Icons.assignment,
                title: 'Assignment Due',
                description: 'Database Systems assignment due tomorrow',
                time: '1 hour ago',
                badgeCount: 1,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, descColor: subtitleText, timeColor: dimText,
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                icon: Icons.notifications,
                title: 'Campus Alert',
                description: 'New announcement from administration',
                time: '3 hours ago',
                badgeCount: 2,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, descColor: subtitleText, timeColor: dimText,
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                icon: Icons.event,
                title: 'Event Reminder',
                description: 'TechFest 2024 starts in 2 days',
                time: '5 hours ago',
                badgeCount: 0,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, descColor: subtitleText, timeColor: dimText,
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                icon: Icons.people,
                title: 'New Connection',
                description: 'Sarah Johnson sent you a connection request',
                time: '1 day ago',
                badgeCount: 0,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, descColor: subtitleText, timeColor: dimText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, int count, int index) {
    final isActive = _selectedTabIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveBg = isDark ? const Color(0xFF141414) : Colors.white;
    final inactiveBorder = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8);
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1DB954) : inactiveBg,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: inactiveBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : const Color(0xFF888888),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isActive ? Colors.white.withValues(alpha: 0.2) : const Color(0xFF1DB954).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : const Color(0xFF1DB954),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required int badgeCount,
    required Color bg,
    required Color border,
    required Color titleColor,
    required Color descColor,
    required Color timeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: descColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: timeColor,
                  ),
                ),
              ],
            ),
          ),

          // Badge
          if (badgeCount > 0)
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4757),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
