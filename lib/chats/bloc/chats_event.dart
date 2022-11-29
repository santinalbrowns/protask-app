part of 'chats_bloc.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class ChatsLoad extends ChatsEvent {}

class ChatsData extends ChatsEvent {
  final List<Chat> chats;

  const ChatsData(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatsAdd extends ChatsEvent {
  final Chat chat;

  const ChatsAdd(this.chat);

  @override
  List<Object> get props => [chat];
}
