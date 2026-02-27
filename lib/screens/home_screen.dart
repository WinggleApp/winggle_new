import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notifications_screen.dart';
import '../widgets/user_avatar.dart';
import 'academic_section.dart';
import 'competitive_section.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const HomeScreen({super.key, this.onProfileTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        _userName = user.displayName!.split(' ')[0]; // Get first name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    const SizedBox(height: 20),
                    _buildQuickStats(),
                    const SizedBox(height: 24),
                    const Text('Explore Features',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF064e3b))),
                    const SizedBox(height: 16),
                    _buildFeatureGrid(context),
                  ],
                ),
              ),
            ),
          ],
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
          const Text('Winggle',
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
              child: Stack(
                children: [
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          UserAvatar(
            onTap: widget.onProfileTap,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hello $_userName, 👋',
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF064e3b))),
        const SizedBox(height: 4),
        const Text('Welcome back to Winggle',
            style: TextStyle(fontSize: 14, color: Color(0xFF6b7280))),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('2.5k+', 'Students', Icons.people)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('12', 'Events', Icons.event)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('45', 'Jobs', Icons.work)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('18', 'Clubs', Icons.groups)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF10b981), size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF064e3b))),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _buildFeatureCard('Campus Corner', '24 ACTIVE', Icons.location_on,
            const Color(0xFF10b981)),
        _buildFeatureCard('Alumni Section', '1.2K MEMBERS', Icons.people,
            const Color(0xFF34d399)),
        _buildResourceLibraryCard(context),
        _buildFeatureCard(
            'Events', '12 NEW', Icons.event, const Color(0xFF059669)),
        _buildFeatureCard(
            'College Clubs', '18 CLUBS', Icons.groups, const Color(0xFF047857)),
        _buildFeatureCard(
            'Job Updates', '45 NEW', Icons.work, const Color(0xFF6ee7b7)),
        _buildFeatureCard(
            'Nexus Community', 'ACTIVE', Icons.forum, const Color(0xFF0d9488)),
        _buildFeatureCard(
            'She Shield', '24/7', Icons.shield, const Color(0xFFec4899)),
      ],
    );
  }

  Widget _buildFeatureCard(
      String title, String badge, IconData icon, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF10b981).withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(8)),
                    child: Text(badge,
                        style: const TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(title,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF064e3b))),
              const Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Explore',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color)),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 14, color: color),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildResourceLibraryCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResourceLibraryDetail(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF10b981).withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFF14b8a6),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.library_books, color: Colors.white, size: 22),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFF14b8a6), borderRadius: BorderRadius.circular(8)),
                    child: const Text('500+ ITEMS',
                        style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Resource Library',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF064e3b))),
              const Spacer(),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Explore',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF14b8a6))),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 14, color: Color(0xFF14b8a6)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceLibraryDetail extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const ResourceLibraryDetail({super.key, this.onProfileTap});

  @override
  State<ResourceLibraryDetail> createState() => _ResourceLibraryDetailState();
}

class _ResourceLibraryDetailState extends State<ResourceLibraryDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF064e3b)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resource Library',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF064e3b),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF10b981),
              unselectedLabelColor: const Color(0xFF9ca3af),
              indicatorColor: const Color(0xFF10b981),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Academic'),
                Tab(text: 'Competitive'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AcademicSection(onProfileTap: widget.onProfileTap),
                CompetitiveSection(onProfileTap: widget.onProfileTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
