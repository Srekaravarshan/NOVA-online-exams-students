import 'package:exam_students/models/models.dart';

abstract class BaseAssignmentRepository {
  Future<List> getAssignmentIds(
      {required String classId, required String subjectId});
  Future<Assignment> getAssignment({required String assignmentId});
}
