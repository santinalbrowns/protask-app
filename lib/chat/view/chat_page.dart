import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app/chat/chat.dart';
import 'package:app/models/models.dart';

class ChatPage extends StatefulWidget {
  final User? user;
  final Chat chat;

  const ChatPage({Key? key, this.user, required this.chat}) : super(key: key);

  static const route = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  final List<Message> messages = [];

  String text = '';

  void _addMessage() {
    messages.add(
      Message(
        id: '',
        text: text,
        from: '',
        isSender: true,
        time: DateTime.now(),
      ),
    );

    _textEditingController.clear();
    _scrollToBottom();
  }

  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _scrollListener() {
    _firstAutoscrollExecuted = true;

    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _shouldAutoscroll = true;
    } else {
      _shouldAutoscroll = false;
    }
  }

  @override
  void initState() {
    messages.addAll(widget.chat.messages);

    _scrollController.addListener(_scrollListener);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (_scrollController.hasClients && _shouldAutoscroll) {
          _scrollToBottom();
        }

        if (!_firstAutoscrollExecuted && _scrollController.hasClients) {
          _scrollToBottom();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as ChatPageArgs;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: ListTile(
          horizontalTitleGap: 10.0,
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent,
            child: Text(
              "SB",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          title: const Text(
            'Santinal Browns',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: const Text(
            'santinal@gmail.com',
            style: TextStyle(
              color: Color.fromARGB(255, 242, 241, 241),
            ),
          ),
          onTap: () {},
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete chat'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: messages.length,
                padding: const EdgeInsets.only(top: 30),
                itemBuilder: (context, index) =>
                    MessageView(message: messages[index]),
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 241, 241, 241),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: TextField(
                          onChanged: (value) {
                            setState(() {
                              text = value;
                            });
                          },
                          controller: _textEditingController,
                          minLines: 1,
                          maxLines: 20,
                          decoration: const InputDecoration(
                            hintText: 'Write a message...',
                            border: InputBorder.none,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => _addMessage(),
                          icon: const Icon(
                            Icons.send,
                            color: Colors.lightBlue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
