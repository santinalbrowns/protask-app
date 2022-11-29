part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChatMessages extends ChatEvent {
  final List<Message> messages;

  const GetChatMessages(this.messages);

  @override
  List<Object> get props => [messages];
}

class CreateChat extends ChatEvent {
  final Message message;

  const CreateChat(this.message);

  @override
  List<Object> get props => [message];
}
