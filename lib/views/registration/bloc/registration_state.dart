part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class RegistrationInitial extends RegistrationState {}

class UsernameInputActive extends RegistrationState {
  @override
  String toString() => 'UsernameInputActive';
}

class PasswordInputActive extends RegistrationState {
  @override
  String toString() => 'UsernameInputActive';
}
