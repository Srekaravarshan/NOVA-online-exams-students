part of 'question_paper_cubit.dart';

abstract class QuestionPaperEvent {
  const QuestionPaperEvent();
}

class QuestionPaperLoadUser extends QuestionPaperEvent {
  final Class classroom;
  final int setIndex;
  final List sections;
  final int sectionIndex, questionIndex;

  const QuestionPaperLoadUser(
      {required this.setIndex,
      required this.classroom,
      required this.sections,
      required this.questionIndex,
      required this.sectionIndex});
}

class AddQuestion extends QuestionPaperEvent {
  final List sections;
  final int sectionIndex, questionIndex;

  const AddQuestion(
      {required this.sectionIndex,
      required this.sections,
      required this.questionIndex});
}

class AddSection extends QuestionPaperEvent {
  final List sections;

  const AddSection({required this.sections});
}

class AddTitleAndDescription extends QuestionPaperEvent {
  final List sections;
  final int sectionIndex, questionIndex;
  const AddTitleAndDescription(
      {required this.sections,
      required this.sectionIndex,
      required this.questionIndex});
}

class AddImage extends QuestionPaperEvent {
  const AddImage();
}

class AddVideo extends QuestionPaperEvent {
  const AddVideo();
}
