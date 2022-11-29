import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/models/models.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {
      if (event is GetChatMessages) {
        emit(ChatMessages(event.messages));
      }

      if (event is CreateChat) {}
    });
  }
}
