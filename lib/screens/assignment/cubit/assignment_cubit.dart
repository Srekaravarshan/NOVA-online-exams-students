import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam_students/models/models.dart';

part 'assignment_state.dart';

class AssignmentCubit extends Cubit<AssignmentState> {
  AssignmentCubit() : super(AssignmentState.initial());
}
