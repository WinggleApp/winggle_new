import 'package:flutter/material.dart';
import 'department_details_screen.dart';

class ResourceLibraryScreen extends StatefulWidget {
  const ResourceLibraryScreen({super.key});

  @override
  State<ResourceLibraryScreen> createState() => _ResourceLibraryScreenState();
}

class _ResourceLibraryScreenState extends State<ResourceLibraryScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> degrees = [
    {
      'name': 'B.Tech',
      'subtitle': 'Bachelor of Technology',
      'departments': 5,
      'resources': 959,
      'color': const Color(0xFF0084D4),
      'icon': Icons.school,
    },
    {
      'name': 'Diploma',
      'subtitle': 'Diploma in Engineering',
      'departments': 6,
      'resources': 405,
      'color': const Color(0xFFFFA500),
      'icon': Icons.description,
    },
    {
      'name': 'BA',
      'subtitle': 'Bachelor of Arts',
      'departments': 8,
      'resources': 644,
      'color': const Color(0xFF9C27B0),
      'icon': Icons.library_books,
    },
    {
      'name': 'B.Com',
      'subtitle': 'Bachelor of Commerce',
      'departments': 7,
      'resources': 586,
      'color': const Color(0xFF1DB954),
      'icon': Icons.attach_money,
    },
    {
      'name': 'BCA',
      'subtitle': 'Bachelor of Computer Applications',
      'departments': 8,
      'resources': 817,
      'color': const Color(0xFF00BCD4),
      'icon': Icons.computer,
    },
    {
      'name': 'BBA',
      'subtitle': 'Bachelor of Business Administration',
      'departments': 6,
      'resources': 423,
      'color': const Color(0xFFE91E63),
      'icon': Icons.business_center,
    },
    {
      'name': 'B.Sc',
      'subtitle': 'Bachelor of Science',
      'departments': 7,
      'resources': 604,
      'color': const Color(0xFF663399),
      'icon': Icons.science,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Color(0xFF1DB954), size: 24),
        ),
        title: const Text(
          'Resource Library',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1DB954),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs
              Row(
                children: [
                  _buildTab('Academic', 0),
                  const SizedBox(width: 32),
                  _buildTab('Competitive', 1),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Color(0xFFF0F0F0), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search degrees...',
                  hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1DB954), width: 2),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF555555), size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Select Your Degree Title
              const Text(
                'Select Your Degree',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF0F0F0),
                ),
              ),
              const SizedBox(height: 16),

              // Degrees List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: degrees.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final degree = degrees[index];
                  return _buildDegreeCard(degree);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isActive ? const Color(0xFF1DB954) : const Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 8),
          if (isActive)
            Container(
              height: 3,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          if (!isActive)
            Container(
              height: 1,
              width: 100,
              color: const Color(0xFF1E1E1E),
            ),
        ],
      ),
    );
  }

  Widget _buildDegreeCard(Map<String, dynamic> degree) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DepartmentDetailsScreen(
              degreeName: degree['name'],
              degreeSubtitle: degree['subtitle'],
              color: degree['color'],
              icon: degree['icon'],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1E1E)),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: degree['color'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                degree['icon'],
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    degree['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF0F0F0),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    degree['subtitle'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${degree['departments']} Departments',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1DB954),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${degree['resources']}+ resources',
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

            // Chevron
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF555555),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
