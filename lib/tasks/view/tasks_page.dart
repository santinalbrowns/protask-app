import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:app/repo/task_repo.dart';
import 'package:app/tasks/bloc/tasks_bloc.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  static const route = '/project';

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksBloc(TaskRepo())..add(GetAllTasks()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.filter_alt),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: const Text('Clear filter'),
                  onTap: () {
                    context.read<TasksBloc>().add(GetAllTasks());
                  },
                ),
                PopupMenuItem(
                  child: const Text('Completed tasks'),
                  onTap: () {
                    context.read<TasksBloc>().add(GetCompletedTasks());
                  },
                ),
                PopupMenuItem(
                  child: const Text('Incomplete tasks'),
                  onTap: () {
                    context.read<TasksBloc>().add(GetIncompleteTasks());
                  },
                ),
              ],
            )
          ],
        ),
        body: BlocConsumer<TasksBloc, TasksState>(
          listener: (context, state) {
            if (state is TasksError) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is TasksLoaded) {
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: state.tasks[index].completed,
                    onChanged: (value) {
                      final id = state.tasks[index].id;
                      final body = <String, dynamic>{'completed': value!};

                      context.read<TasksBloc>().add(UpdateTask(id, body));
                    },
                    title: Text(state.tasks[index].name),
                    subtitle: Text(state.tasks[index].completed
                        ? Jiffy(state.tasks[index].due).yMMMEd
                        : 'Due ${Jiffy(state.tasks[index].due).subtract().fromNow()}'),
                  );
                },
              );
            }

            if (state is TasksCompletedList) {
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: state.tasks[index].completed,
                    onChanged: (value) {},
                    title: Text(state.tasks[index].name),
                    subtitle: Text(Jiffy(state.tasks[index].due).yMMMEd),
                  );
                },
              );
            }

            if (state is TasksIncompleteList) {
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: state.tasks[index].completed,
                    onChanged: (value) {},
                    title: Text(state.tasks[index].name),
                    subtitle: Text(
                        'Due ${Jiffy(state.tasks[index].due).subtract().fromNow()}'),
                  );
                },
              );
            }

            if (state is EmptyTasks) {
              return const Center(child: Text('No tasks available'));
            }

            return const Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
