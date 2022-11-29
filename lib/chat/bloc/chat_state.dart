part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatMessages extends ChatState {
  final List<Message> messages;

  const ChatMessages(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatNewMessage extends ChatState {
  final Message message;

  const ChatNewMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ChatLoading extends ChatState {}

class ChatCreated extends ChatState {
  final Message message;

  const ChatCreated(this.message);

  @override
  List<Object> get props => [message];
}
