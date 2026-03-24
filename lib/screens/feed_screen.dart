import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFFF0F0F0),
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
            // Tab Selection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildTab('All', true),
                  const SizedBox(width: 12),
                  _buildTab('Projects', false),
                  const SizedBox(width: 12),
                  _buildTab('Articles', false),
                ],
              ),
            ),
            // Bookmark Items
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildBookmarkItem(
                    icon: '📱',
                    title: 'Flutter Best Practices',
                    category: 'Technology',
                    date: '2 days ago',
                    tags: const ['Flutter', 'Mobile Dev'],
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '🎨',
                    title: 'UI/UX Design System',
                    category: 'Design',
                    date: '1 week ago',
                    tags: const ['Design', 'UI Kit'],
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '💼',
                    title: 'Internship Opportunities',
                    category: 'Career',
                    date: '3 days ago',
                    tags: const ['Internship', 'Job'],
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '🚀',
                    title: 'Startup Ideas 2026',
                    category: 'Business',
                    date: '1 week ago',
                    tags: const ['Startup', 'Innovation'],
                  ),
                  const SizedBox(height: 12),
                  _buildBookmarkItem(
                    icon: '📚',
                    title: 'Learning Resources Hub',
                    category: 'Education',
                    date: '2 weeks ago',
                    tags: const ['Learning', 'Resources'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1DB954).withValues(alpha: 0.15) : const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? const Color(0xFF1DB954) : const Color(0xFF2A2A2A),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF0F0F0),
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
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF555555),
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
          // Tags
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
