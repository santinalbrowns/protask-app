part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterUserLoading extends RegisterState {}

class RegisterUserSuccess extends RegisterState {}

class RegisterUserFailed extends RegisterState {
  final String message;

  const RegisterUserFailed(this.message);

  @override
  List<Object> get props => [message];
}
