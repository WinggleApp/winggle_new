import 'package:flutter/material.dart';
import 'subject_screen.dart';
import '../utils/app_colors.dart';

class SemesterScreen extends StatelessWidget {
  final String departmentName;
  final String departmentAbbr;
  final Color color;

  const SemesterScreen({
    Key? key,
    required this.departmentName,
    required this.departmentAbbr,
    required this.color,
  }) : super(key: key);

  // Get semester data based on department
  List<Map<String, dynamic>> getSemesterData() {
    switch (departmentAbbr.toUpperCase()) {
      case 'CSE': // Computer Science
        return [
          {'sem': 1, 'year': 1, 'label': 'Semester 1', 'subjects': 6},
          {'sem': 2, 'year': 1, 'label': 'Semester 2', 'subjects': 6},
          {'sem': 3, 'year': 2, 'label': 'Semester 3', 'subjects': 7},
          {'sem': 4, 'year': 2, 'label': 'Semester 4', 'subjects': 7},
          {'sem': 5, 'year': 3, 'label': 'Semester 5', 'subjects': 6},
          {'sem': 6, 'year': 3, 'label': 'Semester 6', 'subjects': 6},
          {'sem': 7, 'year': 4, 'label': 'Semester 7', 'subjects': 5},
          {'sem': 8, 'year': 4, 'label': 'Semester 8', 'subjects': 5},
        ];
      case 'EE': // Electrical Engineering
        return [
          {'sem': 1, 'year': 1, 'label': 'Semester 1', 'subjects': 6},
          {'sem': 2, 'year': 1, 'label': 'Semester 2', 'subjects': 6},
          {'sem': 3, 'year': 2, 'label': 'Semester 3', 'subjects': 6},
          {'sem': 4, 'year': 2, 'label': 'Semester 4', 'subjects': 6},
          {'sem': 5, 'year': 3, 'label': 'Semester 5', 'subjects': 6},
          {'sem': 6, 'year': 3, 'label': 'Semester 6', 'subjects': 6},
          {'sem': 7, 'year': 4, 'label': 'Semester 7', 'subjects': 5},
          {'sem': 8, 'year': 4, 'label': 'Semester 8', 'subjects': 5},
        ];
      case 'ECE': // Electronics & Telecom
        return [
          {'sem': 1, 'year': 1, 'label': 'Semester 1', 'subjects': 6},
          {'sem': 2, 'year': 1, 'label': 'Semester 2', 'subjects': 6},
          {'sem': 3, 'year': 2, 'label': 'Semester 3', 'subjects': 7},
          {'sem': 4, 'year': 2, 'label': 'Semester 4', 'subjects': 7},
          {'sem': 5, 'year': 3, 'label': 'Semester 5', 'subjects': 6},
          {'sem': 6, 'year': 3, 'label': 'Semester 6', 'subjects': 6},
          {'sem': 7, 'year': 4, 'label': 'Semester 7', 'subjects': 5},
          {'sem': 8, 'year': 4, 'label': 'Semester 8', 'subjects': 5},
        ];
      case 'ME': // Mechanical Engineering
        return [
          {'sem': 1, 'year': 1, 'label': 'Semester 1', 'subjects': 6},
          {'sem': 2, 'year': 1, 'label': 'Semester 2', 'subjects': 6},
          {'sem': 3, 'year': 2, 'label': 'Semester 3', 'subjects': 6},
          {'sem': 4, 'year': 2, 'label': 'Semester 4', 'subjects': 6},
          {'sem': 5, 'year': 3, 'label': 'Semester 5', 'subjects': 6},
          {'sem': 6, 'year': 3, 'label': 'Semester 6', 'subjects': 6},
          {'sem': 7, 'year': 4, 'label': 'Semester 7', 'subjects': 5},
          {'sem': 8, 'year': 4, 'label': 'Semester 8', 'subjects': 5},
        ];
      case 'CE': // Civil Engineering
        return [
          {'sem': 1, 'year': 1, 'label': 'Semester 1', 'subjects': 6},
          {'sem': 2, 'year': 1, 'label': 'Semester 2', 'subjects': 6},
          {'sem': 3, 'year': 2, 'label': 'Semester 3', 'subjects': 6},
          {'sem': 4, 'year': 2, 'label': 'Semester 4', 'subjects': 6},
          {'sem': 5, 'year': 3, 'label': 'Semester 5', 'subjects': 6},
          {'sem': 6, 'year': 3, 'label': 'Semester 6', 'subjects': 6},
          {'sem': 7, 'year': 4, 'label': 'Semester 7', 'subjects': 5},
          {'sem': 8, 'year': 4, 'label': 'Semester 8', 'subjects': 5},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final semesters = getSemesterData();

    // Group semesters by year
    final Map<int, List<Map<String, dynamic>>> byYear = {};
    for (final s in semesters) {
      final y = s['year'] as int;
      byYear.putIfAbsent(y, () => []).add(s);
    }
    final years = byYear.keys.toList()..sort();

    final c = AppColors.of(context);
    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.appBar,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1DB954),
            size: 20,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              departmentName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: c.primaryText,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Select a semester',
              style: TextStyle(
                fontSize: 11,
                color: c.mutedText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: years.length,
        itemBuilder: (context, i) {
          final year = years[i];
          final pair = byYear[year]!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year header
                Text(
                  'YEAR $year',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: c.isDark ? const Color(0xFF444444) : const Color(0xFF999999),
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 10),
                // Two cards in a row
                Row(
                  children: List.generate(pair.length, (j) {
                    final s = pair[j];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: j == 0 ? 0 : 7,
                          right: j == 0 ? 7 : 0,
                        ),
                        child: _buildSemesterCard(
                          context,
                          s['sem'] as int,
                          s['label'] as String,
                          s['year'] as int,
                          s['subjects'] as int,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSemesterCard(
    BuildContext context,
    int semesterNum,
    String label,
    int year,
    int subjects,
  ) {
    final c = AppColors.of(context);
    final numLabel = semesterNum.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectScreen(
              semesterName: label,
              departmentAbbr: departmentAbbr,
              semesterNum: semesterNum,
              yearNum: year,
              color: color,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Green left accent bar
                Container(
                  width: 4,
                  color: const Color(0xFF1DB954),
                ),
                // Card content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          numLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: c.semesterNumText,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: c.primaryText,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$subjects subjects',
                          style: TextStyle(
                            fontSize: 11,
                            color: c.mutedText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
