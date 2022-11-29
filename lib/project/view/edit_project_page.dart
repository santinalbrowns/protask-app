import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:app/project/bloc/project_bloc.dart';

class EditProjectPage extends StatefulWidget {
  const EditProjectPage({
    Key? key,
    required this.id,
    required this.name,
    this.description,
    required this.due,
  }) : super(key: key);

  static const route = '/project/edit';

  final String id;
  final String name;
  final String? description;
  final DateTime due;

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  late DateTime due = DateTime.now();
  late String name = '';
  late String description = '';

  @override
  void initState() {
    name = widget.name;
    description = widget.description!;
    due = widget.due;

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit project'),
        actions: [
          BlocConsumer<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectError) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }

              if (state is ProjectUpdated) {
                context.read<ProjectBloc>().add(GetProject(state.project.id));
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //Update project
                    final id = widget.id;
                    final body = <String, dynamic>{
                      'name': name,
                      'description': description,
                      'due': due.toIso8601String(),
                    };

                    context.read<ProjectBloc>().add(UpdatedProject(id, body));
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
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
                initialValue: name,
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
                initialValue: description,
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
