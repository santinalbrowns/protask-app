import 'package:app/account/bloc/account_bloc.dart';
import 'package:app/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  late String firstname = '';
  late String lastname = '';
  late String email = '';
  late String password = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.account_box_rounded,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    hintText: 'First name',
                  ),
                  initialValue:
                      state is AccountLoaded ? state.user.firstname : firstname,
                  onChanged: (value) {
                    setState(() {
                      firstname = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.account_box_rounded,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    hintText: 'Last name',
                  ),
                  initialValue:
                      state is AccountLoaded ? state.user.lastname : lastname,
                  onChanged: (value) {
                    setState(() {
                      lastname = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email_rounded,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    hintText: 'Email',
                  ),
                  initialValue:
                      state is AccountLoaded ? state.user.email : email,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.lock_rounded,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.all(12)),
              BlocConsumer<AccountBloc, AccountState>(
                listener: (context, state) {
                  if (state is AccountDeleted) {
                    context.read<AuthBloc>().add(AuthLogout());
                  }

                  if (state is AccountUpdated) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          content: Text('Account has been updated')));
                  }
                },
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      context.read<AccountBloc>().add(
                            UpdateAccount(
                              firstname: firstname,
                              lastname: lastname,
                              email: email,
                              password: password,
                            ),
                          );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: state is AccountLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocListener<AccountBloc, AccountState>(
                listener: (context, state) {
                  if (state is AccountDeleted) {
                    context.read<AuthBloc>().add(AuthLogout());
                  }
                },
                child: TextButton(
                    onPressed: () {
                      context.read<AccountBloc>().add(DeleteAccount());
                    },
                    child: const Text(
                      "Delete account",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )),
              )
            ],
          ),
        );
      },
    );
  }
}
