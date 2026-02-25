import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Winggle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF10b981),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10b981),
          primary: const Color(0xFF10b981),
          secondary: const Color(0xFF059669),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          Center(child: Text('Feed Screen', style: TextStyle(fontSize: 24))),
          LoopScreen(),
          ChatScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.bookmark_border, 'Feed'),
                _buildNavItem(2, Icons.all_inclusive, 'Loop'),
                _buildNavItem(3, Icons.chat_bubble_outline, 'Chat'),
                _buildNavItem(4, Icons.person_outline, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF10b981).withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive
                    ? const Color(0xFF10b981)
                    : const Color(0xFF9ca3af),
                size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive
                    ? const Color(0xFF10b981)
                    : const Color(0xFF9ca3af),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HOME SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    _buildFeatureGrid(),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFF10b981),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
                child: Text('B',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700))),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hello Biraj, 👋',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF064e3b))),
        SizedBox(height: 4),
        Text('Welcome back to Winggle',
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
        border: Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.12)),
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

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      // Make cards more compact and less tall (target ~3/4 height)
      childAspectRatio: 1.8,
      children: [
        _buildFeatureCard('Campus Corner', '24 ACTIVE', Icons.location_on,
            const Color(0xFF10b981)),
        _buildFeatureCard('Alumni Section', '1.2K MEMBERS', Icons.people,
            const Color(0xFF34d399)),
        _buildFeatureCard('Resource Library', '500+ ITEMS', Icons.library_books,
            const Color(0xFF14b8a6)),
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
            border:
                Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.08)),
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
}

// LOOP SCREEN (Stories-like / Knowledge Drops / Channels)
class LoopScreen extends StatelessWidget {
  const LoopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      {'name': 'Your Story', 'initial': '+', 'color': const Color(0xFF10b981)},
      {'name': 'Stuet Don', 'initial': 'S', 'color': const Color(0xFF10b981)},
      {'name': 'John', 'initial': 'J', 'color': const Color(0xFF10b981)},
      {'name': 'Emily', 'initial': 'E', 'color': const Color(0xFF10b981)},
      {'name': 'Clubs', 'initial': 'C', 'color': const Color(0xFF10b981)},
    ];

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header for Loop (similar style to Home header)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))),
                child: Row(children: [
                  const Text('Loop',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10b981))),
                  const Spacer(),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12)),
                      child:
                          const Icon(Icons.search, color: Color(0xFF059669))),
                  const SizedBox(width: 8),
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
                                  fontWeight: FontWeight.w700)))),
                ]),
              ),

              // Stories row as long rounded rectangles (status strips)
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final s = stories[index];
                    return Container(
                      width: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF10b981).withValues(alpha: 0.12)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 22,
                              backgroundColor: s['color'] as Color,
                              child: Text(s['initial'] as String,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(s['name'] as String,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF064e3b)),
                                  overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 6),
                          Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF10b981),
                                  shape: BoxShape.circle)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// CHAT SCREEN
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Messages',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF064e3b))),
                ],
              ),
            ),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildChatList(false), _buildChatList(true)],
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen())),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFF10b981),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
                child: Text('B',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700))),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.2)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF6b7280)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: const Color(0xFF10b981),
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.filter_list, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
            color: const Color(0xFF10b981),
            borderRadius: BorderRadius.circular(16)),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6b7280),
        tabs: const [
          Tab(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(Icons.people, size: 18),
                SizedBox(width: 8),
                Text('Interact')
              ])),
          Tab(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(Icons.school, size: 18),
                SizedBox(width: 8),
                Text('Nexus')
              ])),
        ],
      ),
    );
  }

  Widget _buildChatList(bool isMentor) {
    final chats = isMentor
        ? [
            {
              'name': 'Dr. James Wilson',
              'message': 'I\'ve reviewed your project...',
              'time': '10m ago',
              'unread': 2
            },
            {
              'name': 'Prof. Sarah Johnson',
              'message': 'Let\'s schedule a mentoring session',
              'time': '1h ago',
              'unread': 0
            },
            {
              'name': 'Dr. Maria Garcia',
              'message': 'Great work on your research! 🎓',
              'time': '4h ago',
              'unread': 0
            },
          ]
        : [
            {
              'name': 'Sarah Smith',
              'message': 'Hey! Did you complete the assignment?',
              'time': '2m ago',
              'unread': 3
            },
            {
              'name': 'John Doe',
              'message': 'Can we study together tomorrow?',
              'time': '15m ago',
              'unread': 0
            },
            {
              'name': 'Emily Chen',
              'message': 'Thanks for the notes! 📚',
              'time': '1h ago',
              'unread': 0
            },
            {
              'name': 'Michael Brown',
              'message': 'See you at the campus corner!',
              'time': '2h ago',
              'unread': 1
            },
          ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF10b981),
                    child: Text(chat['name'].toString()[0],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                  ),
                  if (isMentor)
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFFfbbf24), Color(0xFFf59e0b)]),
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(Icons.school,
                            color: Colors.white, size: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(chat['name'].toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF064e3b)))),
                        Text(chat['time'].toString(),
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF6b7280))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(chat['message'].toString(),
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6b7280)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if ((chat['unread'] as int) > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFF10b981),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('${chat['unread']}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        );
      },
    );
  }
}

