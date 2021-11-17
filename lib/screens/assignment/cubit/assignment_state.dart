part of 'assignment_cubit.dart';

enum AssignmentStatus { initial, loading, loaded, error }

class AssignmentState extends Equatable {
  final AssignmentStatus status;
  final Failure failure;

  const AssignmentState({required this.failure, required this.status});

  factory AssignmentState.initial() {
    return const AssignmentState(
        status: AssignmentStatus.initial, failure: Failure());
  }

  @override
  List<Object?> get props => [];
}
