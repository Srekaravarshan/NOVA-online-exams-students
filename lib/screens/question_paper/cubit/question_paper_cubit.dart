import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam_students/models/models.dart';
import 'package:exam_students/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

part 'question_paper_event.dart';
part 'question_paper_state.dart';

class QuestionPaperBloc extends Bloc<QuestionPaperEvent, QuestionPaperState> {
  final QuestionPaperRepository _questionPaperRepository;

  QuestionPaperBloc({required QuestionPaperRepository questionPaperRepository})
      : _questionPaperRepository = questionPaperRepository,
        super(QuestionPaperState.initial());

  @override
  Stream<QuestionPaperState> mapEventToState(
    QuestionPaperEvent event,
  ) async* {
    if (event is QuestionPaperLoadUser) {
      yield* _mapQuestionPaperLoadQuestionPaperToState(event);
    } else if (event is AddQuestion) {
      yield* _mapAddQuestionToState(event);
    } else if (event is AddTitleAndDescription) {
      yield* _mapAddTitleAndDescriptionToState(event);
    } else if (event is AddImage) {
      yield* _mapAddImageToState(event);
    } else if (event is AddVideo) {
      yield* _mapAddVideoToState(event);
    } else if (event is AddSection) {
      yield* _mapAddSectionToState(event);
    }
  }

  Stream<QuestionPaperState> _mapQuestionPaperLoadQuestionPaperToState(
    QuestionPaperLoadUser event,
  ) async* {
    yield state.copyWith(status: QuestionPaperStatus.loading);
    try {
      String qpId;
      if (event.classroom.questionPapers[event.setIndex].id == null ||
          event.classroom.questionPapers[event.setIndex].id.trim() == '') {
        qpId = const Uuid().v4();
        // add(QuestionPaperCreate(
        //     classId: event.classroom.id, qpId: qpId, index: event.setIndex));
      } else {
        qpId = event.classroom.questionPapers[event.setIndex].id;
      }
      QuestionPaper questionPaper =
          await _questionPaperRepository.getQuestionPaper(id: qpId);
      yield state.copyWith(
          id: qpId,
          sections: questionPaper.sections,
          set: questionPaper.set,
          mode: questionPaper.mode,
          qpStatus: questionPaper.status);

      if (event.classroom.questionPapers[event.setIndex].id == null ||
          event.classroom.questionPapers[event.setIndex].id.trim() == '') {
        add(AddSection(sections: questionPaper.sections));
        add(AddQuestion(
            sections: questionPaper.sections,
            questionIndex: event.questionIndex,
            sectionIndex: event.sectionIndex));

        yield state.copyWith(status: QuestionPaperStatus.loaded);
      }
    } catch (err) {
      print(err);
      yield state.copyWith(
        status: QuestionPaperStatus.error,
        failure:
            const Failure(message: 'We were unable to load question paper.'),
      );
    }
  }

  Stream<QuestionPaperState> _mapAddSectionToState(
    AddSection event,
  ) async* {
    state.sections.add(Section(title: 'Untitled', questions: [], order: 0));
    yield state.copyWith(
        status: QuestionPaperStatus.initial,
        sectionIndex: state.sectionIndex + 1);
    // print('add section');
    // print(state.sections.length);
    // print(state.sections[state.sectionIndex].questions.length);
  }

  Stream<QuestionPaperState> _mapAddQuestionToState(
    AddQuestion event,
  ) async* {
    // chat.messages = [...chat.messages, message];
    event.sections[event.sectionIndex].questions = [
      ...event.sections[event.sectionIndex].questions,
      Question(
          type: QuestionType.choice,
          questionNo: state.questionIndex + 1,
          description: '',
          options: const [],
          title: '',
          answer: '',
          hasOtherOption: false,
          isQuestion: true,
          otherOption: '',
          file: null)
    ];
    yield state.copyWith(
        sections: event.sections,
        status: QuestionPaperStatus.initial,
        questionIndex: event.questionIndex + 1);
    print('addQuestion');
    print(state.sections.length);
    print(state.sections[state.sectionIndex].questions.length);
  }

  Stream<QuestionPaperState> _mapAddTitleAndDescriptionToState(
    AddTitleAndDescription event,
  ) async* {
    event.sections[event.sectionIndex].questions = [
      ...event.sections[event.sectionIndex].questions,
      Question(
          title: '',
          description: '',
          answer: '',
          isQuestion: false,
          options: [],
          hasOtherOption: false,
          type: QuestionType.titleAndDescription,
          questionNo: 0)
    ];
    yield state.copyWith(status: QuestionPaperStatus.initial);
  }

  Stream<QuestionPaperState> _mapAddImageToState(
    AddImage event,
  ) async* {}

  Stream<QuestionPaperState> _mapAddVideoToState(
    AddVideo event,
  ) async* {}

  Stream<QuestionPaperState> questionChanged(
      {required String value,
      required int sectionIndex,
      required int questionIndex}) async* {
    (state.sections[sectionIndex].questions[questionIndex].title = value);
    yield (state.copyWith(status: QuestionPaperStatus.initial));
  }

  Stream<QuestionPaperState> questionTypeChanged(
      {required QuestionType type,
      required int sectionIndex,
      required int questionIndex}) async* {
    print('questionTypeChanged');
    print(type.toString());
    (state.sections[sectionIndex].questions[questionIndex].type = type);
    yield (state.copyWith(status: QuestionPaperStatus.initial));
  }

  Stream<QuestionPaperState> selectSection(int index) async* {
    yield state.copyWith(sectionIndex: index);
  }

  Stream<QuestionPaperState> selectQuestion(int index) async* {
    yield state.copyWith(questionIndex: index);
  }

  Stream<QuestionPaperState> sectionTitleChanged(
      {required String value,
      required int sectionIndex,
      required List sections}) async* {
    sections[sectionIndex].title = value;
    yield state.copyWith(sections: sections, questionIndex: sectionIndex);
  }

  Future<void> save() async {}
}
