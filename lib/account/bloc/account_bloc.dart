import 'package:app/models/models.dart';
import 'package:app/repo/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({required this.userRepo}) : super(AccountInitial()) {
    on<AccountEvent>((event, emit) async {
      if (event is GetAccount) {
        emit(AccountLoading());

        try {
          final user = await userRepo.getUser();

          emit(AccountLoaded(user));
        } catch (e) {
          emit(AccountError(e.toString()));
        }
      }

      if (event is UpdateAccount) {
        emit(AccountLoading());
        try {
          final user = await userRepo.getUser();

          final result = await userRepo.update(
            id: user.id,
            firstname: event.firstname,
            lastname: event.lastname,
            email: event.email,
            password: event.password,
          );

          emit(AccountUpdated(result));
        } catch (e) {
          emit(AccountError(e.toString()));
        }
      }

      if (event is DeleteAccount) {
        emit(AccountLoading());
        try {
          await userRepo.deleteCurrentUser();

          emit(AccountDeleted());
        } catch (e) {
          emit(AccountError(e.toString()));
        }
      }
    });
  }

  final UserRepo userRepo;
}
