part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;

  const ProjectsLoaded(this.projects);

  @override
  List<Object> get props => [projects];
}
