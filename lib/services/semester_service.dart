import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/semester.dart';

class SemesterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'semesters';

  // Create a new semester
  Future<String> createSemester(Semester semester) async {
    try {
      DocumentReference docRef = await _firestore.collection(collection).add(semester.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create semester: $e');
    }
  }

  // Get a semester by ID
  Future<Semester?> getSemesterById(String semesterId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(collection).doc(semesterId).get();
      
      if (docSnapshot.exists) {
        return Semester.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get semester: $e');
    }
  }

  // Get all semesters
  Future<List<Semester>> getAllSemesters() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .orderBy('academicYear')
          .orderBy('semesterNumber')
          .get();

      return querySnapshot.docs
          .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all semesters: $e');
    }
  }

  // Get semesters by branch
  Future<List<Semester>> getSemestersByBranch(String branch) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('branch', isEqualTo: branch)
          .orderBy('academicYear')
          .orderBy('semesterNumber')
          .get();

      return querySnapshot.docs
          .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get semesters by branch: $e');
    }
  }

  // Get active semesters
  Future<List<Semester>> getActiveSemesters() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('isActive', isEqualTo: true)
          .orderBy('academicYear')
          .orderBy('semesterNumber')
          .get();

      return querySnapshot.docs
          .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get active semesters: $e');
    }
  }

  // Get current semester (based on current date)
  Future<Semester?> getCurrentSemester() async {
    try {
      DateTime now = DateTime.now();
      
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('startDate', isLessThanOrEqualTo: now)
          .where('endDate', isGreaterThanOrEqualTo: now)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Semester.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current semester: $e');
    }
  }

  // Get semesters by academic year
  Future<List<Semester>> getSemestersByYear(int academicYear) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('academicYear', isEqualTo: academicYear)
          .orderBy('semesterNumber')
          .get();

      return querySnapshot.docs
          .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get semesters by year: $e');
    }
  }

  // Search semesters by name or display name
  Future<List<Semester>> searchSemesters(String query, {String? branch}) async {
    try {
      Query queryBuilder = _firestore.collection(collection);
      
      if (branch != null) {
        queryBuilder = queryBuilder.where('branch', isEqualTo: branch);
      }

      QuerySnapshot querySnapshot = await queryBuilder.get();
      
      List<Semester> allSemesters = querySnapshot.docs
          .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Filter semesters based on search query (case-insensitive)
      return allSemesters.where((semester) {
        return semester.name.toLowerCase().contains(query.toLowerCase()) ||
               semester.displayName.toLowerCase().contains(query.toLowerCase()) ||
               semester.branch.toLowerCase().contains(query.toLowerCase()) ||
               semester.department.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Failed to search semesters: $e');
    }
  }

  // Update an existing semester
  Future<void> updateSemester(String semesterId, Semester semester) async {
    try {
      await _firestore.collection(collection).doc(semesterId).update(semester.toMap());
    } catch (e) {
      throw Exception('Failed to update semester: $e');
    }
  }

  // Delete a semester
  Future<void> deleteSemester(String semesterId) async {
    try {
      await _firestore.collection(collection).doc(semesterId).delete();
    } catch (e) {
      throw Exception('Failed to delete semester: $e');
    }
  }

  // Add a subject to a semester
  Future<void> addSubject(String semesterId, String subjectId) async {
    try {
      DocumentReference docRef = _firestore.collection(collection).doc(semesterId);
      
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(docRef);
        
        if (!docSnapshot.exists) {
          throw Exception('Semester not found');
        }

        Semester semester = Semester.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        List<String> subjectIds = List<String>.from(semester.subjectIds);
        
        if (!subjectIds.contains(subjectId)) {
          subjectIds.add(subjectId);
          transaction.update(docRef, {
            'subjectIds': subjectIds,
            'updatedAt': Timestamp.now(),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to add subject to semester: $e');
    }
  }

  // Remove a subject from a semester
  Future<void> removeSubject(String semesterId, String subjectId) async {
    try {
      DocumentReference docRef = _firestore.collection(collection).doc(semesterId);
      
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(docRef);
        
        if (!docSnapshot.exists) {
          throw Exception('Semester not found');
        }

        Semester semester = Semester.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        List<String> subjectIds = List<String>.from(semester.subjectIds);
        
        subjectIds.remove(subjectId);
        transaction.update(docRef, {
          'subjectIds': subjectIds,
          'updatedAt': Timestamp.now(),
        });
      });
    } catch (e) {
      throw Exception('Failed to remove subject from semester: $e');
    }
  }

  // Activate/deactivate a semester
  Future<void> toggleSemesterStatus(String semesterId, bool isActive) async {
    try {
      await _firestore.collection(collection).doc(semesterId).update({
        'isActive': isActive,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to toggle semester status: $e');
    }
  }

  // Get stream of all semesters for real-time updates
  Stream<List<Semester>> getAllSemestersStream() {
    return _firestore
        .collection(collection)
        .orderBy('academicYear')
        .orderBy('semesterNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Get stream of active semesters for real-time updates
  Stream<List<Semester>> getActiveSemestersStream() {
    return _firestore
        .collection(collection)
        .where('isActive', isEqualTo: true)
        .orderBy('academicYear')
        .orderBy('semesterNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Get stream of semesters by branch for real-time updates
  Stream<List<Semester>> getSemestersByBranchStream(String branch) {
    return _firestore
        .collection(collection)
        .where('branch', isEqualTo: branch)
        .orderBy('academicYear')
        .orderBy('semesterNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Semester.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Initialize common semesters in Firestore
  Future<void> initializeCommonSemesters() async {
    try {
      List<Semester> commonSemesters = Semester.getCommonSemesters();
      
      for (Semester semester in commonSemesters) {
        // Check if semester already exists
        QuerySnapshot existingSemesters = await _firestore
            .collection(collection)
            .where('semesterNumber', isEqualTo: semester.semesterNumber)
            .where('academicYear', isEqualTo: semester.academicYear)
            .where('branch', isEqualTo: semester.branch)
            .get();

        if (existingSemesters.docs.isEmpty) {
          await createSemester(semester);
        }
      }
    } catch (e) {
      throw Exception('Failed to initialize common semesters: $e');
    }
  }
}
