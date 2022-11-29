import 'package:app/models/models.dart';
import 'package:app/repo/user_repo.dart';
import 'package:app/users/bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AddCAllPage extends StatelessWidget {
  const AddCAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(repo: UserRepo())..add(GetUsers()),
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              //backgroundColor: Colors.white,
              title: Text('Select contact'),
              pinned: true,
              floating: true,
              elevation: 0,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.people_outline_outlined),
                    //backgroundImage: NetworkImage(chatsData[index].image),
                  ),
                  title: const Text(
                    'New team',
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    /* Navigator.pushReplacementNamed(
                          context, SelectMembersPage.route); */
                  },
                ),
              ),
            ),
            BlocConsumer<UsersBloc, UsersState>(
              listener: (context, state) {
                if (state is UsersError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is UsersLoaded) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Contact(user: state.users[index]);
                      },
                      childCount: state.users.length,
                    ),
                  );
                }

                if (state is UsersEmpty) {
                  return const SliverToBoxAdapter(
                    child: Text('No contacts'),
                  );
                }

                if (state is UsersLoading) {
                  return const SliverToBoxAdapter(
                    child: Text('Loading'),
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Text('Something went wrong'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Contact extends StatelessWidget {
  final User user;
  const Contact({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 24,
      tileColor: Colors.white,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey,
        //backgroundImage: NetworkImage(chatsData[index].image),
        child: Text(
          "${user.firstname[0]}${user.lastname[0]}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      title: Text(
        "${user.firstname} ${user.lastname}",
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              callButton(true, context),
              const SizedBox(width: 10),
              callButton(false, context),
            ],
          ),
        ],
      ),
      onTap: () {
        //final

        /* Navigator.pushReplacementNamed(
          context,
          ChatPage.route,
          //arguments: const ChatArgs(),
        ); */
      },
    );
  }

  Widget callButton(bool isVideoCall, BuildContext context) {
    return ZegoStartCallInvitationButton(
      isVideoCall: isVideoCall,
      invitees: [
        ZegoUIKitUser(
          id: user.id,
          name: "${user.firstname} ${user.lastname}",
        ),
      ],
      iconSize: const Size(32, 32),
      buttonSize: const Size(32, 32),
      onPressed: (String code, String message, List<String> errorInvitees) {
        if (errorInvitees.isNotEmpty) {
          String userIDs = "";
          for (int index = 0; index < errorInvitees.length; index++) {
            if (index >= 5) {
              userIDs += '... ';
              break;
            }

            var userID = errorInvitees.elementAt(index);
            userIDs += '$userID ';
          }
          if (userIDs.isNotEmpty) {
            userIDs = userIDs.substring(0, userIDs.length - 1);
          }

          var message = 'User doesn\'t exist or is offline: $userIDs';
          if (code.isNotEmpty) {
            message += ', code: $code, message:$message';
          }
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content:
                    Text('Sorry, user is offline you can\'t make a call!')));
        } else if (code.isNotEmpty) {
          showToast(
            'code: $code, message:$message',
            position: StyledToastPosition.top,
            context: context,
          );
        }
      },
    );
  }
}
