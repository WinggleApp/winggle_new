import 'package:flutter/material.dart';
import 'department_details_screen.dart';
import '../utils/app_colors.dart';

class ResourceLibraryScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const ResourceLibraryScreen({super.key, this.onBackPressed});

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
    final c = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => widget.onBackPressed != null ? widget.onBackPressed!() : Navigator.pop(context),
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
                style: TextStyle(color: c.primaryText, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search degrees...',
                  hintStyle: TextStyle(color: c.mutedText, fontSize: 14),
                  filled: true,
                  fillColor: c.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1DB954), width: 2),
                  ),
                  prefixIcon: Icon(Icons.search, color: c.mutedText, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Select Your Degree Title
              Text(
                'Select Your Degree',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: c.primaryText,
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
    final c = AppColors.of(context);
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
              color: isActive ? const Color(0xFF1DB954) : c.secondaryText,
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
              color: c.border,
            ),
        ],
      ),
    );
  }

  Widget _buildDegreeCard(Map<String, dynamic> degree) {
    final c = AppColors.of(context);
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
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: c.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    degree['subtitle'],
                    style: TextStyle(
                      fontSize: 11,
                      color: c.secondaryText,
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
                        style: TextStyle(
                          fontSize: 11,
                          color: c.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: c.mutedText,
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
