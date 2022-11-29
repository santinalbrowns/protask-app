part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class DeleteAccount extends AccountEvent {}

class GetAccount extends AccountEvent {}

class UpdateAccount extends AccountEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String password;

  const UpdateAccount({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstname, lastname, email, password];
}
