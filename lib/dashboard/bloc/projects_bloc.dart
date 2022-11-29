import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/models/models.dart';
import 'package:app/repo/project_repo.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(this.projectRepo) : super(ProjectsInitial()) {
    on<ProjectsEvent>((event, emit) async {
      if (event is GetProjects) {
        final projects = await projectRepo.getAll();

        emit(ProjectsLoaded(projects));
      }

      if (event is ReloadProjects) {
        final projects = await projectRepo.getAll();

        emit(ProjectsLoaded(projects));
      }
    });
  }

  final ProjectRepo projectRepo;
}
