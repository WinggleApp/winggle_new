import 'package:flutter/material.dart';
import 'notifications_screen.dart';
import '../widgets/user_avatar.dart';

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
          const UserAvatar(),
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
                border: Border.all(
                    color: const Color(0xFF10b981).withValues(alpha: 0.2)),
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
            border: Border.all(
                color: const Color(0xFF10b981).withValues(alpha: 0.15)),
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
