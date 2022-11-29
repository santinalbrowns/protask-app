part of 'projects_bloc.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class GetProjects extends ProjectsEvent {}

class ReloadProjects extends ProjectsEvent {}
