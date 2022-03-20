part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  final FormzStatus status;
  final Username username;
  final Password password;

  LoginState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class UsernameInputActive extends LoginState {
  @override
  String toString() => 'UsernameInputActive';
}

class PasswordInputActive extends LoginState {
  @override
  String toString() => 'UsernameInputActive';
}
