import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/models/user.dart';
import 'package:app/repo/user_repo.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepo repo;

  UsersBloc({required this.repo}) : super(UsersInitial()) {
    on<UsersEvent>((event, emit) async {
      if (event is GetUsers) {
        try {
          final users = await repo.getUsers();

          if (users.isEmpty) {
            emit(UsersEmpty());
          } else {
            emit(UsersLoaded(users));
          }
        } catch (e) {
          emit(const UsersError("Something went wrong"));
        }
      }
    });
  }
}
