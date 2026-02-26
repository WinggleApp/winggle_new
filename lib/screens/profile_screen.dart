import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'notifications_screen.dart';
import '../widgets/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildStatsSection(),
              const SizedBox(height: 20),
              _buildSocialLinks(),
              const SizedBox(height: 20),
              _buildTabs(context),
              const SizedBox(height: 20),
              _buildAboutSection(),
              const SizedBox(height: 20),
              _buildRecentConnections(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          const Text('Profile',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10b981))),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsScreen()));
            },
            child: Container(
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
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 10),
                    Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2))),
                    ListTile(
                        leading:
                            const Icon(Icons.edit, color: Color(0xFF10b981)),
                        title: const Text('Edit Profile'),
                        onTap: () => Navigator.pop(context)),
                    ListTile(
                        leading: const Icon(Icons.settings,
                            color: Color(0xFF10b981)),
                        title: const Text('Settings'),
                        onTap: () => Navigator.pop(context)),
                    ListTile(
                        leading:
                            const Icon(Icons.share, color: Color(0xFF10b981)),
                        title: const Text('Share Profile'),
                        onTap: () => Navigator.pop(context)),
                    ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Logout'),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                  'Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel',
                                      style:
                                          TextStyle(color: Color(0xFF6b7280))),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    await FirebaseAuth.instance.signOut();
                                  },
                                  child: const Text('Logout',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        }),
                    const SizedBox(height: 20),
                  ]),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.more_vert, color: Color(0xFF059669)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF10b981).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: [
        Stack(children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF10b981), Color(0xFF34d399)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF10b981).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Center(
                child: Text(getUserInitials(),
                    style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Colors.white))),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFF10b981),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 3)),
                child:
                    const Icon(Icons.verified, color: Colors.white, size: 20),
              )),
        ]),
        const SizedBox(height: 16),
        Text(getUserDisplayName(),
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF064e3b))),
        const SizedBox(height: 4),
        const Text('Computer Science Student',
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6b7280),
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xFF10b981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [
              Icon(Icons.location_on, size: 14, color: Color(0xFF10b981)),
              SizedBox(width: 4),
              Text('Barpeta, Assam',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10b981),
                      fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xFF10b981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [
              Icon(Icons.school, size: 14, color: Color(0xFF10b981)),
              SizedBox(width: 4),
              Text('Final Year',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10b981),
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        const Text(
            'Looking for collaborations and networking opportunities. Connect with me!',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 13, color: Color(0xFF6b7280), height: 1.4)),
      ]),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _buildStatItem('867', 'Orbit', Icons.people),
        Container(
            width: 1,
            height: 40,
            color: const Color(0xFF10b981).withValues(alpha: 0.2)),
        _buildStatItem('253', 'Posts', Icons.article),
        Container(
            width: 1,
            height: 40,
            color: const Color(0xFF10b981).withValues(alpha: 0.2)),
        _buildStatItem('104', 'Reviews', Icons.star),
      ]),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(children: [
      Icon(icon, color: const Color(0xFF10b981), size: 24),
      const SizedBox(height: 8),
      Text(value,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF064e3b))),
      const SizedBox(height: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6b7280),
              fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _buildSocialLinks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Social Links',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b))),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildSocialBadge(
              icon: FontAwesomeIcons.linkedinIn,
              background: const Color(0xFF0A66C2)),
          _buildSocialBadge(
              icon: FontAwesomeIcons.instagram,
              gradient: const LinearGradient(colors: [
                Color(0xFFF58529),
                Color(0xFFDD2A7B),
                Color(0xFF8134AF),
                Color(0xFF515BD4)
              ])),
          _buildSocialBadge(icon: FontAwesomeIcons.x, background: Colors.black),
          _buildSocialBadge(
              icon: FontAwesomeIcons.envelope,
              background: const Color(0xFFEA4335)),
          _buildSocialBadge(
              icon: FontAwesomeIcons.facebookF,
              background: const Color(0xFF1877F2)),
        ]),
        const SizedBox(height: 12),
        const Center(
            child: Text('05 Active social links',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6b7280),
                    fontWeight: FontWeight.w500))),
      ]),
    );
  }

  Widget _buildSocialBadge(
      {required IconData icon, Color? background, Gradient? gradient}) {
    final bg = background ?? Colors.white;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: gradient == null ? bg : null,
        gradient: gradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: (background ?? Colors.black).withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Center(child: FaIcon(icon, color: Colors.white, size: 20)),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: const Color(0xFF10b981),
              borderRadius: BorderRadius.circular(16)),
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.info, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('About',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ]),
        )),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.photo, color: Color(0xFF6b7280), size: 18),
            SizedBox(width: 8),
            Text('Photos',
                style: TextStyle(
                    color: Color(0xFF6b7280), fontWeight: FontWeight.w600)),
          ]),
        )),
      ]),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildInfoRow(
            Icons.work, 'Student at Engineering College', '2024-2028'),
        const SizedBox(height: 16),
        _buildInfoRow(
            Icons.school, 'B.Tech in Computer Science', 'Expected 2028'),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.visibility, '655 content views', '352 this month'),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.calendar_today, 'Joined July 2025', 'Member since'),
      ]),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: const Color(0xFF10b981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF10b981), size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF064e3b))),
        const SizedBox(height: 2),
        Text(subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
      ])),
    ]);
  }

  Widget _buildRecentConnections() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Recent Orbit',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b))),
        const SizedBox(height: 16),
        _buildConnectionItem('Sarah Johnson', 'Mumbai, Maharashtra', 'S',
            const Color(0xFF10b981)),
        const SizedBox(height: 12),
        _buildConnectionItem(
            'Rahul Verma', 'Delhi, India', 'R', const Color(0xFF34d399)),
        const SizedBox(height: 12),
        _buildConnectionItem('Priya Singh', 'Bangalore, Karnataka', 'P',
            const Color(0xFF14b8a6)),
      ]),
    );
  }

  Widget _buildConnectionItem(
      String name, String location, String initial, Color color) {
    return Row(children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Text(initial,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white))),
      ),
      const SizedBox(width: 12),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b))),
        const SizedBox(height: 2),
        Text(location,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
      ])),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color(0xFF10b981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.more_horiz, color: Color(0xFF10b981), size: 20),
      ),
    ]);
  }
}
