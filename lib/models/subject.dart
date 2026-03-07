import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  final String id;
  final String name;
  final String code;
  final String description;
  final String semesterId;
  final String department;
  final int credits;
  final String faculty;
  final List<String> topics;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.semesterId,
    required this.department,
    required this.credits,
    required this.faculty,
    this.topics = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Create Subject from Firestore document
  factory Subject.fromMap(Map<String, dynamic> data, String documentId) {
    return Subject(
      id: documentId,
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      description: data['description'] ?? '',
      semesterId: data['semesterId'] ?? '',
      department: data['department'] ?? '',
      credits: data['credits'] ?? 0,
      faculty: data['faculty'] ?? '',
      topics: List<String>.from(data['topics'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert Subject to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'description': description,
      'semesterId': semesterId,
      'department': department,
      'credits': credits,
      'faculty': faculty,
      'topics': topics,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create a copy with updated fields
  Subject copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? semesterId,
    String? department,
    int? credits,
    String? faculty,
    List<String>? topics,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      semesterId: semesterId ?? this.semesterId,
      department: department ?? this.department,
      credits: credits ?? this.credits,
      faculty: faculty ?? this.faculty,
      topics: topics ?? this.topics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get common subjects for different semesters
  static List<Subject> getCommonSubjects() {
    return [
      // First Semester
      Subject(
        id: 'sub_1_1',
        name: 'Mathematics I',
        code: 'MA101',
        description: 'Calculus, Linear Algebra, and Differential Equations',
        semesterId: 'sem_1',
        department: 'Computer Science',
        credits: 4,
        faculty: 'Dr. Smith',
        topics: ['Limits', 'Derivatives', 'Integrals', 'Matrices', 'Vectors'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_1_2',
        name: 'Physics I',
        code: 'PH101',
        description: 'Mechanics, Thermodynamics, and Waves',
        semesterId: 'sem_1',
        department: 'Computer Science',
        credits: 3,
        faculty: 'Dr. Johnson',
        topics: ['Kinematics', 'Newton\'s Laws', 'Thermodynamics', 'Oscillations'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_1_3',
        name: 'Programming Fundamentals',
        code: 'CS101',
        description: 'Introduction to Programming using C/C++',
        semesterId: 'sem_1',
        department: 'Computer Science',
        credits: 4,
        faculty: 'Dr. Williams',
        topics: ['Variables', 'Control Structures', 'Functions', 'Arrays', 'Pointers'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Second Semester
      Subject(
        id: 'sub_2_1',
        name: 'Mathematics II',
        code: 'MA102',
        description: 'Advanced Calculus, Probability, and Statistics',
        semesterId: 'sem_2',
        department: 'Computer Science',
        credits: 4,
        faculty: 'Dr. Brown',
        topics: ['Multiple Integrals', 'Probability', 'Statistics', 'Complex Numbers'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_2_2',
        name: 'Data Structures',
        code: 'CS201',
        description: 'Introduction to Data Structures and Algorithms',
        semesterId: 'sem_2',
        department: 'Computer Science',
        credits: 4,
        faculty: 'Dr. Davis',
        topics: ['Arrays', 'Linked Lists', 'Stacks', 'Queues', 'Trees', 'Graphs'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_2_3',
        name: 'Digital Logic',
        code: 'EE101',
        description: 'Digital Electronics and Logic Design',
        semesterId: 'sem_2',
        department: 'Computer Science',
        credits: 3,
        faculty: 'Dr. Miller',
        topics: ['Boolean Algebra', 'Logic Gates', 'Combinational Circuits', 'Sequential Circuits'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Third Semester
      Subject(
        id: 'sub_3_1',
        name: 'Database Management Systems',
        code: 'CS301',
        description: 'Introduction to Database Design and SQL',
        semesterId: 'sem_3',
        department: 'Computer Science',
        credits: 4,
        faculty: 'Dr. Wilson',
        topics: ['ER Diagrams', 'Normalization', 'SQL', 'Transactions', 'NoSQL'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_3_2',
        name: 'Object Oriented Programming',
        code: 'CS302',
        description: 'Object Oriented Programming using Java/Python',
        semesterId: 'sem_3',
        department: 'Computer Science',
        credits: 4,
        faculty: 'Dr. Moore',
        topics: ['Classes', 'Objects', 'Inheritance', 'Polymorphism', 'Encapsulation'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_3_3',
        name: 'Computer Networks',
        code: 'CS303',
        description: 'Introduction to Computer Networks and Protocols',
        semesterId: 'sem_3',
        department: 'Computer Science',
        credits: 3,
        faculty: 'Dr. Taylor',
        topics: ['OSI Model', 'TCP/IP', 'Routing', 'Network Security'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Fourth Semester
      Subject(
        id: 'sub_4_1',
        name: 'Operating Systems',
        code: 'CS401',
        description: 'Introduction to Operating Systems Concepts',
        semesterId: 'sem_4',
        department: 'Computer Science',
        credits: 4,
        faculty: 'Dr. Anderson',
        topics: ['Process Management', 'Memory Management', 'File Systems', 'Scheduling'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_4_2',
        name: 'Web Development',
        code: 'CS402',
        description: 'Full Stack Web Development',
        semesterId: 'sem_4',
        department: 'Computer Science',
        credits: 3,
        faculty: 'Dr. Thomas',
        topics: ['HTML', 'CSS', 'JavaScript', 'React', 'Node.js'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Subject(
        id: 'sub_4_3',
        name: 'Software Engineering',
        code: 'CS403',
        description: 'Software Development Methodologies',
        semesterId: 'sem_4',
        department: 'Computer Science',
        credits: 3,
        faculty: 'Dr. Jackson',
        topics: ['SDLC', 'Agile', 'Testing', 'Design Patterns', 'Project Management'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
