import 'package:app/chat/view/message_view.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key, required this.user});

  static const route = '/new_chat';

  final User user;

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
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
    //messages.addAll(widget.chat.messages);

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
          leading: CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent,
            child: Text(
              "${widget.user.firstname[0]}${widget.user.lastname[0]}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          title: Text(
            '${widget.user.firstname} ${widget.user.lastname}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            widget.user.email,
            style: const TextStyle(
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
