import 'package:cloud_firestore/cloud_firestore.dart';

class Semester {
  final String id;
  final String name;
  final String displayName;
  final int semesterNumber;
  final String branch;
  final String department;
  final int academicYear;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final List<String> subjectIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Semester({
    required this.id,
    required this.name,
    required this.displayName,
    required this.semesterNumber,
    required this.branch,
    required this.department,
    required this.academicYear,
    required this.startDate,
    required this.endDate,
    this.isActive = false,
    this.subjectIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Create Semester from Firestore document
  factory Semester.fromMap(Map<String, dynamic> data, String documentId) {
    return Semester(
      id: documentId,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      semesterNumber: data['semesterNumber'] ?? 0,
      branch: data['branch'] ?? '',
      department: data['department'] ?? '',
      academicYear: data['academicYear'] ?? 0,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? false,
      subjectIds: List<String>.from(data['subjectIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert Semester to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'semesterNumber': semesterNumber,
      'branch': branch,
      'department': department,
      'academicYear': academicYear,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isActive': isActive,
      'subjectIds': subjectIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create a copy with updated fields
  Semester copyWith({
    String? id,
    String? name,
    String? displayName,
    int? semesterNumber,
    String? branch,
    String? department,
    int? academicYear,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<String>? subjectIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Semester(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      semesterNumber: semesterNumber ?? this.semesterNumber,
      branch: branch ?? this.branch,
      department: department ?? this.department,
      academicYear: academicYear ?? this.academicYear,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      subjectIds: subjectIds ?? this.subjectIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get common semesters for Computer Science branch
  static List<Semester> getCommonSemesters() {
    final now = DateTime.now();
    final currentYear = now.year;
    
    return [
      Semester(
        id: 'sem_1',
        name: 'First Semester',
        displayName: '1st Semester',
        semesterNumber: 1,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear,
        startDate: DateTime(currentYear, 7, 1),
        endDate: DateTime(currentYear, 12, 31),
        isActive: true,
        subjectIds: ['sub_1_1', 'sub_1_2', 'sub_1_3'],
        createdAt: now,
        updatedAt: now,
      ),
      Semester(
        id: 'sem_2',
        name: 'Second Semester',
        displayName: '2nd Semester',
        semesterNumber: 2,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear,
        startDate: DateTime(currentYear, 1, 1),
        endDate: DateTime(currentYear, 6, 30),
        isActive: true,
        subjectIds: ['sub_2_1', 'sub_2_2', 'sub_2_3'],
        createdAt: now,
        updatedAt: now,
      ),
      Semester(
        id: 'sem_3',
        name: 'Third Semester',
        displayName: '3rd Semester',
        semesterNumber: 3,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear + 1,
        startDate: DateTime(currentYear + 1, 7, 1),
        endDate: DateTime(currentYear + 1, 12, 31),
        isActive: false,
        subjectIds: ['sub_3_1', 'sub_3_2', 'sub_3_3'],
        createdAt: now,
        updatedAt: now,
      ),
      Semester(
        id: 'sem_4',
        name: 'Fourth Semester',
        displayName: '4th Semester',
        semesterNumber: 4,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear + 1,
        startDate: DateTime(currentYear + 1, 1, 1),
        endDate: DateTime(currentYear + 1, 6, 30),
        isActive: false,
        subjectIds: ['sub_4_1', 'sub_4_2', 'sub_4_3'],
        createdAt: now,
        updatedAt: now,
      ),
      Semester(
        id: 'sem_5',
        name: 'Fifth Semester',
        displayName: '5th Semester',
        semesterNumber: 5,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear + 2,
        startDate: DateTime(currentYear + 2, 7, 1),
        endDate: DateTime(currentYear + 2, 12, 31),
        isActive: false,
        subjectIds: [],
        createdAt: now,
        updatedAt: now,
      ),
      Semester(
        id: 'sem_6',
        name: 'Sixth Semester',
        displayName: '6th Semester',
        semesterNumber: 6,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear + 2,
        startDate: DateTime(currentYear + 2, 1, 1),
        endDate: DateTime(currentYear + 2, 6, 30),
        isActive: false,
        subjectIds: [],
        createdAt: now,
        updatedAt: now,
      ),
      Semester(
        id: 'sem_7',
        name: 'Seventh Semester',
        displayName: '7th Semester',
        semesterNumber: 7,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear + 3,
        startDate: DateTime(currentYear + 3, 7, 1),
        endDate: DateTime(currentYear + 3, 12, 31),
        isActive: false,
        subjectIds: [],
        createdAt: now,
        updatedAt: now,
      ),
      Semester(
        id: 'sem_8',
        name: 'Eighth Semester',
        displayName: '8th Semester',
        semesterNumber: 8,
        branch: 'Computer Science',
        department: 'Computer Science and Engineering',
        academicYear: currentYear + 3,
        startDate: DateTime(currentYear + 3, 1, 1),
        endDate: DateTime(currentYear + 3, 6, 30),
        isActive: false,
        subjectIds: [],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
