import 'package:exam_students/models/models.dart';
import 'package:exam_students/repositories/repositories.dart';
import 'package:exam_students/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/question_paper_cubit.dart';

class QuestionPaperScreenArgs {
  final Class classroom;
  final int setIndex;

  QuestionPaperScreenArgs({required this.classroom, required this.setIndex});
}

class QuestionPaperScreen extends StatelessWidget {
  static const String routeName = '/createQuestionPaper';

  QuestionPaperScreen({Key? key}) : super(key: key);

  static Route route({required QuestionPaperScreenArgs args}) {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<QuestionPaperBloc>(
              create: (context) => QuestionPaperBloc(
                  questionPaperRepository:
                      context.read<QuestionPaperRepository>())
                ..add(QuestionPaperLoadUser(
                    classroom: args.classroom,
                    setIndex: args.setIndex,
                    questionIndex: -1,
                    sections: [],
                    sectionIndex: -1)),
              child: QuestionPaperScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<QuestionPaperBloc, QuestionPaperState>(
          listener: (context, state) {
            if (state.status == QuestionPaperStatus.success) {
              // _formKey.currentState?.reset();
              // context.read<QuestionPaperCubit>().reset();
            } else if (state.status == QuestionPaperStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Question paper'),
                  actions: [
                    TextButton(
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () => {},
                    )
                  ],
                ),
                bottomNavigationBar: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: bottomTools(context: context, state: state),
                    )),
                body: _buildBody(context: context, state: state));
          },
        ),
      ),
    );
  }

  Widget _buildBody(
      {required BuildContext context, required QuestionPaperState state}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (state.status == QuestionPaperStatus.submitting)
            const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_section(state, context)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(QuestionPaperState state, BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const Divider(height: 4, thickness: 1),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.sections.length,
      itemBuilder: (sectionContext, sIndex) {
        return GestureDetector(
          onTap: () => context.read<QuestionPaperBloc>().selectSection(sIndex),
          child: Column(
            children: [
              textViewField(
                hintText: 'Class name',
                onChanged: (value) => context
                    .read<QuestionPaperBloc>()
                    .sectionTitleChanged(
                        value: value,
                        sectionIndex: sIndex,
                        sections: state.sections),
              ),
              const SizedBox(height: 6),
              _question(state, sIndex, context)
            ],
          ),
        );
      },
    );
  }

  Widget _question(QuestionPaperState state, int sIndex, BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.sections[sIndex].questions.length,
      itemBuilder: (questionContext, questionIndex) {
        return GestureDetector(
          onTap: () =>
              context.read<QuestionPaperBloc>().selectQuestion(questionIndex),
          child: _questionWidget(
              type: state.sections[sIndex].questions[questionIndex].type,
              question: state.sections[sIndex].questions[questionIndex],
              sectionIndex: sIndex,
              questionIndex: questionIndex,
              context: context),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          addVerticalSpace(8),
    );
  }

  Widget _questionWidget(
      {required QuestionType type,
      required Question question,
      required int sectionIndex,
      required int questionIndex,
      required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          if (question.isQuestion) textViewField(hintText: 'Question'),
          DropdownButton<String>(
            value: dropdownValues[question.type],
            onChanged: (newValue) {
              context.read<QuestionPaperBloc>().questionTypeChanged(
                    type: dropdownValues.keys.firstWhere(
                        (k) => dropdownValues[k] == newValue,
                        orElse: () => QuestionType.choice),
                    sectionIndex: sectionIndex,
                    questionIndex: questionIndex,
                  );
            },
            items: dropdownValues.keys
                .map<DropdownMenuItem<String>>((QuestionType value) {
              return DropdownMenuItem<String>(
                value: dropdownValues[value],
                child: Text(dropdownValues[value]!),
              );
            }).toList(),
          ),
          _questionChoiceWidget(question)
        ],
      ),
    );
  }

  Widget _questionChoiceWidget(Question question) {
    switch (question.type) {
      case QuestionType.choice:
        return choiceWidget(question);
      case QuestionType.titleAndDescription:
        return titleAndDescriptionWidget(question);
      case QuestionType.addFile:
        return addFileWidget(question);
      case QuestionType.checkBox:
        return checkBoxWidget(question);
      case QuestionType.dropdown:
        return dropdownWidget(question);
      case QuestionType.shortAnswer:
        return shortAnswerWidget(question);
      case QuestionType.paragraph:
        return paragraphWidget(question);
      case QuestionType.image:
        return imageWidget(question);
      case QuestionType.video:
        return videoWidget(question);
      default:
        return Container();
    }
  }
}
