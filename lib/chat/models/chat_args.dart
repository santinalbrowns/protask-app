import 'package:app/models/models.dart';

class ChatArgs {
  final Chat chat;
  final User? user;
  final List<Message>? messages;
  const ChatArgs({
    required this.chat,
    this.user,
    this.messages,
  });
}
