import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject.dart';

class SubjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'subjects';

  // Create a new subject
  Future<String> createSubject(Subject subject) async {
    try {
      DocumentReference docRef = await _firestore.collection(collection).add(subject.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create subject: $e');
    }
  }

  // Get a subject by ID
  Future<Subject?> getSubjectById(String subjectId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(collection).doc(subjectId).get();
      
      if (docSnapshot.exists) {
        return Subject.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get subject: $e');
    }
  }

  // Get all subjects for a specific semester
  Future<List<Subject>> getSemesterSubjects(String semesterId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('semesterId', isEqualTo: semesterId)
          .get();

      // Sort locally to avoid index requirement
      List<Subject> subjects = querySnapshot.docs
          .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Sort by name locally
      subjects.sort((a, b) => a.name.compareTo(b.name));
      
      return subjects;
    } catch (e) {
      throw Exception('Failed to get semester subjects: $e');
    }
  }

  // Get all subjects for a specific department
  Future<List<Subject>> getDepartmentSubjects(String department) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('department', isEqualTo: department)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get department subjects: $e');
    }
  }

  // Get all subjects
  Future<List<Subject>> getAllSubjects() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all subjects: $e');
    }
  }

  // Search subjects by name, code, or description
  Future<List<Subject>> searchSubjects(String query, {String? department}) async {
    try {
      Query queryBuilder = _firestore.collection(collection);
      
      if (department != null) {
        queryBuilder = queryBuilder.where('department', isEqualTo: department);
      }

      QuerySnapshot querySnapshot = await queryBuilder.get();
      
      List<Subject> allSubjects = querySnapshot.docs
          .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Filter subjects based on search query (case-insensitive)
      return allSubjects.where((subject) {
        return subject.name.toLowerCase().contains(query.toLowerCase()) ||
               subject.code.toLowerCase().contains(query.toLowerCase()) ||
               subject.description.toLowerCase().contains(query.toLowerCase()) ||
               subject.topics.any((topic) => topic.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    } catch (e) {
      throw Exception('Failed to search subjects: $e');
    }
  }

  // Update an existing subject
  Future<void> updateSubject(String subjectId, Subject subject) async {
    try {
      await _firestore.collection(collection).doc(subjectId).update(subject.toMap());
    } catch (e) {
      throw Exception('Failed to update subject: $e');
    }
  }

  // Delete a subject
  Future<void> deleteSubject(String subjectId) async {
    try {
      await _firestore.collection(collection).doc(subjectId).delete();
    } catch (e) {
      throw Exception('Failed to delete subject: $e');
    }
  }

  // Add a topic to a subject
  Future<void> addTopic(String subjectId, String topic) async {
    try {
      DocumentReference docRef = _firestore.collection(collection).doc(subjectId);
      
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(docRef);
        
        if (!docSnapshot.exists) {
          throw Exception('Subject not found');
        }

        Subject subject = Subject.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        List<String> topics = List<String>.from(subject.topics);
        
        if (!topics.contains(topic)) {
          topics.add(topic);
          transaction.update(docRef, {
            'topics': topics,
            'updatedAt': Timestamp.now(),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to add topic: $e');
    }
  }

  // Remove a topic from a subject
  Future<void> removeTopic(String subjectId, String topic) async {
    try {
      DocumentReference docRef = _firestore.collection(collection).doc(subjectId);
      
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(docRef);
        
        if (!docSnapshot.exists) {
          throw Exception('Subject not found');
        }

        Subject subject = Subject.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        List<String> topics = List<String>.from(subject.topics);
        
        topics.remove(topic);
        transaction.update(docRef, {
          'topics': topics,
          'updatedAt': Timestamp.now(),
        });
      });
    } catch (e) {
      throw Exception('Failed to remove topic: $e');
    }
  }

  // Get stream of subjects for a specific semester for real-time updates
  Stream<List<Subject>> getSemesterSubjectsStream(String semesterId) {
    return _firestore
        .collection(collection)
        .where('semesterId', isEqualTo: semesterId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Get stream of all subjects for real-time updates
  Stream<List<Subject>> getAllSubjectsStream() {
    return _firestore
        .collection(collection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Initialize common subjects in Firestore
  Future<void> initializeCommonSubjects() async {
    try {
      List<Subject> commonSubjects = Subject.getCommonSubjects();
      
      for (Subject subject in commonSubjects) {
        // Check if subject already exists
        QuerySnapshot existingSubjects = await _firestore
            .collection(collection)
            .where('code', isEqualTo: subject.code)
            .where('semesterId', isEqualTo: subject.semesterId)
            .get();

        if (existingSubjects.docs.isEmpty) {
          await createSubject(subject);
        }
      }
    } catch (e) {
      throw Exception('Failed to initialize common subjects: $e');
    }
  }
}
