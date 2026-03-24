import 'package:flutter/material.dart';
import 'subject_screen.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1DB954),
            size: 24,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              departmentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1DB954),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Select Semester',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF888888),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.9,
          ),
          itemCount: semesters.length,
          itemBuilder: (context, index) {
            final semester = semesters[index];
            return _buildSemesterCard(
              context,
              semester['sem'],
              semester['label'],
              semester['year'],
              semester['subjects'],
            );
          },
        ),
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
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Semester number circle
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '$semesterNum',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Semester label and year
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Year $year',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF888888),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),

            // Subject count in green
            Text(
              '$subjects Subjects',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
