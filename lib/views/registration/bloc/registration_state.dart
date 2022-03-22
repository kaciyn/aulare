part of 'registration_bloc.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  final FormzStatus status;
  final Username username;
  final Password password;

  RegistrationState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, username, password];

  @override
  bool get stringify => true;
}

class RegistrationInitial extends RegistrationState {
  @override
  List<Object> get props => [];
}

class UsernameInputActive extends RegistrationState {
  @override
  String toString() => 'UsernameInputActive';
}

class PasswordInputActive extends RegistrationState {
  @override
  String toString() => 'UsernameInputActive';
}
