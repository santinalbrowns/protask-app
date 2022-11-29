part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskCreated extends TaskState {
  final Task task;

  const TaskCreated(this.task);
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);
}

class TaskLoading extends TaskState {}
