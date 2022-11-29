part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUser extends RegisterEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String password;

  const RegisterUser({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstname, lastname, email, password];
}
