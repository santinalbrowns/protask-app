import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:app/models/models.dart';
import 'package:app/project/bloc/project_bloc.dart';
import 'package:app/repo/task_repo.dart';
import 'package:app/repo/user_repo.dart';
import 'package:app/task/bloc/task_bloc.dart';
import 'package:app/users/bloc/users_bloc.dart';

class AddTaskPage extends StatefulWidget {
  final Project project;
  const AddTaskPage({Key? key, required this.project}) : super(key: key);

  static const route = '/task/add';

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late DateTime due = DateTime.now();
  late String name = '';
  late User user;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc(TaskRepo()),
        ),
        BlocProvider(
          create: (context) => UsersBloc(repo: UserRepo())..add(GetUsers()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
          title: const Text(
            'Create task',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskError) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is TaskCreated) {
                  context
                      .read<ProjectBloc>()
                      .add(GetProject(state.task.project));
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //Save task
                      context.read<TaskBloc>().add(AddTask(
                            name: name,
                            project: widget.project.id,
                            user: user.id,
                            due: due,
                          ));
                    }
                  },
                  child: const Text('Save'),
                );
              },
            )
          ],
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 30),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Color.fromARGB(255, 151, 151, 151)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dute date',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.blueAccent,
                        ),
                        title: Text(Jiffy(due).yMMMMd),
                        horizontalTitleGap: 0,
                        trailing: const Icon(Icons.keyboard_arrow_down),
                        onTap: _pickDate,
                      ),
                    ],
                  ),
                ),
                BlocConsumer<UsersBloc, UsersState>(
                  listener: (context, state) {
                    if (state is UsersLoaded) {
                      setState(() {
                        user = state.users[0];
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is UsersLoaded) {
                      return DropdownButton(
                        value: user,
                        items: state.users
                            .map((user) => DropdownMenuItem<User>(
                                  value: user,
                                  child: Text(
                                      '${user.firstname} ${user.lastname}'),
                                ))
                            .toList(),
                        onChanged: (value) => dropdownCallback(value as User),
                        //value: user,
                        //isExpanded: true,
                      );
                    }

                    return Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: due,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (date != null) {
      setState(() {
        due = date;
      });
    }
  }

  void dropdownCallback(User? value) {
    if (value is User) {
      setState(() {
        user = value;
      });
    }
  }
}
