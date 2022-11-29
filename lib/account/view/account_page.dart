import 'package:app/account/bloc/account_bloc.dart';
import 'package:app/account/view/user_form.dart';
import 'package:app/auth/auth.dart';
import 'package:app/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Account"),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogout());
                },
                icon: const Icon(Icons.logout_rounded),
              )
            ],
          ),
          body: BlocProvider(
            create: (context) =>
                AccountBloc(userRepo: UserRepo())..add(GetAccount()),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: UserForm(),
            ),
          ),
        );
      },
    );
  }
}
