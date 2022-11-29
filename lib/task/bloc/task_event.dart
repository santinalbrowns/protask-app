part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTask extends TaskEvent {
  final String name;
  final String project; // Project Id
  final DateTime due;
  final String user; // Assigned user's id

  const AddTask({
    required this.name,
    required this.project,
    required this.user,
    required this.due,
  });

  @override
  List<Object> get props => [name, project, user, due];
}
