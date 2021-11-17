import 'package:exam_students/models/models.dart';

abstract class BaseQuestionPaperRepository {
  Future<QuestionPaper> getQuestionPaper({required String id});
}
