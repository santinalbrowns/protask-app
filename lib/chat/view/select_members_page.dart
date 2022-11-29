import 'package:flutter/material.dart';
import 'package:app/chat/view/chat_page.dart';

class SelectMembersPage extends StatefulWidget {
  const SelectMembersPage({Key? key}) : super(key: key);

  static const route = '/selectmembers';

  @override
  State<SelectMembersPage> createState() => _SelectMembersPageState();
}

class _SelectMembersPageState extends State<SelectMembersPage> {
  final users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            //backgroundColor: Colors.white,
            title: Text('Select members'),
            pinned: true,
            floating: true,
            elevation: 0,
            /* bottom: PreferredSize(
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
            ), */
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    //backgroundImage: NetworkImage(chatsData[index].image),
                    child: Text(
                      "${users[index].firstname[0]}${users[index].lastname[0]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  title: Text(
                    "${users[index].firstname} ${users[index].lastname}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(users[index].email),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      ChatPage.route,
                    );
                  },
                );
              },
              childCount: users.length,
            ),
          ),
        ],
      ),
    );
  }
}
