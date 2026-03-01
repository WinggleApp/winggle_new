import 'package:flutter/material.dart';
import 'semester_subjects_screen.dart';

class DepartmentSemestersScreen extends StatelessWidget {
  final String departmentName;
  final String departmentShort;
  final IconData departmentIcon;
  final Color departmentColor;

  const DepartmentSemestersScreen({
    super.key,
    required this.departmentName,
    required this.departmentShort,
    required this.departmentIcon,
    required this.departmentColor,
  });

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              departmentName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b),
              ),
            ),
            Text(
              'Select Semester',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              departmentColor.withOpacity(0.05),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSemesterGrid(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 

  Widget _buildSemesterGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.30,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        final semesterNumber = index + 1;
        final yearNumber = ((index / 2).floor() + 1);
        return _buildSemesterCard(context, semesterNumber, yearNumber);
      },
    );
  }

  Widget _buildSemesterCard(BuildContext context, int semester, int year) {
    // Sample subject counts - you can customize these
    final subjectCounts = [6, 6, 7, 7, 6, 6, 5, 5];
    final subjectCount = subjectCounts[semester - 1];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: departmentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SemesterSubjectsScreen(
                  departmentName: departmentName,
                  departmentShort: departmentShort,
                  departmentColor: departmentColor,
                  semester: semester,
                  year: year,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [departmentColor, departmentColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: departmentColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$semester',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Semester $semester',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF064e3b),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Year $year',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: departmentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$subjectCount Subjects',
                    style: TextStyle(
                      fontSize: 11,
                      color: departmentColor,
                      fontWeight: FontWeight.w600,
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
