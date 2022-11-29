import 'package:app/repo/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required this.userRepo}) : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      if (event is RegisterUser) {
        emit(RegisterUserLoading());
        try {
          await userRepo.addUser(
            firstname: event.firstname,
            lastname: event.lastname,
            email: event.email,
            password: event.password,
          );

          emit(RegisterUserSuccess());
        } catch (e) {
          emit(RegisterUserFailed(e.toString()));
        }
      }
    });
  }

  final UserRepo userRepo;
}
