import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/models/chat.dart';
import 'package:app/repo/auth_repo.dart';
import 'package:app/repo/chat_repo.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepo chatRepo;

  ChatsBloc(this.chatRepo) : super(ChatsInitial()) {
    _streamSubscription =
        chatRepo.getResponse.listen((event) => add(ChatsData(event)));

    on<ChatsEvent>((event, emit) async {
      String token = await auth.restore();

      Socket socket = io(
        'http://localhost:5000',
        OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {HttpHeaders.authorizationHeader: 'Bearer $token'}).build(),
      );

      //socket.onConnect((_) => print('Socket connected'));

      //socket.onDisconnect((_) => print(token));

      socket.on('message', (data) => chatRepo.addChats(data));

      //socket.on('chats', (data) => chatRepo.addChats(data));

      socket.on('chats', (data) {
        List<Chat> chats = data.map<Chat>((e) => Chat.fromJson(e)).toList();

        chats.sort((a, b) => b.time.compareTo(a.time));

        add(ChatsData(chats));
      });

      if (event is ChatsData) {
        emit(ChatsLoaded(event.chats));
      }
    });
  }

  late StreamSubscription _streamSubscription;
  //late StreamSubscription _sub;

  late AuthRepo auth = AuthRepo();

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    chatRepo.dispose();
    return super.close();
  }
}
