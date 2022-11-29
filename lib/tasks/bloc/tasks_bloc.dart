import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/models/models.dart';
import 'package:app/repo/task_repo.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(this.taskRepo) : super(TasksInitial()) {
    on<TasksEvent>((event, emit) async {
      if (event is GetCompletedTasks) {
        try {
          final tasks = await taskRepo.getCompleted();

          if (tasks.isEmpty) {
            emit(EmptyTasks());
          } else {
            emit(TasksCompletedList(tasks));
          }
        } catch (e) {
          emit(TasksError(e.toString()));
        }
      }

      if (event is GetIncompleteTasks) {
        try {
          final tasks = await taskRepo.getIncomplete();

          if (tasks.isEmpty) {
            emit(EmptyTasks());
          } else {
            emit(TasksIncompleteList(tasks));
          }
        } catch (e) {
          emit(TasksError(e.toString()));
        }
      }

      if (event is GetAllTasks) {
        try {
          final tasks = await taskRepo.getAll();

          if (tasks.isEmpty) {
            emit(EmptyTasks());
          } else {
            emit(TasksLoaded(tasks));
          }
        } catch (e) {
          emit(TasksError(e.toString()));
        }
      }

      if (event is UpdateTask) {
        try {
          await taskRepo.update(event.id, event.body);

          final tasks = await taskRepo.getAll();

          if (tasks.isEmpty) {
            emit(EmptyTasks());
          } else {
            emit(TasksLoaded(tasks));
          }
        } catch (e) {
          emit(TasksError(e.toString()));
        }
      }
    });
  }

  final TaskRepo taskRepo;
}
