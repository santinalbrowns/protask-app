import 'package:app/register/bloc/register_bloc.dart';
import 'package:app/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:app/register/view/register_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const route = '/register';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(userRepo: UserRepo()),
      child: Scaffold(
        //backgroundColor: Colors.blue,
        appBar: AppBar(
          title: const Text('Register'),
          elevation: 0,
        ),
        body: const Padding(
          padding: EdgeInsets.all(12.0),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
