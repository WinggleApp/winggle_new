import 'package:flutter/material.dart';

class SemesterSubjectsScreen extends StatelessWidget {
  final String departmentName;
  final String departmentShort;
  final Color departmentColor;
  final int semester;
  final int year;

  const SemesterSubjectsScreen({
    super.key,
    required this.departmentName,
    required this.departmentShort,
    required this.departmentColor,
    required this.semester,
    required this.year,
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
              'Semester $semester',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b),
              ),
            ),
            Text(
              '$departmentShort - Year $year',
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf0fdf4), Color(0xFFecfdf5), Colors.white],
          ),
        ),
        child: Column(
          children: [
            _buildSemesterHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...(_getSubjects(semester).map((subject) => _buildSubjectCard(subject))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterHeader() {
    final subjects = _getSubjects(semester);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: departmentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: departmentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderStat(subjects.length.toString(), 'Subjects', Icons.book),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildHeaderStat('${subjects.length * 4}', 'Credits', Icons.star),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildHeaderStat('${subjects.length * 15}+', 'Resources', Icons.description),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: departmentColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF064e3b),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            // TODO: Navigate to subject materials
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: departmentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        subject['icon'] as IconData,
                        color: departmentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject['name'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF064e3b),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subject['code'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: departmentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${subject['credits']} Credits',
                        style: TextStyle(
                          fontSize: 11,
                          color: departmentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(Icons.description, '${subject['resources']} Resources', Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.video_library, '${subject['videos']} Videos', Colors.purple),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.quiz, '${subject['tests']} Tests', Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getSubjects(int semester) {
    // Sample subjects for Computer Science - customize based on department and semester
    final cseSubjects = {
      1: [
        {'name': 'Engineering Mathematics I', 'code': 'MAT101', 'credits': 4, 'resources': 25, 'videos': 12, 'tests': 5, 'icon': Icons.calculate},
        {'name': 'Engineering Physics', 'code': 'PHY101', 'credits': 4, 'resources': 20, 'videos': 10, 'tests': 4, 'icon': Icons.science},
        {'name': 'Engineering Chemistry', 'code': 'CHE101', 'credits': 4, 'resources': 18, 'videos': 8, 'tests': 4, 'icon': Icons.biotech},
        {'name': 'Engineering Graphics', 'code': 'MEG101', 'credits': 3, 'resources': 15, 'videos': 6, 'tests': 3, 'icon': Icons.architecture},
        {'name': 'Basic Electrical Engineering', 'code': 'EEE101', 'credits': 3, 'resources': 16, 'videos': 7, 'tests': 3, 'icon': Icons.electrical_services},
        {'name': 'Programming in C', 'code': 'CSE101', 'credits': 4, 'resources': 30, 'videos': 15, 'tests': 6, 'icon': Icons.code},
      ],
      2: [
        {'name': 'Engineering Mathematics II', 'code': 'MAT102', 'credits': 4, 'resources': 22, 'videos': 11, 'tests': 5, 'icon': Icons.calculate},
        {'name': 'Data Structures', 'code': 'CSE102', 'credits': 4, 'resources': 35, 'videos': 18, 'tests': 7, 'icon': Icons.storage},
        {'name': 'Digital Electronics', 'code': 'ECE102', 'credits': 4, 'resources': 20, 'videos': 10, 'tests': 5, 'icon': Icons.memory},
        {'name': 'Object Oriented Programming', 'code': 'CSE103', 'credits': 4, 'resources': 28, 'videos': 14, 'tests': 6, 'icon': Icons.class_},
        {'name': 'Environmental Science', 'code': 'EVS101', 'credits': 2, 'resources': 12, 'videos': 5, 'tests': 2, 'icon': Icons.eco},
        {'name': 'Communication Skills', 'code': 'ENG101', 'credits': 2, 'resources': 10, 'videos': 4, 'tests': 2, 'icon': Icons.chat},
      ],
      3: [
        {'name': 'Discrete Mathematics', 'code': 'MAT201', 'credits': 4, 'resources': 24, 'videos': 12, 'tests': 5, 'icon': Icons.calculate},
        {'name': 'Computer Organization', 'code': 'CSE201', 'credits': 4, 'resources': 26, 'videos': 13, 'tests': 5, 'icon': Icons.computer},
        {'name': 'Database Management Systems', 'code': 'CSE202', 'credits': 4, 'resources': 32, 'videos': 16, 'tests': 7, 'icon': Icons.storage},
        {'name': 'Operating Systems', 'code': 'CSE203', 'credits': 4, 'resources': 30, 'videos': 15, 'tests': 6, 'icon': Icons.settings},
        {'name': 'Theory of Computation', 'code': 'CSE204', 'credits': 3, 'resources': 20, 'videos': 10, 'tests': 4, 'icon': Icons.auto_graph},
        {'name': 'Software Engineering', 'code': 'CSE205', 'credits': 3, 'resources': 22, 'videos': 11, 'tests': 4, 'icon': Icons.engineering},
        {'name': 'Probability & Statistics', 'code': 'MAT202', 'credits': 3, 'resources': 18, 'videos': 9, 'tests': 4, 'icon': Icons.analytics},
      ],
      4: [
        {'name': 'Design & Analysis of Algorithms', 'code': 'CSE301', 'credits': 4, 'resources': 28, 'videos': 14, 'tests': 6, 'icon': Icons.account_tree},
        {'name': 'Computer Networks', 'code': 'CSE302', 'credits': 4, 'resources': 30, 'videos': 15, 'tests': 6, 'icon': Icons.network_check},
        {'name': 'Microprocessors', 'code': 'ECE201', 'credits': 4, 'resources': 22, 'videos': 11, 'tests': 5, 'icon': Icons.memory},
        {'name': 'Web Technologies', 'code': 'CSE303', 'credits': 3, 'resources': 26, 'videos': 13, 'tests': 5, 'icon': Icons.web},
        {'name': 'Compiler Design', 'code': 'CSE304', 'credits': 4, 'resources': 24, 'videos': 12, 'tests': 5, 'icon': Icons.build},
        {'name': 'Unix Programming', 'code': 'CSE305', 'credits': 3, 'resources': 18, 'videos': 9, 'tests': 4, 'icon': Icons.terminal},
        {'name': 'Professional Ethics', 'code': 'HUM201', 'credits': 2, 'resources': 10, 'videos': 5, 'tests': 2, 'icon': Icons.balance},
      ],
      5: [
        {'name': 'Machine Learning', 'code': 'CSE401', 'credits': 4, 'resources': 35, 'videos': 18, 'tests': 7, 'icon': Icons.psychology},
        {'name': 'Artificial Intelligence', 'code': 'CSE402', 'credits': 4, 'resources': 32, 'videos': 16, 'tests': 6, 'icon': Icons.smart_toy},
        {'name': 'Cloud Computing', 'code': 'CSE403', 'credits': 3, 'resources': 25, 'videos': 12, 'tests': 5, 'icon': Icons.cloud},
        {'name': 'Information Security', 'code': 'CSE404', 'credits': 4, 'resources': 28, 'videos': 14, 'tests': 6, 'icon': Icons.security},
        {'name': 'Mobile Application Development', 'code': 'CSE405', 'credits': 3, 'resources': 30, 'videos': 15, 'tests': 5, 'icon': Icons.phone_android},
        {'name': 'Elective I', 'code': 'CSE4E1', 'credits': 3, 'resources': 20, 'videos': 10, 'tests': 4, 'icon': Icons.school},
      ],
      6: [
        {'name': 'Big Data Analytics', 'code': 'CSE501', 'credits': 4, 'resources': 30, 'videos': 15, 'tests': 6, 'icon': Icons.bar_chart},
        {'name': 'Internet of Things', 'code': 'CSE502', 'credits': 3, 'resources': 26, 'videos': 13, 'tests': 5, 'icon': Icons.wifi},
        {'name': 'Blockchain Technology', 'code': 'CSE503', 'credits': 3, 'resources': 22, 'videos': 11, 'tests': 4, 'icon': Icons.link},
        {'name': 'Software Testing', 'code': 'CSE504', 'credits': 3, 'resources': 20, 'videos': 10, 'tests': 4, 'icon': Icons.bug_report},
        {'name': 'Elective II', 'code': 'CSE5E2', 'credits': 3, 'resources': 18, 'videos': 9, 'tests': 4, 'icon': Icons.school},
        {'name': 'Mini Project', 'code': 'CSE505', 'credits': 4, 'resources': 15, 'videos': 8, 'tests': 2, 'icon': Icons.assignment},
      ],
      7: [
        {'name': 'Distributed Systems', 'code': 'CSE601', 'credits': 4, 'resources': 24, 'videos': 12, 'tests': 5, 'icon': Icons.hub},
        {'name': 'Human Computer Interaction', 'code': 'CSE602', 'credits': 3, 'resources': 20, 'videos': 10, 'tests': 4, 'icon': Icons.touch_app},
        {'name': 'Elective III', 'code': 'CSE6E3', 'credits': 3, 'resources': 18, 'videos': 9, 'tests': 4, 'icon': Icons.school},
        {'name': 'Elective IV', 'code': 'CSE6E4', 'credits': 3, 'resources': 18, 'videos': 9, 'tests': 4, 'icon': Icons.school},
        {'name': 'Major Project Phase I', 'code': 'CSE603', 'credits': 6, 'resources': 20, 'videos': 10, 'tests': 2, 'icon': Icons.work},
      ],
      8: [
        {'name': 'Entrepreneurship Development', 'code': 'MGT601', 'credits': 2, 'resources': 12, 'videos': 6, 'tests': 2, 'icon': Icons.business},
        {'name': 'Industry Seminar', 'code': 'CSE701', 'credits': 2, 'resources': 10, 'videos': 5, 'tests': 1, 'icon': Icons.record_voice_over},
        {'name': 'Major Project Phase II', 'code': 'CSE702', 'credits': 10, 'resources': 25, 'videos': 12, 'tests': 2, 'icon': Icons.assignment_turned_in},
        {'name': 'Comprehensive Viva', 'code': 'CSE703', 'credits': 2, 'resources': 8, 'videos': 4, 'tests': 1, 'icon': Icons.record_voice_over},
        {'name': 'Technical Paper Writing', 'code': 'CSE704', 'credits': 2, 'resources': 10, 'videos': 5, 'tests': 1, 'icon': Icons.description},
      ],
    };

    return cseSubjects[semester] ?? [];
  }
}
