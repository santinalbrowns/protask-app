import 'package:app/chat/models/new_chat_args.dart';
import 'package:app/chat/view/new_chat_page.dart';
import 'package:app/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/auth/auth.dart';
import 'package:app/chat/chat.dart';
import 'package:app/chat/models/models.dart';
import 'package:app/chats/bloc/chats_bloc.dart';
import 'package:app/dashboard/bloc/projects_bloc.dart';
import 'package:app/home/view/home_page.dart';
import 'package:app/login/view/login_page.dart';
import 'package:app/project/bloc/project_bloc.dart';
import 'package:app/project/models/models.dart';
import 'package:app/project/project.dart';
import 'package:app/repo/auth_repo.dart';
import 'package:app/repo/chat_repo.dart';
import 'package:app/repo/project_repo.dart';
import 'package:app/repo/task_repo.dart';
import 'package:app/repo/user_repo.dart';
import 'package:app/splash/splash.dart';
import 'package:app/task/models/task_args.dart';
import 'package:app/task/view/add_task_page.dart';
import 'package:app/tasks/bloc/tasks_bloc.dart';
import 'package:app/tasks/view/tasks_page.dart';
import 'package:app/users/users.dart';

class App extends StatelessWidget {
  final AuthRepo authRepo;
  final UserRepo userRepo;
  final ChatRepo chatRepo;

  const App({
    Key? key,
    required this.authRepo,
    required this.userRepo,
    required this.chatRepo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepo: authRepo,
            userRepo: userRepo,
          )..add(AuthBootstrap()),
        ),
        BlocProvider(
          create: (context) => ChatsBloc(chatRepo)..add(ChatsLoad()),
        ),
        BlocProvider(
          create: (context) => ProjectsBloc(ProjectRepo()),
        ),
        BlocProvider(
          create: (context) =>
              ProjectBloc(projectRepo: ProjectRepo(), userRepo: UserRepo()),
        ),
        BlocProvider(
          create: (context) => TasksBloc(TaskRepo()),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              _navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  ModalRoute.withName(HomePage.route));
            }

            if (state is AuthAuthenticated) {
              _navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                ModalRoute.withName(HomePage.route),
              );
            }

            if (state is AuthUnauthenticated) {
              _navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  ModalRoute.withName(LoginPage.route));
            }
          },
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == SplashPage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return const SplashPage();
            },
          );
        }

        if (settings.name == HomePage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return const HomePage();
            },
          );
        }

        if (settings.name == ChatPage.route) {
          final args = settings.arguments as ChatArgs;

          return MaterialPageRoute(
            builder: (context) {
              return ChatPage(
                user: args.user,
                chat: args.chat,
              );
            },
          );
        }

        if (settings.name == NewChatPage.route) {
          final args = settings.arguments as NewChatArgs;

          return MaterialPageRoute(
            builder: (context) {
              return NewChatPage(user: args.to);
            },
          );
        }

        if (settings.name == UsersPage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return const UsersPage();
            },
          );
        }

        if (settings.name == SelectContactPage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return const SelectContactPage();
            },
          );
        }

        if (settings.name == SelectMembersPage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return const SelectMembersPage();
            },
          );
        }

        if (settings.name == ProjectPage.route) {
          final args = settings.arguments as ProjectArgs;

          return MaterialPageRoute(
            builder: (context) {
              return ProjectPage(
                id: args.id,
              );
            },
          );
        }

        if (settings.name == AddProjectPage.route) {
          return MaterialPageRoute(
            builder: (content) {
              return const AddProjectPage();
            },
          );
        }

        if (settings.name == EditProjectPage.route) {
          final project = settings.arguments as EditProjectPageArgs;

          return MaterialPageRoute(
            builder: (content) {
              return EditProjectPage(
                id: project.id,
                name: project.name,
                description: project.description,
                due: project.due,
              );
            },
          );
        }

        if (settings.name == TasksPage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return const TasksPage();
            },
          );
        }

        if (settings.name == RegisterPage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return const RegisterPage();
            },
          );
        }

        if (settings.name == AddTaskPage.route) {
          final args = settings.arguments as TaskArgs;
          return MaterialPageRoute(
            builder: (context) {
              return AddTaskPage(
                project: args.project,
              );
            },
          );
        }

        assert(false, 'Need to implement ${settings.name}');

        return null;
      },
    );
  }
}
