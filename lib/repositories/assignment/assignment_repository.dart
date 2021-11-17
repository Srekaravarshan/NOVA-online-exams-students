import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_students/config/paths.dart';
import 'package:exam_students/models/models.dart';

import 'base_assignment_repository.dart';

class AssignmentRepository extends BaseAssignmentRepository {
  final FirebaseFirestore _firebaseFirestore;

  AssignmentRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List> getAssignmentIds(
      {required String classId, required String subjectId}) async {
    Subject subject = Subject.fromDocument(await _firebaseFirestore
            .collection(Paths.classes)
            .doc(classId)
            .collection(Paths.subjects)
            .doc(subjectId)
            .get()) ??
        Subject.empty;
    return subject.materials;
  }

  @override
  Future<Assignment> getAssignment({required String assignmentId}) async {
    return Assignment.fromDocument(await _firebaseFirestore
        .collection(Paths.materials)
        .doc(assignmentId)
        .get());
  }
}
