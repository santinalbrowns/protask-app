part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectCreated extends ProjectState {
  final Project project;

  const ProjectCreated(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectLoaded extends ProjectState {
  final Project project;
  final List<Task> tasks;
  final User user;

  const ProjectLoaded(
      {required this.project, required this.tasks, required this.user});

  @override
  List<Object> get props => [project, tasks, user];
}

class ProjectUpdated extends ProjectState {
  final Project project;
  const ProjectUpdated(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectLoading extends ProjectState {}

class ProjectTasks extends ProjectState {
  final List<Task> tasks;

  const ProjectTasks(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class ProjectTasksLoading extends ProjectState {}

class ProjectError extends ProjectState {
  final String message;
  const ProjectError(this.message);

  @override
  List<Object> get props => [message];
}

class ProjectDeleted extends ProjectState {}

class ProjectTasksError extends ProjectState {
  final String message;

  const ProjectTasksError(this.message);

  @override
  List<Object> get props => [message];
}

class ProjectDeleteError extends ProjectState {
  final String message;

  const ProjectDeleteError(this.message);

  @override
  List<Object> get props => [message];
}
