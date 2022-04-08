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

  @override
  String toString() => 'RegistrationUsernameChanged';
}

class RegistrationPasswordChanged extends RegistrationEvent {
  const RegistrationPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'RegistrationPasswordChanged';
}

class RegistrationSubmitted extends RegistrationEvent {
  const RegistrationSubmitted();

  @override
  String toString() => 'RegistrationSubmitted';
}

class TogglePasswordObscurity extends RegistrationEvent {
  @override
  String toString() => 'PasswordObscurityToggled';
}

class GenerateRandomUsername extends RegistrationEvent {
  @override
  String toString() => 'GenerateRandomUsername';
}

class GenerateRandomPassphrase extends RegistrationEvent {
  @override
  String toString() => 'GenerateRandomPassphrase';
}

class AutoFillGeneratedUsername extends RegistrationEvent {
  const AutoFillGeneratedUsername(this.randomUsername);

  final String randomUsername;

  @override
  String toString() => 'AutoFillGeneratedUsername';
}

class AutoFillGeneratedPassphrase extends RegistrationEvent {
  const AutoFillGeneratedPassphrase(this.randomPassphrase);

  final String randomPassphrase;

  @override
  String toString() => 'AutoFillGeneratedPassphrase';
}
