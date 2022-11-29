part of 'chats_bloc.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chat> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatsDataLoaded extends ChatsState {
  final List<Chat> chats;

  const ChatsDataLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatsError extends ChatsState {
  final String message;

  const ChatsError(this.message);
}
