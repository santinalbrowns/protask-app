import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/models/models.dart';
import 'package:app/repo/task_repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(this.taskRepo) : super(TaskInitial()) {
    on<TaskEvent>((event, emit) async {
      if (event is AddTask) {
        try {
          final task = await taskRepo.create(
            name: event.name,
            project: event.project,
            user: event.user,
            due: event.due.toUtc().toString(),
          );

          emit(TaskCreated(task));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      }
    });
  }

  final TaskRepo taskRepo;
}
