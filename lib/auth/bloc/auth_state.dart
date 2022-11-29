part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final User user;

  const AuthLoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthLoginFailed extends AuthState {
  final String message;

  const AuthLoginFailed(this.message);

  @override
  List<Object> get props => [message];
}
