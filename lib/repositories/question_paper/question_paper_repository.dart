import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_students/config/paths.dart';
import 'package:exam_students/models/models.dart';
import 'package:exam_students/repositories/repositories.dart';

class QuestionPaperRepository extends BaseQuestionPaperRepository {
  final FirebaseFirestore _firebaseFirestore;

  QuestionPaperRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<QuestionPaper> getQuestionPaper({required String id}) async {
    print('getQuestionPaper');
    print(id);
    DocumentSnapshot<Map> doc =
        await _firebaseFirestore.collection(Paths.questionPapers).doc(id).get();
    print(doc.id);
    return QuestionPaper.fromDocument(doc) ?? QuestionPaper.empty;
  }
}
