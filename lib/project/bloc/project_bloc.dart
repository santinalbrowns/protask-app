import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:app/models/models.dart';
import 'package:app/repo/project_repo.dart';
import 'package:app/repo/user_repo.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepo projectRepo;
  final UserRepo userRepo;
  ProjectBloc({required this.projectRepo, required this.userRepo})
      : super(ProjectInitial()) {
    on<ProjectEvent>((event, emit) async {
      if (event is AddProject) {
        try {
          final project = await projectRepo.create(
            name: event.name,
            description: event.description,
            due: event.due.toUtc().toString(),
          );

          emit(ProjectCreated(project));
        } catch (e) {
          debugPrint(e.toString());
          emit(ProjectError(e.toString()));
        }
      }

      if (event is GetProject) {
        try {
          final project = await projectRepo.getOne(event.id);

          final tasks = await projectRepo.getTasks(event.id);

          final user = await userRepo.getUser();

          emit(ProjectLoaded(project: project, tasks: tasks, user: user));
        } catch (e) {
          emit(ProjectError(e.toString()));
        }
      }

      if (event is DeleteProject) {
        try {
          await projectRepo.delete(event.id);

          emit(ProjectDeleted());
        } catch (e) {
          emit(ProjectDeleteError(e.toString()));
        }
      }

      if (event is UpdatedProject) {
        try {
          final project = await projectRepo.update(event.id, event.body);

          emit(ProjectUpdated(project));
        } catch (e) {
          emit(ProjectError(e.toString()));
        }
      }
    });
  }
}
