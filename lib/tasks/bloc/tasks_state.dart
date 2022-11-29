part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TasksCompletedList extends TasksState {
  final List<Task> tasks;

  const TasksCompletedList(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TasksIncompleteList extends TasksState {
  final List<Task> tasks;

  const TasksIncompleteList(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class EmptyTasks extends TasksState {}

class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object> get props => [message];
}
