import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/models/models.dart';
import 'package:app/repo/auth_repo.dart';
import 'package:app/repo/user_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  final UserRepo userRepo;
  AuthBloc({required this.authRepo, required this.userRepo})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthBootstrap) {
        try {
          final user = await userRepo.getUser();

          emit(AuthAuthenticated(user));
        } catch (e) {
          emit(AuthUnauthenticated());
        }
      }

      if (event is AuthLogin) {
        try {
          final user = await authRepo.login(event.email, event.password);
          emit(AuthAuthenticated(user));
        } catch (e) {
          emit(AuthLoginFailed(e.toString()));
        }
      }

      if (event is AuthLogout) {
        await authRepo.logout();
        emit(AuthUnauthenticated());
      }
    });
  }
}
