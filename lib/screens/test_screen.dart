import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10b981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            const Icon(Icons.waving_hand, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Winggle',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10b981)),
                      ),
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12)),
                        child: Stack(children: [
                          const Center(
                              child: Icon(Icons.notifications_outlined,
                                  color: Color(0xFF059669))),
                          Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(9)),
                                child: const Center(
                                    child: Text('3',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700))),
                              )),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color(0xFF10b981),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                            child: Text('B',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Hello Biraj, 👋',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF064e3b))),
                const SizedBox(height: 4),
                const Text('Welcome back to Winggle',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6b7280))),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                      child: _buildStatCard('2.5k+', 'Students', Icons.people)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('12', 'Events', Icons.event)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _buildStatCard('45', 'Jobs', Icons.work)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('18', 'Clubs', Icons.groups)),
                ]),
                const SizedBox(height: 24),
                const Text('Explore Features',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF064e3b))),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _buildFeatureCard('Campus Corner', '24 ACTIVE',
                        Icons.location_on, const Color(0xFF10b981)),
                    _buildFeatureCard('Alumni Section', '1.2K MEMBERS',
                        Icons.people, const Color(0xFF34d399)),
                    _buildFeatureCard('Resource Library', '500+ ITEMS',
                        Icons.library_books, const Color(0xFF14b8a6)),
                    _buildFeatureCard('Events', '12 NEW', Icons.event,
                        const Color(0xFF059669)),
                    _buildFeatureCard('College Profile', 'INFO', Icons.school,
                        const Color(0xFF10b981)),
                    _buildFeatureCard('College Clubs', '18 CLUBS', Icons.groups,
                        const Color(0xFF047857)),
                    _buildFeatureCard('Job Updates', '45 NEW', Icons.work,
                        const Color(0xFF6ee7b7)),
                    _buildFeatureCard('Nexus Community', 'ACTIVE', Icons.forum,
                        const Color(0xFF0d9488)),
                    _buildFeatureCard('She Shield', '24/7', Icons.shield,
                        const Color(0xFFec4899)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _buildNavItem(Icons.home, 'Home', true),
            _buildNavItem(Icons.bookmark_border, 'Feed', false),
            _buildNavItem(Icons.all_inclusive, 'Loop', false),
            _buildNavItem(Icons.chat_bubble_outline, 'Chat', false),
            _buildNavItem(Icons.person_outline, 'Profile', false),
          ]),
        )),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.15)),
      ),
      child: Column(children: [
        Icon(icon, color: const Color(0xFF10b981), size: 24),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF064e3b))),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280))),
      ]),
    );
  }

  Widget _buildFeatureCard(
      String title, String badge, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: Colors.white, size: 32)),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(8)),
              child: Text(badge,
                  style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 12),
        Text(title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b))),
        const Spacer(),
        Row(children: [
          Text('Explore',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: 14, color: color),
        ]),
      ]),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon,
          color: isActive ? const Color(0xFF10b981) : const Color(0xFF9ca3af),
          size: 22),
      const SizedBox(height: 4),
      Text(label,
          style: TextStyle(
              fontSize: 10,
              color:
                  isActive ? const Color(0xFF10b981) : const Color(0xFF9ca3af),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500)),
    ]);
  }
}
