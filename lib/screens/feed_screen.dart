import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF141414) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8);
    final primaryText = isDark ? const Color(0xFFF0F0F0) : const Color(0xFF111111);
    final subtitleText = isDark ? const Color(0xFF555555) : const Color(0xFF888888);
    final inactiveBorder = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFDDDDDD);
    final inactiveTabBg = isDark ? const Color(0xFF141414) : const Color(0xFFF5F5F5);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: primaryText,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.more_vert, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildTab('All', true, inactiveBorder, inactiveTabBg),
                  const SizedBox(width: 12),
                  _buildTab('Projects', false, inactiveBorder, inactiveTabBg),
                  const SizedBox(width: 12),
                  _buildTab('Articles', false, inactiveBorder, inactiveTabBg),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildBookmarkItem(
                    icon: '📱', title: 'Flutter Best Practices',
                    category: 'Technology', date: '2 days ago',
                    tags: const ['Flutter', 'Mobile Dev'],
                    bg: surfaceColor, border: borderColor, primaryText: primaryText, subtitleText: subtitleText,
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '🎨', title: 'UI/UX Design System',
                    category: 'Design', date: '1 week ago',
                    tags: const ['Design', 'UI Kit'],
                    bg: surfaceColor, border: borderColor, primaryText: primaryText, subtitleText: subtitleText,
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '💼', title: 'Internship Opportunities',
                    category: 'Career', date: '3 days ago',
                    tags: const ['Internship', 'Job'],
                    bg: surfaceColor, border: borderColor, primaryText: primaryText, subtitleText: subtitleText,
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '🚀', title: 'Startup Ideas 2026',
                    category: 'Business', date: '1 week ago',
                    tags: const ['Startup', 'Innovation'],
                    bg: surfaceColor, border: borderColor, primaryText: primaryText, subtitleText: subtitleText,
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '📚', title: 'Learning Resources Hub',
                    category: 'Education', date: '2 weeks ago',
                    tags: const ['Learning', 'Resources'],
                    bg: surfaceColor, border: borderColor, primaryText: primaryText, subtitleText: subtitleText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool active, Color inactiveBorder, Color inactiveBg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1DB954).withValues(alpha: 0.15) : inactiveBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? const Color(0xFF1DB954) : inactiveBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: active ? const Color(0xFF1DB954) : const Color(0xFF888888),
        ),
      ),
    );
  }

  Widget _buildBookmarkItem({
    required String icon,
    required String title,
    required String category,
    required String date,
    required List<String> tags,
    required Color bg,
    required Color border,
    required Color primaryText,
    required Color subtitleText,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1DB954),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• $date',
                          style: TextStyle(
                            fontSize: 11,
                            color: subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.bookmark, color: Color(0xFF1DB954), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: tags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DB954).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF1DB954).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1DB954),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
