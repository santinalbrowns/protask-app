import 'package:app/models/models.dart';

class NewChatArgs {
  final User to;
  final List<Message>? messages;
  const NewChatArgs({
    required this.to,
    this.messages,
  });
}
