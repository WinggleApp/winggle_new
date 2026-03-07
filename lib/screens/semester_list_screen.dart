import 'package:flutter/material.dart';
import '../services/semester_service.dart';
import '../models/semester.dart';
import 'semester_detail_screen.dart';

class SemesterListScreen extends StatefulWidget {
  const SemesterListScreen({super.key});

  @override
  State<SemesterListScreen> createState() => _SemesterListScreenState();
}

class _SemesterListScreenState extends State<SemesterListScreen> {
  final SemesterService _semesterService = SemesterService();
  List<Semester> _semesters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSemesters();
  }

  Future<void> _loadSemesters() async {
    try {
      List<Semester> semesters = await _semesterService.getAllSemesters();
      setState(() {
        _semesters = semesters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading semesters: $e')),
      );
    }
  }

  void _navigateToSemesterDetail(Semester semester) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SemesterDetailScreen(semester: semester),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semesters'),
        backgroundColor: const Color(0xFF10b981),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSemesters,
              child: _semesters.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No semesters found'),
                          Text('Database might not be initialized yet'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _semesters.length,
                      itemBuilder: (context, index) {
                        final semester = _semesters[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: semester.isActive
                                  ? const Color(0xFF10b981)
                                  : Colors.grey,
                              child: Text(
                                semester.semesterNumber.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              semester.displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Year: ${semester.academicYear}'),
                                Text('Branch: ${semester.branch}'),
                                Text('Department: ${semester.department}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (semester.isActive)
                                  const Icon(Icons.check_circle, color: Colors.green)
                                else
                                  const Icon(Icons.circle_outlined, color: Colors.grey),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              ],
                            ),
                            onTap: () => _navigateToSemesterDetail(semester),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
