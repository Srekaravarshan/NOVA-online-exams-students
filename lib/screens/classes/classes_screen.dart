import 'package:exam_students/blocs/blocs.dart';
import 'package:exam_students/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';
import 'cubit/classes_cubit.dart';

class ClassesScreenArgs {
  final String userId;

  ClassesScreenArgs({required this.userId});
}

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassesBloc, ClassesState>(listener: (context, state) {
      if (state.status == ClassStatus.error) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(content: state.failure.message),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Classes'),
        ),
        body: _buildBody(state),
      );
    });
  }

  Widget _buildBody(ClassesState state) {
    switch (state.status) {
      case ClassStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ClassesBloc>().add(ClassesLoadUser(
                userId: context.read<AuthBloc>().state.user!.uid));
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                addVerticalSpace(15),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(ClassroomScreen.routeName,
                          arguments: ClassroomScreenArgs(
                              classId: state.classes[index].id));
                    },
                    child: classCard(
                        i: index,
                        title: state.classes[index].name,
                        description: state.classes[index].teachers[0] ?? '',
                        context: context),
                  ),
                  shrinkWrap: true,
                  itemCount: state.classes.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      addVerticalSpace(15),
                ),
              ],
            ),
          ),
        );
    }
  }
}
