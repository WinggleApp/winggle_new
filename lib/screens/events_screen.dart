import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// Event Model
class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final String image;
  final String dateTime;
  final String location;
  final String college;
  final List<String> sponsors;
  final int registeredCount;
  final int spotsLeft;
  final String priceOrStatus;
  final bool isPromoted;
  final bool isOpenToAll;
  final String actionButtonLabel;
  bool isSaved;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.dateTime,
    required this.location,
    required this.college,
    required this.sponsors,
    required this.registeredCount,
    required this.spotsLeft,
    required this.priceOrStatus,
    required this.isPromoted,
    required this.isOpenToAll,
    required this.actionButtonLabel,
    this.isSaved = false,
  });
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Technical', 'Cultural', 'Business', 'Sports', 'Workshop'];

  final List<Event> _events = [
    Event(
      id: '1',
      title: 'TechFest 2024',
      description: 'Annual technical festival featuring coding competitions, hackathons, robotics challenges, and tech talks from industry leaders.',
      category: 'Technical',
      image: 'https://via.placeholder.com/400x250/4f46e5/ffffff?text=TechFest+2024',
      dateTime: 'Mar 15-17, 2024 • 9:00 AM onwards',
      location: 'Main Campus Auditorium',
      college: 'Engineering College, Barpeta',
      sponsors: ['TechCorp', 'InnovateLabs'],
      registeredCount: 455,
      spotsLeft: 45,
      priceOrStatus: 'FREE',
      isPromoted: true,
      isOpenToAll: true,
      actionButtonLabel: 'Register Now',
    ),
    Event(
      id: '2',
      title: 'Cultural Night Gala',
      description: 'A spectacular evening of music, dance, and cultural performances. Special guest performances and prize distributions.',
      category: 'Cultural',
      image: 'https://via.placeholder.com/400x250/ec4899/ffffff?text=Cultural+Night',
      dateTime: 'Mar 22, 2024 • 6:00 PM',
      location: 'Open Air Theatre',
      college: 'Cotton University',
      sponsors: ['EventPro'],
      registeredCount: 180,
      spotsLeft: 120,
      priceOrStatus: '₹199',
      isPromoted: true,
      isOpenToAll: true,
      actionButtonLabel: 'Buy Ticket',
    ),
    Event(
      id: '3',
      title: 'Business Summit 2024',
      description: 'An exceptional conference bringing together industry leaders, entrepreneurs, and business enthusiasts for networking and insights.',
      category: 'Business',
      image: 'https://via.placeholder.com/400x250/f97316/ffffff?text=Business+Summit',
      dateTime: 'Mar 25, 2024 • 10:00 AM',
      location: 'Convention Center',
      college: 'Commerce College, Delhi',
      sponsors: ['BizHub', 'StartupX'],
      registeredCount: 220,
      spotsLeft: 30,
      priceOrStatus: '₹299',
      isPromoted: false,
      isOpenToAll: true,
      actionButtonLabel: 'Register Now',
    ),
    Event(
      id: '4',
      title: 'Sports Championship 2024',
      description: 'Inter-college sports championship featuring multiple games and competitions. Come cheer for your college!',
      category: 'Sports',
      image: 'https://via.placeholder.com/400x250/06b6d4/ffffff?text=Sports+Championship',
      dateTime: 'Mar 28-30, 2024 • 8:00 AM onwards',
      location: 'Central Sports Complex',
      college: 'All Colleges',
      sponsors: ['SportZone'],
      registeredCount: 500,
      spotsLeft: 0,
      priceOrStatus: 'FREE',
      isPromoted: false,
      isOpenToAll: true,
      actionButtonLabel: 'Register Now',
    ),
  ];

  List<Event> get _filteredEvents {
    if (_selectedCategory == 'All') {
      return _events;
    }
    return _events.where((event) => event.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0f172a),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPromoteSection(),
                    const SizedBox(height: 24),
                    _buildCategoryFilter(),
                    const SizedBox(height: 24),
                    _buildFeaturedSection(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _filteredEvents.map((event) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildEventCard(event),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
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
        border: Border(bottom: BorderSide(color: const Color(0xFF1f2937), width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Events ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10b981),
                  decoration: TextDecoration.none,
                ),
              ),
              
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFB923C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'Host Event',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoteSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5a4a2a),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFB923C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.trending_up, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Promote Your Event',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Reach 10,000+ students across colleges',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFd1d5db),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFB923C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Boost',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFB923C) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF9ca3af),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFFB923C), size: 20),
              SizedBox(width: 8),
              Text(
                'FEATURED & PROMOTED',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFB923C),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_events.isNotEmpty) _buildEventCard(_events[0]),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: NetworkImage(event.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Badges
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: [
                    if (event.isPromoted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB923C),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PROMOTED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (event.isOpenToAll)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14b8a6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'OPEN TO ALL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Price Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: event.priceOrStatus == 'FREE'
                        ? const Color(0xFF10b981)
                        : const Color(0xFFFB923C),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    event.priceOrStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  event.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14b8a6),
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 6),
                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9ca3af),
                    height: 1.5,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 12),
                // Date and Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFFFB923C)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.dateTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9ca3af),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Color(0xFF14b8a6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9ca3af),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // College
                Row(
                  children: [
                    const Icon(Icons.school, size: 14, color: Color(0xFFec4899)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.college,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9ca3af),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sponsors
                Wrap(
                  spacing: 8,
                  children: [
                    const Text(
                      'SPONSORED BY',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6b7280),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    ...event.sponsors.map((sponsor) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF374151),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        sponsor,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFF5F5F5),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                // Registration Info
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1f2937),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.group, size: 14, color: Color(0xFF10b981)),
                          const SizedBox(width: 6),
                          Text(
                            '${event.registeredCount} registered',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${event.spotsLeft} spots left',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFB923C),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: event.spotsLeft > 0 ? (event.registeredCount / (event.registeredCount + event.spotsLeft)) : 1.0,
                          backgroundColor: const Color(0xFF374151),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            event.spotsLeft > 0 ? const Color(0xFFFB923C) : const Color(0xFF10b981),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB923C),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            event.actionButtonLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1f2937),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Share.share(
                            'Check out this event: ${event.title}\n${event.description}',
                          );
                        },
                        child: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1f2937),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            event.isSaved = !event.isSaved;
                          });
                        },
                        child: Icon(
                          event.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: event.isSaved ? const Color(0xFFFB923C) : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
