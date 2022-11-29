import 'dart:math' as math;

import 'package:app/account/account.dart';
import 'package:app/auth/auth.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:app/chats/chats.dart';
import 'package:app/dashboard/dashboard.dart';
import 'package:app/tasks/view/tasks_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  /* static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  } */

  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = const <Widget>[
    DashboardPage(),
    TasksPage(),
    ChatsPage(),
    AccountPage(),
  ];

  int _selectedIndex = 0;
  User? user;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return ZegoUIKitPrebuiltCallWithInvitation(
            appID: 2041538569,
            appSign:
                "d0aa013db82de609c8eb7f66348713172f4b2a3afe0c8dd8ddc171035c2b5599",
            userID: state.user.id,
            userName: "${state.user.firstname} ${state.user.firstname}",
            plugins: [ZegoUIKitSignalingPlugin()],
            child: Scaffold(
              body: _pages.elementAt(_selectedIndex),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_rounded),
                    label: 'Analytics',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment),
                    label: 'Projects',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Account',
                  )
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTap,
                selectedFontSize: 12.0,
                //selectedItemColor: Colors.amber[800],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: Text('Something went wrong!')),
        );
      },
    );
  }
}
