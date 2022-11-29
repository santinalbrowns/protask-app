part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class GetCompletedTasks extends TasksEvent {}

class GetIncompleteTasks extends TasksEvent {}

class GetAllTasks extends TasksEvent {}

class MarkTaskCompleted extends TasksEvent {
  final String id;

  const MarkTaskCompleted(this.id);

  @override
  List<Object> get props => [id];
}

class MarkTaskIncomplete extends TasksEvent {
  final String id;

  const MarkTaskIncomplete(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateTask extends TasksEvent {
  final String id;
  final Map<String, dynamic> body;

  const UpdateTask(this.id, this.body);

  @override
  List<Object> get props => [id, body];
}
