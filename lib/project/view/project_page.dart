import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:app/dashboard/bloc/projects_bloc.dart';
import 'package:app/project/bloc/project_bloc.dart';
import 'package:app/project/models/models.dart';
import 'package:app/project/view/edit_project_page.dart';
import 'package:app/task/models/task_args.dart';
import 'package:app/task/view/add_task_page.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key, required this.id}) : super(key: key);

  final String id;

  static const route = '/project';

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final String title = 'Project details';

  final String name = 'Web designing & development';

  @override
  Widget build(BuildContext context) {
    context.read<ProjectBloc>().add(GetProject(widget.id));
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text(title),
            actions: [
              BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectLoaded) {
                    if (state.project.user.id == state.user.id) {
                      return IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            EditProjectPage.route,
                            arguments: EditProjectPageArgs(
                              id: state.project.id,
                              name: state.project.name,
                              description: state.project.description,
                              due: state.project.due,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_note),
                      );
                    }
                  }

                  return Container();
                },
              ),
              BlocConsumer<ProjectBloc, ProjectState>(
                listener: (context, state) {
                  if (state is ProjectDeleteError) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(state.message)));
                  }

                  if (state is ProjectDeleted) {
                    context.read<ProjectsBloc>().add(ReloadProjects());
                    Navigator.pop(
                        context, 'Project has been deleted successfully');
                  }
                },
                builder: (context, state) {
                  if (state is ProjectLoaded) {
                    if (state.user.id == state.project.user.id) {
                      return IconButton(
                          onPressed: () {
                            context
                                .read<ProjectBloc>()
                                .add(DeleteProject(widget.id));
                          },
                          icon: const Icon(Icons.delete_outlined));
                    }

                    return Container();
                  }

                  return Container();
                },
              )
            ],
          ),
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              if (state is ProjectLoaded) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.project.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 16.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  Jiffy(state.project.createdAt).yMMMMd,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          state.project.description,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return LinearPercentIndicator(
                              barRadius: const Radius.circular(2),
                              padding: const EdgeInsets.all(0),
                              lineHeight: 20,
                              percent: state.project.progress,
                              center: Text(
                                  "${(state.project.progress * 100).ceil().toString()}%"),
                              backgroundColor: Colors.blue.withOpacity(0.3),
                              progressColor: Colors.blue,
                            );
                          }),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 16.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Due date: ',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  Jiffy(state.project.due).yMMMMd,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Created by: ${state.user.firstname} ${state.user.lastname}",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        //const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                );
              }

              if (state is ProjectError) {
                return SliverToBoxAdapter(
                  child: Text(state.message),
                );
              }

              return const SliverToBoxAdapter(
                child: Text('loading...'),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          BlocConsumer<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectTasksError) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is ProjectLoaded) {
                if (state.tasks.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Text(
                        'This project has no tasks. Please create a task',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ListTile(
                        isThreeLine: true,
                        leading: const Icon(Icons.task, size: 40),
                        title: Text(state.tasks[index].name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.tasks[index].completed
                                ? Jiffy(state.tasks[index].due).yMMMEd
                                : 'Due ${Jiffy(state.tasks[index].due).subtract().fromNow()}'),
                            Text(
                                'Assigned to: ${state.tasks[index].user.firstname} ${state.tasks[index].user.lastname}'),
                          ],
                        ),
                        trailing: state.tasks[index].completed
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      );
                    },
                    childCount: state.tasks.length,
                  ),
                );
              }

              return const SliverToBoxAdapter(
                child: Text('Loading...'),
              );
            },
          )
        ],
      ),
      floatingActionButton: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state is ProjectLoaded) {
                Navigator.pushNamed(context, AddTaskPage.route,
                    arguments: TaskArgs(project: state.project));
              }
            },
            child: const Icon(Icons.add_task),
          );
        },
      ),
    );
  }
}
