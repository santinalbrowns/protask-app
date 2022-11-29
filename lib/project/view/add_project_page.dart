import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:app/dashboard/bloc/projects_bloc.dart';
import 'package:app/project/bloc/project_bloc.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key? key}) : super(key: key);

  static const route = '/project/add';

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  late DateTime due = DateTime.now();
  late String name = '';
  late String description = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        title: const Text(
          'Create project',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          BlocConsumer<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectError) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }

              if (state is ProjectCreated) {
                context.read<ProjectsBloc>().add(ReloadProjects());
                Navigator.pop(context,
                    '${state.project.name} project has been created successfully');
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //Save project
                    context
                        .read<ProjectBloc>()
                        .add(AddProject(name, description, due));
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
              TextFormField(
                minLines: 1,
                maxLines: 10,
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
                  //filled: true,
                ),
              ),
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
            ],
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
}
