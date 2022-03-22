part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class UsernameInputActivated extends RegistrationEvent {
  @override
  String toString() => 'UsernameInputActivated';
}

class PasswordInputActivated extends RegistrationEvent {
  @override
  String toString() => 'PasswordInputActivated';
}

class RegistrationUsernameChanged extends RegistrationEvent {
  const RegistrationUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class RegistrationPasswordChanged extends RegistrationEvent {
  const RegistrationPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class RegistrationSubmitted extends RegistrationEvent {
  const RegistrationSubmitted();
}