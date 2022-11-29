part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountUpdated extends AccountState {
  final User user;

  const AccountUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class AccountLoaded extends AccountState {
  final User user;

  const AccountLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class AccountLoading extends AccountState {}

class AccountDeleted extends AccountState {}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object> get props => [message];
}
