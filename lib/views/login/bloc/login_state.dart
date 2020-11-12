part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class Initial extends LoginState {}

class Loading extends LoginState {}

class Failed extends LoginState {
  const Failed({@required this.error});

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Login Failed { error: $error }';
}
