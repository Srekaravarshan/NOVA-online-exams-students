import 'package:exam_students/models/models.dart';

abstract class BaseClassesRepository {
  Stream<List<Class?>> getUserClasses({required String userId});

  Stream<List<Subject?>> getUserSubjects({required String classId});

  Future<Class?> getClassWithId({required String classId});

  Future<void> addSet({required String classId, required List questionPapers});
}
