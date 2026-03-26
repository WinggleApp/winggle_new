import 'package:flutter/material.dart';

class LoopScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const LoopScreen({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Loop',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1DB954),
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
                child: const Icon(Icons.search, color: Colors.white, size: 18),
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
              Text(
                'Trending Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),
              _buildLoopCard(
                title: 'How to Build Scalable Applications',
                author: 'Alex Kumar',
                views: 2400,
                likes: 342,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, authorColor: subtitleText, heartColor: dimText,
              ),
              const SizedBox(height: 12),

              Text(
                'Popular in Campus',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),
              _buildLoopCard(
                title: 'Internship Tips & Tricks',
                author: 'Sarah Johnson',
                views: 1850,
                likes: 256,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, authorColor: subtitleText, heartColor: dimText,
              ),
              const SizedBox(height: 12),

              Text(
                'Fresh Content',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),
              _buildLoopCard(
                title: 'Web3 & Blockchain Basics',
                author: 'Dev Community',
                views: 950,
                likes: 178,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, authorColor: subtitleText, heartColor: dimText,
              ),
              const SizedBox(height: 12),
              _buildLoopCard(
                title: 'Design Thinking Workshop',
                author: 'Creative Minds',
                views: 1200,
                likes: 195,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, authorColor: subtitleText, heartColor: dimText,
              ),
              const SizedBox(height: 12),
              _buildLoopCard(
                title: 'Career Development Path',
                author: 'HR Team',
                views: 3100,
                likes: 512,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, authorColor: subtitleText, heartColor: dimText,
              ),
              const SizedBox(height: 12),
              _buildLoopCard(
                title: 'Networking Guide for Students',
                author: 'Mentorship Circle',
                views: 2050,
                likes: 423,
                bg: surfaceColor, border: borderColor, titleColor: primaryText, authorColor: subtitleText, heartColor: dimText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoopCard({
    required String title,
    required String author,
    required int views,
    required int likes,
    required Color bg,
    required Color border,
    required Color titleColor,
    required Color authorColor,
    required Color heartColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DB954).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1DB954).withValues(alpha: 0.3)),
                ),
                child: const Center(
                  child: Text(
                    '∞',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF1DB954),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by $author',
                      style: TextStyle(
                        fontSize: 11,
                        color: authorColor,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.favorite_border, color: heartColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '👁 $views',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1DB954),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '❤ $likes',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1DB954),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.share, size: 12, color: Color(0xFF1DB954)),
                    SizedBox(width: 4),
                    Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1DB954),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
