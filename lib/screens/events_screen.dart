import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;
  
  const EventsScreen({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5);
    final appBarColor = isDark ? const Color(0xFF0D0D0D) : Colors.white;
    final cardColor = isDark ? const Color(0xFF141414) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8);
    final textColor = isDark ? const Color(0xFFF0F0F0) : const Color(0xFF111111);
    final subtleColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Color(0xFF1DB954), size: 24),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Events',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1DB954),
              ),
            ),
            Text(
              'Cross-College Event Platform',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFFA500),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA500),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Host Event',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
              // Promotion Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA500).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFA500).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.trending_up, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Promote Your Event',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFF0F0F0),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Reach 10,000+ students across colleges',
                            style: TextStyle(
                              fontSize: 11,
                              color: subtleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Boost',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryTab('All', true, borderColor, textColor, subtleColor),
                    const SizedBox(width: 12),
                    _buildCategoryTab('Technical', false, borderColor, textColor, subtleColor),
                    const SizedBox(width: 12),
                    _buildCategoryTab('Cultural', false, borderColor, textColor, subtleColor),
                    const SizedBox(width: 12),
                    _buildCategoryTab('Business', false, borderColor, textColor, subtleColor),
                    const SizedBox(width: 12),
                    _buildCategoryTab('Sports', false, borderColor, textColor, subtleColor),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Featured Section
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFA500), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'FEATURED & PROMOTED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFA500),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildEventCard(
                title: 'TechFest 2024',
                category: 'Technical',
                description: 'Annual technical festival featuring coding competitions, hackathons, robotics challenges, and tech talks from industry experts.',
                date: 'Mar 15-17, 2024',
                time: '9:00 AM onwards',
                location: 'Main Campus Auditorium',
                college: 'Engineering College, Barpeta',
                sponsors: ['TechCorp', 'InnovateLabs'],
                registered: 455,
                spotsLeft: 45,
                promoted: true,
                openToAll: true,
                free: true,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                subtleColor: subtleColor,
              ),
              const SizedBox(height: 16),
              _buildEventCard(
                title: 'Cultural Extravaganza',
                category: 'Cultural',
                description: 'A celebration of arts and culture featuring music performances, dance competitions, and cultural exhibitions.',
                date: 'Mar 20-22, 2024',
                time: '6:00 PM onwards',
                location: 'Open Air Theater',
                college: 'Arts College, Barpeta',
                sponsors: ['ArtsCorp'],
                registered: 320,
                spotsLeft: 80,
                promoted: false,
                openToAll: true,
                free: false,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                subtleColor: subtleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, bool active, Color borderColor, Color textColor, Color subtleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFA500) : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        border: active ? null : Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: active ? Colors.white : subtleColor,
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String category,
    required String description,
    required String date,
    required String time,
    required String location,
    required String college,
    required List<String> sponsors,
    required int registered,
    required int spotsLeft,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color subtleColor,
    bool promoted = false,
    bool openToAll = false,
    bool free = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Event Image Placeholder
          Container(
            width: double.infinity,
            height: 200,
            color: const Color(0xFFE8E8E8),
            child: Stack(
              children: [
                // Badges on top
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    children: [
                      if (promoted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA500),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'PROMOTED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (openToAll) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D9A3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'OPEN TO ALL',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      if (free) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D9A3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'FREE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Event Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Title
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1DB954),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF00D9A3),
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Date, Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFFFFA500)),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFF0F0F0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 14, color: Color(0xFFFFA500)),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Color(0xFFFFA500)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // College
                Row(
                  children: [
                    const Icon(Icons.business, size: 14, color: Color(0xFFFFA500)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        college,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Sponsors
                if (sponsors.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SPONSORED BY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: sponsors
                            .map((sponsor) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    sponsor,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Registration Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D0D),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E1E1E)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Color(0xFF888888)),
                          const SizedBox(width: 6),
                          Text(
                            '$registered registered',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF0F0F0),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$spotsLeft spots left',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFA500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Register Button and Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA500),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF1E1E1E)),
                      ),
                      child: const Icon(Icons.share, size: 18, color: Color(0xFF888888)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF1E1E1E)),
                      ),
                      child: const Icon(Icons.bookmark_outline, size: 18, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
