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