// NOTIFICATIONS SCREEN
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF064e3b))),
                  ],
                ),
              ),
              _buildTabGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back, color: Color(0xFF059669)),
            ),
          ),
          const SizedBox(width: 10),
          const Text('Winggle',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10b981))),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFF10b981),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
                child: Text('B',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700))),
          ),
        ],
      ),
    );
  }

  Widget _buildTabGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.5,
        children: [
          _buildTab(0, Icons.school, 'Academic', 5),
          _buildTab(1, Icons.emoji_events, 'Competitive', 3),
          _buildTab(2, Icons.work, 'Job', 4),
          _buildTab(3, Icons.notifications, 'App', 6),
        ],
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label, int count) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        // Tab switching without showing any toast messages
        setState(() => _selectedTab = index);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF10b981)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isActive
                  ? const Color(0xFF10b981)
                  : const Color(0xFF10b981).withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: isActive ? Colors.white : const Color(0xFF6b7280),
                    size: 20),
                const SizedBox(height: 4),
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                            isActive ? Colors.white : const Color(0xFF6b7280))),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.9)
                      : const Color(0xFFef4444).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text('$count',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color:
                            isActive ? const Color(0xFF10b981) : Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

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
                // Header
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
                          color: Color(0xFF10b981),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(Icons.notifications_outlined,
                                  color: Color(0xFF059669)),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10b981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('B',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Welcome
                const Text(
                  'Hello Biraj, 👋',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF064e3b)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Welcome back to Winggle',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6b7280)),
                ),
                const SizedBox(height: 20),

                // Stats
                Row(
                  children: [
                    Expanded(
                        child:
                            _buildStatCard('2.5k+', 'Students', Icons.people)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildStatCard('12', 'Events', Icons.event)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('45', 'Jobs', Icons.work)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildStatCard('18', 'Clubs', Icons.groups)),
                  ],
                ),
                const SizedBox(height: 24),

                // Section Title
                const Text(
                  'Explore Features',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF064e3b)),
                ),
                const SizedBox(height: 16),

                // Feature Cards
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Home', true),
                _buildNavItem(Icons.bookmark_border, 'Feed', false),
                _buildNavItem(Icons.all_inclusive, 'Loop', false),
                _buildNavItem(Icons.chat_bubble_outline, 'Chat', false),
                _buildNavItem(Icons.person_outline, 'Profile', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
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
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      String title, String badge, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(badge,
                    style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF064e3b))),
          const Spacer(),
          Row(
            children: [
              Text('Explore',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: color)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 14, color: color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: isActive ? const Color(0xFF10b981) : const Color(0xFF9ca3af),
            size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFF10b981) : const Color(0xFF9ca3af),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// PROFILE SCREEN
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
          GestureDetector(
            onTap: () {
              // Settings menu
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings,
                            color: Color(0xFF10b981)),
                        title: const Text('Settings'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.share, color: Color(0xFF10b981)),
                        title: const Text('Share Profile'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Logout'),
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
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
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
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
                        offset: const Offset(0, 5)),
                  ],
                ),
                child: const Center(
                  child: Text('B',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child:
                      const Icon(Icons.verified, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Biraj Kumar',
              style: TextStyle(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Color(0xFF10b981)),
                    SizedBox(width: 4),
                    Text('Barpeta, Assam',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF10b981),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.school, size: 14, color: Color(0xFF10b981)),
                    SizedBox(width: 4),
                    Text('Final Year',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF10b981),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Looking for collaborations and networking opportunities. Connect with me!',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 13, color: Color(0xFF6b7280), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Social Links',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF064e3b))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // LinkedIn: white 'in' on LinkedIn blue circular badge
              _buildSocialBadge(
                icon: FontAwesomeIcons.linkedinIn,
                background: const Color(0xFF0A66C2),
              ),
              // Instagram: gradient badge with white glyph
              _buildSocialBadge(
                icon: FontAwesomeIcons.instagram,
                gradient: const LinearGradient(colors: [
                  Color(0xFFF58529),
                  Color(0xFFDD2A7B),
                  Color(0xFF8134AF),
                  Color(0xFF515BD4)
                ]),
              ),
              // X: white 'x' on dark badge
              _buildSocialBadge(
                icon: FontAwesomeIcons.x,
                background: Colors.black,
              ),
              // Gmail: white envelope on Gmail red
              _buildSocialBadge(
                icon: FontAwesomeIcons.envelope,
                background: const Color(0xFFEA4335),
              ),
              // Facebook: white 'f' on Facebook blue
              _buildSocialBadge(
                icon: FontAwesomeIcons.facebookF,
                background: const Color(0xFF1877F2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('05 Active social links',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6b7280),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF10b981),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('About',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo, color: Color(0xFF6b7280), size: 18),
                  SizedBox(width: 8),
                  Text('Photos',
                      style: TextStyle(
                          color: Color(0xFF6b7280),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
              Icons.work, 'Student at Engineering College', '2024-2028'),
          const SizedBox(height: 16),
          _buildInfoRow(
              Icons.school, 'B.Tech in Computer Science', 'Expected 2028'),
          const SizedBox(height: 16),
          _buildInfoRow(
              Icons.visibility, '655 content views', '352 this month'),
          const SizedBox(height: 16),
          _buildInfoRow(
              Icons.calendar_today, 'Joined July 2025', 'Member since'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF10b981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF10b981), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF064e3b))),
              const SizedBox(height: 2),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentConnections() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildConnectionItem(
      String name, String location, String initial, Color color) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(initial,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF064e3b))),
              const SizedBox(height: 2),
              Text(location,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF10b981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              const Icon(Icons.more_horiz, color: Color(0xFF10b981), size: 20),
        ),
      ],
    );
  }
}
