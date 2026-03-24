import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/notes_service.dart';

class SubjectScreen extends StatefulWidget {
  final String semesterName;
  final String departmentAbbr;
  final int semesterNum;
  final int yearNum;
  final Color color;

  const SubjectScreen({
    Key? key,
    required this.semesterName,
    required this.departmentAbbr,
    required this.semesterNum,
    required this.yearNum,
    required this.color,
  }) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final NotesService _notesService = NotesService();
  bool _isUploading = false;
  List<Map<String, dynamic>> _uploadedNotes = [];
  String? _selectedSubjectCode;
  String? _selectedSubjectName;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    // Notes will be loaded when user interacts with a subject
  }

  Future<void> _pickAndUploadFile(
      String subjectCode, String subjectName) async {
    try {
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        final File file = File(platformFile.path!);

        // Show loading dialog
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF141414),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Uploading: ${platformFile.name}',
                    style: const TextStyle(
                      color: Color(0xFFF0F0F0),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        );

        setState(() => _isUploading = true);

        // Upload file
        final uploadResult = await _notesService.uploadNote(
          file: file,
          departmentAbbr: widget.departmentAbbr,
          semesterNum: widget.semesterNum,
          subjectCode: subjectCode,
          subjectName: subjectName,
          fileName: platformFile.name,
        );

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        if (uploadResult != null && uploadResult['success']) {
          // Refresh notes list
          await _loadNotesForSubject(subjectCode);

          if (mounted) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF1DB954),
                content: Text(
                  '✓ ${platformFile.name} uploaded successfully!',
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFFFF4757),
                content: Text(
                  uploadResult?['message'] ?? 'Failed to upload file',
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }

        setState(() => _isUploading = false);
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFFF4757),
            content: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _loadNotesForSubject(String subjectCode) async {
    final notes = await _notesService.getNotesForSubject(
      departmentAbbr: widget.departmentAbbr,
      semesterNum: widget.semesterNum,
      subjectCode: subjectCode,
    );
    setState(() {
      _uploadedNotes = notes;
      _selectedSubjectCode = subjectCode;
    });
  }

  // Get subjects based on department and semester
  List<Map<String, dynamic>> getSubjects() {
    switch (widget.departmentAbbr.toUpperCase()) {
      case 'CSE':
        return getCSESubjects(widget.semesterNum);
      case 'EE':
        return getEESubjects(widget.semesterNum);
      case 'ECE':
        return getECESubjects(widget.semesterNum);
      case 'ME':
        return getMESubjects(widget.semesterNum);
      case 'CE':
        return getCESubjects(widget.semesterNum);
      default:
        return [];
    }
  }

  // CSE Subjects
  List<Map<String, dynamic>> getCSESubjects(int sem) {
    final Map<int, List<Map<String, dynamic>>> subjects = {
      1: [
        {'name': 'Mathematics I', 'code': 'MA101', 'credits': 4, 'professor': 'Dr. Smith', 'topics': 5, 'notes': 0},
        {'name': 'Physics I', 'code': 'PH101', 'credits': 3, 'professor': 'Dr. Johnson', 'topics': 4, 'notes': 0},
        {'name': 'Programming Fundamentals', 'code': 'CS101', 'credits': 4, 'professor': 'Dr. Williams', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Chemistry', 'code': 'CH101', 'credits': 3, 'professor': 'Dr. Brown', 'topics': 4, 'notes': 0},
      ],
      2: [
        {'name': 'Mathematics II', 'code': 'MA102', 'credits': 4, 'professor': 'Dr. Davis', 'topics': 5, 'notes': 0},
        {'name': 'Physics II', 'code': 'PH102', 'credits': 3, 'professor': 'Dr. Miller', 'topics': 4, 'notes': 0},
        {'name': 'Data Structures', 'code': 'CS102', 'credits': 4, 'professor': 'Dr. Wilson', 'topics': 6, 'notes': 0},
        {'name': 'Engineering Graphics', 'code': 'EG102', 'credits': 2, 'professor': 'Dr. Moore', 'topics': 3, 'notes': 0},
      ],
      3: [
        {'name': 'Discrete Mathematics', 'code': 'MA201', 'credits': 4, 'professor': 'Dr. Taylor', 'topics': 5, 'notes': 0},
        {'name': 'Database Management Systems', 'code': 'CS201', 'credits': 4, 'professor': 'Dr. Anderson', 'topics': 6, 'notes': 0},
        {'name': 'Operating Systems', 'code': 'CS202', 'credits': 3, 'professor': 'Dr. Thomas', 'topics': 5, 'notes': 0},
        {'name': 'Computer Networks', 'code': 'CS203', 'credits': 3, 'professor': 'Dr. Jackson', 'topics': 5, 'notes': 0},
        {'name': 'Web Technology', 'code': 'CS204', 'credits': 3, 'professor': 'Dr. White', 'topics': 4, 'notes': 0},
        {'name': 'Object Oriented Programming', 'code': 'CS205', 'credits': 3, 'professor': 'Dr. Harris', 'topics': 5, 'notes': 0},
        {'name': 'Software Engineering', 'code': 'CS206', 'credits': 3, 'professor': 'Dr. Martin', 'topics': 4, 'notes': 0},
      ],
      4: [
        {'name': 'Microprocessors & Interfacing', 'code': 'CS301', 'credits': 4, 'professor': 'Dr. Lee', 'topics': 5, 'notes': 0},
        {'name': 'Compiler Design', 'code': 'CS302', 'credits': 4, 'professor': 'Dr. Perez', 'topics': 5, 'notes': 0},
        {'name': 'Database Design', 'code': 'CS303', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Computer Graphics', 'code': 'CS304', 'credits': 3, 'professor': 'Dr. Simmons', 'topics': 4, 'notes': 0},
        {'name': 'Artificial Intelligence', 'code': 'CS305', 'credits': 3, 'professor': 'Dr. Green', 'topics': 5, 'notes': 0},
        {'name': 'Mobile Applications', 'code': 'CS306', 'credits': 3, 'professor': 'Dr. Adams', 'topics': 4, 'notes': 0},
        {'name': 'Network Security', 'code': 'CS307', 'credits': 2, 'professor': 'Dr. Nelson', 'topics': 3, 'notes': 0},
      ],
      5: [
        {'name': 'Machine Learning', 'code': 'CS401', 'credits': 4, 'professor': 'Dr. Carter', 'topics': 6, 'notes': 0},
        {'name': 'Cloud Computing', 'code': 'CS402', 'credits': 4, 'professor': 'Dr. Mitchell', 'topics': 5, 'notes': 0},
        {'name': 'Distributed Systems', 'code': 'CS403', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Big Data Analytics', 'code': 'CS404', 'credits': 3, 'professor': 'Dr. Phillips', 'topics': 4, 'notes': 0},
        {'name': 'Internet of Things', 'code': 'CS405', 'credits': 3, 'professor': 'Dr. Campbell', 'topics': 4, 'notes': 0},
        {'name': 'Cybersecurity', 'code': 'CS406', 'credits': 2, 'professor': 'Dr. Parker', 'topics': 3, 'notes': 0},
      ],
      6: [
        {'name': 'Deep Learning', 'code': 'CS501', 'credits': 4, 'professor': 'Dr. Evans', 'topics': 5, 'notes': 0},
        {'name': 'Edge Computing', 'code': 'CS502', 'credits': 3, 'professor': 'Dr. Edwards', 'topics': 4, 'notes': 0},
        {'name': 'Advanced Algorithms', 'code': 'CS503', 'credits': 3, 'professor': 'Dr. Collins', 'topics': 4, 'notes': 0},
        {'name': 'Quantum Computing', 'code': 'CS504', 'credits': 3, 'professor': 'Dr. Stewart', 'topics': 4, 'notes': 0},
        {'name': 'Natural Language Processing', 'code': 'CS505', 'credits': 3, 'professor': 'Dr. Sanchez', 'topics': 4, 'notes': 0},
        {'name': 'Data Visualization', 'code': 'CS506', 'credits': 2, 'professor': 'Dr. Morris', 'topics': 3, 'notes': 0},
      ],
      7: [
        {'name': 'Project Work - Part 1', 'code': 'CS601', 'credits': 5, 'professor': 'Dr. Rogers', 'topics': 2, 'notes': 0},
        {'name': 'Research Methodology', 'code': 'CS602', 'credits': 2, 'professor': 'Dr. Morgan', 'topics': 3, 'notes': 0},
        {'name': 'Internship Preparation', 'code': 'CS603', 'credits': 1, 'professor': 'Dr. Peterson', 'topics': 2, 'notes': 0},
      ],
      8: [
        {'name': 'Project Work - Part 2', 'code': 'CS701', 'credits': 5, 'professor': 'Dr. Cooper', 'topics': 2, 'notes': 0},
        {'name': 'Professional Ethics', 'code': 'CS702', 'credits': 2, 'professor': 'Dr. Richardson', 'topics': 2, 'notes': 0},
        {'name': 'Industry Seminar', 'code': 'CS703', 'credits': 1, 'professor': 'Dr. Cox', 'topics': 1, 'notes': 0},
      ],
    };
    return subjects[sem] ?? [];
  }

  // EE Subjects
  List<Map<String, dynamic>> getEESubjects(int sem) {
    final Map<int, List<Map<String, dynamic>>> subjects = {
      1: [
        {'name': 'Mathematics I', 'code': 'MA101', 'credits': 4, 'professor': 'Dr. Smith', 'topics': 5, 'notes': 0},
        {'name': 'Physics I', 'code': 'PH101', 'credits': 3, 'professor': 'Dr. Johnson', 'topics': 4, 'notes': 0},
        {'name': 'Circuit Theory', 'code': 'EE101', 'credits': 4, 'professor': 'Dr. Williams', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Chemistry', 'code': 'CH101', 'credits': 3, 'professor': 'Dr. Brown', 'topics': 4, 'notes': 0},
      ],
      2: [
        {'name': 'Mathematics II', 'code': 'MA102', 'credits': 4, 'professor': 'Dr. Davis', 'topics': 5, 'notes': 0},
        {'name': 'Physics II', 'code': 'PH102', 'credits': 3, 'professor': 'Dr. Miller', 'topics': 4, 'notes': 0},
        {'name': 'Electrical Machines I', 'code': 'EE102', 'credits': 4, 'professor': 'Dr. Wilson', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Graphics', 'code': 'EG102', 'credits': 2, 'professor': 'Dr. Moore', 'topics': 3, 'notes': 0},
      ],
      3: [
        {'name': 'Mathematics III', 'code': 'MA201', 'credits': 4, 'professor': 'Dr. Taylor', 'topics': 5, 'notes': 0},
        {'name': 'Electromagnetic Theory', 'code': 'EE201', 'credits': 4, 'professor': 'Dr. Anderson', 'topics': 5, 'notes': 0},
        {'name': 'Power Systems I', 'code': 'EE202', 'credits': 3, 'professor': 'Dr. Thomas', 'topics': 4, 'notes': 0},
        {'name': 'Control Systems', 'code': 'EE203', 'credits': 3, 'professor': 'Dr. Jackson', 'topics': 4, 'notes': 0},
        {'name': 'Power Electronics', 'code': 'EE204', 'credits': 3, 'professor': 'Dr. White', 'topics': 4, 'notes': 0},
        {'name': 'Digital Electronics', 'code': 'EE205', 'credits': 3, 'professor': 'Dr. Harris', 'topics': 4, 'notes': 0},
        {'name': 'Electrical Safety', 'code': 'EE206', 'credits': 2, 'professor': 'Dr. Martin', 'topics': 3, 'notes': 0},
      ],
      4: [
        {'name': 'Power Systems II', 'code': 'EE301', 'credits': 4, 'professor': 'Dr. Lee', 'topics': 4, 'notes': 0},
        {'name': 'Electrical Machines II', 'code': 'EE302', 'credits': 4, 'professor': 'Dr. Perez', 'topics': 4, 'notes': 0},
        {'name': 'Transmission & Distribution', 'code': 'EE303', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Microprocessor Systems', 'code': 'EE304', 'credits': 3, 'professor': 'Dr. Simmons', 'topics': 4, 'notes': 0},
        {'name': 'Measurement & Instrumentation', 'code': 'EE305', 'credits': 3, 'professor': 'Dr. Green', 'topics': 3, 'notes': 0},
        {'name': 'Industrial Drives', 'code': 'EE306', 'credits': 2, 'professor': 'Dr. Adams', 'topics': 3, 'notes': 0},
      ],
      5: [
        {'name': 'Power System Protection', 'code': 'EE401', 'credits': 4, 'professor': 'Dr. Carter', 'topics': 4, 'notes': 0},
        {'name': 'High Voltage Engineering', 'code': 'EE402', 'credits': 3, 'professor': 'Dr. Mitchell', 'topics': 4, 'notes': 0},
        {'name': 'Renewable Energy', 'code': 'EE403', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Smart Grids', 'code': 'EE404', 'credits': 3, 'professor': 'Dr. Phillips', 'topics': 3, 'notes': 0},
        {'name': 'Power Quality', 'code': 'EE405', 'credits': 3, 'professor': 'Dr. Campbell', 'topics': 3, 'notes': 0},
      ],
      6: [
        {'name': 'HVDC Transmission', 'code': 'EE501', 'credits': 3, 'professor': 'Dr. Evans', 'topics': 3, 'notes': 0},
        {'name': 'Electrical Vehicle Technology', 'code': 'EE502', 'credits': 3, 'professor': 'Dr. Edwards', 'topics': 3, 'notes': 0},
        {'name': 'Energy Management Systems', 'code': 'EE503', 'credits': 3, 'professor': 'Dr. Collins', 'topics': 3, 'notes': 0},
        {'name': 'Power Analytics', 'code': 'EE504', 'credits': 3, 'professor': 'Dr. Stewart', 'topics': 3, 'notes': 0},
        {'name': 'Fault Analysis', 'code': 'EE505', 'credits': 3, 'professor': 'Dr. Sanchez', 'topics': 3, 'notes': 0},
      ],
      7: [
        {'name': 'Project Work - Part 1', 'code': 'EE601', 'credits': 5, 'professor': 'Dr. Rogers', 'topics': 2, 'notes': 0},
        {'name': 'Research Methodology', 'code': 'EE602', 'credits': 2, 'professor': 'Dr. Morgan', 'topics': 3, 'notes': 0},
      ],
      8: [
        {'name': 'Project Work - Part 2', 'code': 'EE701', 'credits': 5, 'professor': 'Dr. Cooper', 'topics': 2, 'notes': 0},
        {'name': 'Professional Ethics', 'code': 'EE702', 'credits': 2, 'professor': 'Dr. Richardson', 'topics': 2, 'notes': 0},
      ],
    };
    return subjects[sem] ?? [];
  }

  // ECE Subjects
  List<Map<String, dynamic>> getECESubjects(int sem) {
    final Map<int, List<Map<String, dynamic>>> subjects = {
      1: [
        {'name': 'Mathematics I', 'code': 'MA101', 'credits': 4, 'professor': 'Dr. Smith', 'topics': 5, 'notes': 0},
        {'name': 'Physics I', 'code': 'PH101', 'credits': 3, 'professor': 'Dr. Johnson', 'topics': 4, 'notes': 0},
        {'name': 'Digital Electronics', 'code': 'EC101', 'credits': 4, 'professor': 'Dr. Williams', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Chemistry', 'code': 'CH101', 'credits': 3, 'professor': 'Dr. Brown', 'topics': 4, 'notes': 0},
      ],
      2: [
        {'name': 'Mathematics II', 'code': 'MA102', 'credits': 4, 'professor': 'Dr. Davis', 'topics': 5, 'notes': 0},
        {'name': 'Physics II', 'code': 'PH102', 'credits': 3, 'professor': 'Dr. Miller', 'topics': 4, 'notes': 0},
        {'name': 'Analog Electronics', 'code': 'EC102', 'credits': 4, 'professor': 'Dr. Wilson', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Graphics', 'code': 'EG102', 'credits': 2, 'professor': 'Dr. Moore', 'topics': 3, 'notes': 0},
      ],
      3: [
        {'name': 'Signals & Systems', 'code': 'EC201', 'credits': 4, 'professor': 'Dr. Taylor', 'topics': 5, 'notes': 0},
        {'name': 'Electromagnetic Theory', 'code': 'EC202', 'credits': 4, 'professor': 'Dr. Anderson', 'topics': 5, 'notes': 0},
        {'name': 'Microprocessors', 'code': 'EC203', 'credits': 3, 'professor': 'Dr. Thomas', 'topics': 4, 'notes': 0},
        {'name': 'Communication Systems', 'code': 'EC204', 'credits': 3, 'professor': 'Dr. Jackson', 'topics': 4, 'notes': 0},
        {'name': 'VLSI Design', 'code': 'EC205', 'credits': 3, 'professor': 'Dr. White', 'topics': 4, 'notes': 0},
        {'name': 'Data Communication', 'code': 'EC206', 'credits': 3, 'professor': 'Dr. Harris', 'topics': 4, 'notes': 0},
        {'name': 'Circuit Theory', 'code': 'EC207', 'credits': 2, 'professor': 'Dr. Martin', 'topics': 3, 'notes': 0},
      ],
      4: [
        {'name': 'Digital Signal Processing', 'code': 'EC301', 'credits': 4, 'professor': 'Dr. Lee', 'topics': 5, 'notes': 0},
        {'name': 'VLSI Technology', 'code': 'EC302', 'credits': 4, 'professor': 'Dr. Perez', 'topics': 4, 'notes': 0},
        {'name': 'Transmission Lines', 'code': 'EC303', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Antenna Design', 'code': 'EC304', 'credits': 3, 'professor': 'Dr. Simmons', 'topics': 3, 'notes': 0},
        {'name': 'Embedded Systems', 'code': 'EC305', 'credits': 3, 'professor': 'Dr. Green', 'topics': 4, 'notes': 0},
        {'name': 'Power Electronics', 'code': 'EC306', 'credits': 2, 'professor': 'Dr. Adams', 'topics': 3, 'notes': 0},
      ],
      5: [
        {'name': 'Microwave Engineering', 'code': 'EC401', 'credits': 4, 'professor': 'Dr. Carter', 'topics': 4, 'notes': 0},
        {'name': 'RF & Microwave', 'code': 'EC402', 'credits': 3, 'professor': 'Dr. Mitchell', 'topics': 4, 'notes': 0},
        {'name': 'Optical Communications', 'code': 'EC403', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': '5G Networks', 'code': 'EC404', 'credits': 3, 'professor': 'Dr. Phillips', 'topics': 3, 'notes': 0},
        {'name': 'IoT Systems', 'code': 'EC405', 'credits': 3, 'professor': 'Dr. Campbell', 'topics': 3, 'notes': 0},
      ],
      6: [
        {'name': 'Advanced VLSI', 'code': 'EC501', 'credits': 3, 'professor': 'Dr. Evans', 'topics': 4, 'notes': 0},
        {'name': 'Satellite Communications', 'code': 'EC502', 'credits': 3, 'professor': 'Dr. Edwards', 'topics': 3, 'notes': 0},
        {'name': 'Wireless Networks', 'code': 'EC503', 'credits': 3, 'professor': 'Dr. Collins', 'topics': 3, 'notes': 0},
        {'name': 'Signal Processing', 'code': 'EC504', 'credits': 3, 'professor': 'Dr. Stewart', 'topics': 3, 'notes': 0},
        {'name': 'Semiconductors', 'code': 'EC505', 'credits': 3, 'professor': 'Dr. Sanchez', 'topics': 3, 'notes': 0},
      ],
      7: [
        {'name': 'Project Work - Part 1', 'code': 'EC601', 'credits': 5, 'professor': 'Dr. Rogers', 'topics': 2, 'notes': 0},
        {'name': 'Research Methodology', 'code': 'EC602', 'credits': 2, 'professor': 'Dr. Morgan', 'topics': 3, 'notes': 0},
      ],
      8: [
        {'name': 'Project Work - Part 2', 'code': 'EC701', 'credits': 5, 'professor': 'Dr. Cooper', 'topics': 2, 'notes': 0},
        {'name': 'Professional Ethics', 'code': 'EC702', 'credits': 2, 'professor': 'Dr. Richardson', 'topics': 2, 'notes': 0},
      ],
    };
    return subjects[sem] ?? [];
  }

  // ME Subjects
  List<Map<String, dynamic>> getMESubjects(int sem) {
    final Map<int, List<Map<String, dynamic>>> subjects = {
      1: [
        {'name': 'Mathematics I', 'code': 'MA101', 'credits': 4, 'professor': 'Dr. Smith', 'topics': 5, 'notes': 0},
        {'name': 'Physics I', 'code': 'PH101', 'credits': 3, 'professor': 'Dr. Johnson', 'topics': 4, 'notes': 0},
        {'name': 'Engineering Mechanics', 'code': 'ME101', 'credits': 4, 'professor': 'Dr. Williams', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Chemistry', 'code': 'CH101', 'credits': 3, 'professor': 'Dr. Brown', 'topics': 4, 'notes': 0},
      ],
      2: [
        {'name': 'Mathematics II', 'code': 'MA102', 'credits': 4, 'professor': 'Dr. Davis', 'topics': 5, 'notes': 0},
        {'name': 'Physics II', 'code': 'PH102', 'credits': 3, 'professor': 'Dr. Miller', 'topics': 4, 'notes': 0},
        {'name': 'Thermodynamics I', 'code': 'ME102', 'credits': 4, 'professor': 'Dr. Wilson', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Graphics', 'code': 'EG102', 'credits': 2, 'professor': 'Dr. Moore', 'topics': 3, 'notes': 0},
      ],
      3: [
        {'name': 'Thermodynamics II', 'code': 'ME201', 'credits': 4, 'professor': 'Dr. Taylor', 'topics': 5, 'notes': 0},
        {'name': 'Fluid Mechanics', 'code': 'ME202', 'credits': 4, 'professor': 'Dr. Anderson', 'topics': 5, 'notes': 0},
        {'name': 'Machine Design I', 'code': 'ME203', 'credits': 3, 'professor': 'Dr. Thomas', 'topics': 4, 'notes': 0},
        {'name': 'Manufacturing Technology', 'code': 'ME204', 'credits': 3, 'professor': 'Dr. Jackson', 'topics': 4, 'notes': 0},
        {'name': 'Heat Transfer', 'code': 'ME205', 'credits': 3, 'professor': 'Dr. White', 'topics': 4, 'notes': 0},
        {'name': 'Dynamics', 'code': 'ME206', 'credits': 3, 'professor': 'Dr. Harris', 'topics': 4, 'notes': 0},
        {'name': 'CAD/CAM Basics', 'code': 'ME207', 'credits': 2, 'professor': 'Dr. Martin', 'topics': 3, 'notes': 0},
      ],
      4: [
        {'name': 'Machine Design II', 'code': 'ME301', 'credits': 4, 'professor': 'Dr. Lee', 'topics': 4, 'notes': 0},
        {'name': 'Finite Element Analysis', 'code': 'ME302', 'credits': 4, 'professor': 'Dr. Perez', 'topics': 5, 'notes': 0},
        {'name': 'Power Plant Engineering', 'code': 'ME303', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Internal Combustion Engines', 'code': 'ME304', 'credits': 3, 'professor': 'Dr. Simmons', 'topics': 4, 'notes': 0},
        {'name': 'Hydraulic Systems', 'code': 'ME305', 'credits': 3, 'professor': 'Dr. Green', 'topics': 3, 'notes': 0},
        {'name': 'Vibrations', 'code': 'ME306', 'credits': 2, 'professor': 'Dr. Adams', 'topics': 3, 'notes': 0},
      ],
      5: [
        {'name': 'Turbomachinery', 'code': 'ME401', 'credits': 4, 'professor': 'Dr. Carter', 'topics': 4, 'notes': 0},
        {'name': 'Compressible Flow', 'code': 'ME402', 'credits': 3, 'professor': 'Dr. Mitchell', 'topics': 4, 'notes': 0},
        {'name': 'Advanced Manufacturing', 'code': 'ME403', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Renewable Energy Systems', 'code': 'ME404', 'credits': 3, 'professor': 'Dr. Phillips', 'topics': 3, 'notes': 0},
        {'name': 'Robotics', 'code': 'ME405', 'credits': 3, 'professor': 'Dr. Campbell', 'topics': 4, 'notes': 0},
      ],
      6: [
        {'name': 'Advanced CAD/CAM', 'code': 'ME501', 'credits': 3, 'professor': 'Dr. Evans', 'topics': 4, 'notes': 0},
        {'name': 'Additive Manufacturing', 'code': 'ME502', 'credits': 3, 'professor': 'Dr. Edwards', 'topics': 3, 'notes': 0},
        {'name': 'Nano-materials', 'code': 'ME503', 'credits': 3, 'professor': 'Dr. Collins', 'topics': 3, 'notes': 0},
        {'name': 'Energy Efficiency', 'code': 'ME504', 'credits': 3, 'professor': 'Dr. Stewart', 'topics': 3, 'notes': 0},
        {'name': 'Supply Chain Management', 'code': 'ME505', 'credits': 3, 'professor': 'Dr. Sanchez', 'topics': 3, 'notes': 0},
      ],
      7: [
        {'name': 'Project Work - Part 1', 'code': 'ME601', 'credits': 5, 'professor': 'Dr. Rogers', 'topics': 2, 'notes': 0},
        {'name': 'Research Methodology', 'code': 'ME602', 'credits': 2, 'professor': 'Dr. Morgan', 'topics': 3, 'notes': 0},
      ],
      8: [
        {'name': 'Project Work - Part 2', 'code': 'ME701', 'credits': 5, 'professor': 'Dr. Cooper', 'topics': 2, 'notes': 0},
        {'name': 'Professional Ethics', 'code': 'ME702', 'credits': 2, 'professor': 'Dr. Richardson', 'topics': 2, 'notes': 0},
      ],
    };
    return subjects[sem] ?? [];
  }

  // CE Subjects
  List<Map<String, dynamic>> getCESubjects(int sem) {
    final Map<int, List<Map<String, dynamic>>> subjects = {
      1: [
        {'name': 'Mathematics I', 'code': 'MA101', 'credits': 4, 'professor': 'Dr. Smith', 'topics': 5, 'notes': 0},
        {'name': 'Physics I', 'code': 'PH101', 'credits': 3, 'professor': 'Dr. Johnson', 'topics': 4, 'notes': 0},
        {'name': 'Surveying Fundamentals', 'code': 'CE101', 'credits': 4, 'professor': 'Dr. Williams', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Chemistry', 'code': 'CH101', 'credits': 3, 'professor': 'Dr. Brown', 'topics': 4, 'notes': 0},
      ],
      2: [
        {'name': 'Mathematics II', 'code': 'MA102', 'credits': 4, 'professor': 'Dr. Davis', 'topics': 5, 'notes': 0},
        {'name': 'Physics II', 'code': 'PH102', 'credits': 3, 'professor': 'Dr. Miller', 'topics': 4, 'notes': 0},
        {'name': 'Building Materials', 'code': 'CE102', 'credits': 4, 'professor': 'Dr. Wilson', 'topics': 5, 'notes': 0},
        {'name': 'Engineering Graphics', 'code': 'EG102', 'credits': 2, 'professor': 'Dr. Moore', 'topics': 3, 'notes': 0},
      ],
      3: [
        {'name': 'Structural Analysis I', 'code': 'CE201', 'credits': 4, 'professor': 'Dr. Taylor', 'topics': 5, 'notes': 0},
        {'name': 'Geotechnical Engineering I', 'code': 'CE202', 'credits': 4, 'professor': 'Dr. Anderson', 'topics': 5, 'notes': 0},
        {'name': 'Water Resources Engineering', 'code': 'CE203', 'credits': 3, 'professor': 'Dr. Thomas', 'topics': 4, 'notes': 0},
        {'name': 'Transportation Engineering', 'code': 'CE204', 'credits': 3, 'professor': 'Dr. Jackson', 'topics': 4, 'notes': 0},
        {'name': 'Environmental Engineering', 'code': 'CE205', 'credits': 3, 'professor': 'Dr. White', 'topics': 4, 'notes': 0},
        {'name': 'Concrete Technology', 'code': 'CE206', 'credits': 3, 'professor': 'Dr. Harris', 'topics': 4, 'notes': 0},
        {'name': 'Engineering Geology', 'code': 'CE207', 'credits': 2, 'professor': 'Dr. Martin', 'topics': 3, 'notes': 0},
      ],
      4: [
        {'name': 'Structural Analysis II', 'code': 'CE301', 'credits': 4, 'professor': 'Dr. Lee', 'topics': 5, 'notes': 0},
        {'name': 'RCC Design', 'code': 'CE302', 'credits': 4, 'professor': 'Dr. Perez', 'topics': 5, 'notes': 0},
        {'name': 'Steel Design', 'code': 'CE303', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Foundation Engineering', 'code': 'CE304', 'credits': 3, 'professor': 'Dr. Simmons', 'topics': 4, 'notes': 0},
        {'name': 'Highway Engineering', 'code': 'CE305', 'credits': 3, 'professor': 'Dr. Green', 'topics': 3, 'notes': 0},
        {'name': 'Water Supply Systems', 'code': 'CE306', 'credits': 2, 'professor': 'Dr. Adams', 'topics': 3, 'notes': 0},
      ],
      5: [
        {'name': 'Advanced Structural Analysis', 'code': 'CE401', 'credits': 4, 'professor': 'Dr. Carter', 'topics': 4, 'notes': 0},
        {'name': 'Earthquake Engineering', 'code': 'CE402', 'credits': 3, 'professor': 'Dr. Mitchell', 'topics': 4, 'notes': 0},
        {'name': 'Wastewater Treatment', 'code': 'CE403', 'credits': 3, 'professor': 'Dr. Roberts', 'topics': 4, 'notes': 0},
        {'name': 'Railway Engineering', 'code': 'CE404', 'credits': 3, 'professor': 'Dr. Phillips', 'topics': 3, 'notes': 0},
        {'name': 'Tunnel Engineering', 'code': 'CE405', 'credits': 3, 'professor': 'Dr. Campbell', 'topics': 3, 'notes': 0},
      ],
      6: [
        {'name': 'Prestressed Concrete', 'code': 'CE501', 'credits': 3, 'professor': 'Dr. Evans', 'topics': 4, 'notes': 0},
        {'name': 'Bridge Engineering', 'code': 'CE502', 'credits': 3, 'professor': 'Dr. Edwards', 'topics': 4, 'notes': 0},
        {'name': 'Smart Infrastructure', 'code': 'CE503', 'credits': 3, 'professor': 'Dr. Collins', 'topics': 3, 'notes': 0},
        {'name': 'Green Building', 'code': 'CE504', 'credits': 3, 'professor': 'Dr. Stewart', 'topics': 3, 'notes': 0},
        {'name': 'Urban Planning', 'code': 'CE505', 'credits': 3, 'professor': 'Dr. Sanchez', 'topics': 3, 'notes': 0},
      ],
      7: [
        {'name': 'Project Work - Part 1', 'code': 'CE601', 'credits': 5, 'professor': 'Dr. Rogers', 'topics': 2, 'notes': 0},
        {'name': 'Research Methodology', 'code': 'CE602', 'credits': 2, 'professor': 'Dr. Morgan', 'topics': 3, 'notes': 0},
      ],
      8: [
        {'name': 'Project Work - Part 2', 'code': 'CE701', 'credits': 5, 'professor': 'Dr. Cooper', 'topics': 2, 'notes': 0},
        {'name': 'Professional Ethics', 'code': 'CE702', 'credits': 2, 'professor': 'Dr. Richardson', 'topics': 2, 'notes': 0},
      ],
    };
    return subjects[sem] ?? [];
  }

  int calculateTotalCredits(List<Map<String, dynamic>> subjects) {
    return subjects.fold(0, (sum, subject) => sum + (subject['credits'] as int));
  }

  @override
  @override
  Widget build(BuildContext context) {
    final subjects = getSubjects();
    final totalCredits = calculateTotalCredits(subjects);

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
              widget.semesterName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1DB954),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.departmentAbbr} - Year ${widget.yearNum}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF888888),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatsItem('📚', '${subjects.length}', 'Subjects'),
                    _buildStatsItem('📝', '${_uploadedNotes.length}', 'Uploaded'),
                    _buildStatsItem('⭐', '$totalCredits+', 'Credits'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Subject Cards
              Column(
                children: List.generate(
                  subjects.length,
                  (index) => Column(
                    children: [
                      _buildSubjectCard(context, subjects[index]),
                      if (index < subjects.length - 1)
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

  Widget _buildStatsItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0A0A0A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(BuildContext context, Map<String, dynamic> subject) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F1),
        borderRadius: BorderRadius.circular(16),
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
                  color: const Color(0xFF1DB954),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.book,
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
                      subject['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0A0A0A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subject['code'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${subject['credits']} Credits',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1DB954),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.description,
                      size: 12,
                      color: Color(0xFF0084D4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${subject['notes']} Notes',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0084D4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 12,
                      color: Color(0xFFCA1E7E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subject['professor'],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFCA1E7E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.topic,
                      size: 12,
                      color: Color(0xFFF57C00),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${subject['topics']} Topics',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF57C00),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${subject['name']} Details'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1DB954),
                        width: 1.5,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Color(0xFF1DB954),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1DB954),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await _pickAndUploadFile(
                      subject['code'],
                      subject['name'],
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isUploading ? Icons.hourglass_empty : Icons.upload_file,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isUploading ? 'Uploading...' : 'Upload PDF',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
