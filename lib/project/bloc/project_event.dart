part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class AddProject extends ProjectEvent {
  final String name;
  final String description;
  final DateTime due;

  const AddProject(
    this.name,
    this.description,
    this.due,
  );

  @override
  List<Object> get props => [name, description, due];
}

class UpdatedProject extends ProjectEvent {
  final String id;
  final Map<String, dynamic> body;

  const UpdatedProject(this.id, this.body);

  @override
  List<Object> get props => [id, body];
}

class GetProject extends ProjectEvent {
  final String id;
  const GetProject(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteProject extends ProjectEvent {
  final String id;

  const DeleteProject(this.id);

  @override
  List<Object> get props => [id];
}

class GetProjectTasks extends ProjectEvent {
  final String id;
  const GetProjectTasks(this.id);

  @override
  List<Object> get props => [id];
}
