import 'package:flutter/material.dart';

class AcademicSection extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const AcademicSection({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Academic Resources',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b),
              ),
            ),
            const SizedBox(height: 16),
            ..._buildResourceCards(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResourceCards() {
    final resources = [
      {
        'title': 'Mathematics',
        'description': 'Algebra, Geometry, Calculus',
        'icon': '∑',
        'color': const Color(0xFF3b82f6),
      },
      {
        'title': 'Science',
        'description': 'Physics, Chemistry, Biology',
        'icon': '⚗️',
        'color': const Color(0xFF8b5cf6),
      },
      {
        'title': 'Languages',
        'description': 'English, Hindi, Regional Languages',
        'icon': '📖',
        'color': const Color(0xFF10b981),
      },
      {
        'title': 'Social Studies',
        'description': 'History, Geography, Civics',
        'icon': '🌍',
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Computer Science',
        'description': 'Programming, Data Structures',
        'icon': '💻',
        'color': const Color(0xFFef4444),
      },
      {
        'title': 'Study Materials',
        'description': 'Notes, Textbooks, Guides',
        'icon': '📝',
        'color': const Color(0xFF06b6d4),
      },
    ];

    return resources.map((resource) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildResourceCard(
          resource['title'] as String,
          resource['description'] as String,
          resource['icon'] as String,
          resource['color'] as Color,
        ),
      );
    }).toList();
  }

  Widget _buildResourceCard(
    String title,
    String description,
    String icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1f2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6b7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFd1d5db),
            ),
          ],
        ),
      ),
    );
  }
}
