import 'package:flutter/material.dart';
import 'semester_screen.dart';

class DepartmentDetailsScreen extends StatelessWidget {
  final String degreeName;
  final String degreeSubtitle;
  final Color color;
  final IconData icon;

  const DepartmentDetailsScreen({
    super.key,
    required this.degreeName,
    required this.degreeSubtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final departments = _getDefaultDepartments();

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
        title: Text(
          '$degreeName Departments',
          style: const TextStyle(
            fontSize: 20,
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
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E1E1E)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                degreeName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFF0F0F0),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Choose your department',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('🏢', '5', 'Departments'),
                        _buildStatColumn('📚', '52', 'Total Subjects'),
                        _buildStatColumn('📖', '640+', 'Resources'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Departments List
              Column(
                children: List.generate(
                  departments.length,
                  (index) => Column(
                    children: [
                      _buildDepartmentCard(context, departments[index]),
                      if (index < departments.length - 1)
                        const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDefaultDepartments() {
    return [
      {
        'name': 'Computer Science',
        'abbreviation': 'CSE',
        'icon': Icons.computer,
        'color': const Color(0xFF1DB954),
        'subjects': 12,
        'resources': 150,
        'details': 'AI, ML, DSA, Web Dev, DBMS, OS, Networks, Cloud Computing, Cyber Security',
      },
      {
        'name': 'Electrical Engineering',
        'abbreviation': 'EE',
        'icon': Icons.bolt,
        'color': const Color(0xFFFFA500),
        'subjects': 10,
        'resources': 120,
        'details': 'Power Systems, Electrical Machines, Control Systems, Power Electronics, Signals',
      },
      {
        'name': 'Electronics & Telecom',
        'abbreviation': 'ECE',
        'icon': Icons.settings_remote,
        'color': const Color(0xFF0084D4),
        'subjects': 11,
        'resources': 135,
        'details':
            'Digital Electronics, Communication Systems, Microprocessors, VLSI, Signal Processing',
      },
      {
        'name': 'Mechanical Engineering',
        'abbreviation': 'ME',
        'icon': Icons.precision_manufacturing,
        'color': const Color(0xFF9C27B0),
        'subjects': 10,
        'resources': 125,
        'details': 'Thermodynamics, Fluid Mechanics, Manufacturing, Machine Design, CAD/CAM',
      },
      {
        'name': 'Civil Engineering',
        'abbreviation': 'CE',
        'icon': Icons.apartment,
        'color': const Color(0xFFE91E63),
        'subjects': 9,
        'resources': 110,
        'details': 'Structural Analysis, Geotechnical Engineering, Transportation, Water Resources',
      },
    ];
  }

  Widget _buildStatColumn(String emoji, String value, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFFF0F0F0),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF888888),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDepartmentCard(BuildContext context, Map<String, dynamic> dept) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SemesterScreen(
              departmentName: dept['name'],
              departmentAbbr: dept['abbreviation'],
              color: dept['color'],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: dept['color'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        dept['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                      if (dept['abbreviation'].length <= 3)
                        Positioned(
                          bottom: 4,
                          child: Text(
                            dept['abbreviation'],
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dept['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF0F0F0),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: dept['color'].withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.book,
                                  size: 10,
                                  color: dept['color'],
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${dept['subjects']} Subjects',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: dept['color'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: dept['color'].withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.library_books,
                                  size: 10,
                                  color: dept['color'],
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${dept['resources']}+ Resources',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: dept['color'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF555555),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 12,
                    color: const Color(0xFF888888),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      dept['details'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF888888),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
