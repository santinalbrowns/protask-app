import 'dart:math';

import 'package:app/chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:app/chat/chat.dart';
import 'package:app/chat/models/chat_args.dart';
import 'package:app/chats/bloc/chats_bloc.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  date(String date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final sentDate = DateTime.parse(date);
    final yess = DateTime(sentDate.year, sentDate.month, sentDate.day);

    final check = now.difference(yess).inHours;

    if (yess == today) {
      return Jiffy(date).jm;
    }

    if (check > 24 && check <= 48) {
      return Jiffy(date).fromNow();
    }

    if (check > 48 && check <= 168) {
      return Jiffy(date).EEEE;
    }

    if (check > 168) {
      // show 7/8/2022
      return Jiffy(date).MMMEd;
    }

    if (check > 8760) {
      return Jiffy(date).yMd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SelectContactPage.route);
                },
                icon: const Icon(Icons.add),
                color: Colors.blueAccent,
              )
            ],
            title: const Text(
              'Chats',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            pinned: true,
            floating: true,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[100],
                  ),
                  child: const TextField(
                    /* style: TextStyle(
                      color: Colors.white,
                    ), */
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 40,
                      ),
                      icon: Icon(
                        Icons.search,
                        //color: Colors.white,
                      ),
                      hintText: 'Search...',
                      /* hintStyle: TextStyle(
                        color: Colors.white,
                      ), */
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<ChatsBloc, ChatsState>(
            builder: (context, state) {
              if (state is ChatsLoaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          backgroundImage: state.chats[index].image.isEmpty
                              ? null
                              : NetworkImage(state.chats[index].image),
                          child: state.chats[index].image.isNotEmpty
                              ? null
                              : Text(
                                  state.chats[index].prefix,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        title: Text(
                          state.chats[index].name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          state.chats[index].message,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(date(state.chats[index].time)),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChatPage.route,
                            arguments: ChatArgs(
                              chat: state.chats[index],
                            ),
                          );
                        },
                      );
                    },
                    childCount: state.chats.length,
                  ),
                );
              }

              if (state is ChatsError) {
                return const SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Text('Something went wrong!'),
                  )),
                );
              }

              return const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_ic_call_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCAllPage(),
            ),
          );
        },
      ),
    );
  }
}

class OnlineUsersWidget extends StatelessWidget {
  const OnlineUsersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Text('Online Users')],
    );
  }
}
