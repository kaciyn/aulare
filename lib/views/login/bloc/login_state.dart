part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState(
      {this.status = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.errorMessage,
      this.obscurePassword = true});

  final FormzStatus status;
  final Username username;
  final Password password;
  final String? errorMessage;
  final bool? obscurePassword;

  LoginState copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object> get props => [
        status,
        username,
        password,
      ];

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

class PasswordObscurityToggled extends LoginState {
  const PasswordObscurityToggled(
      {this.status = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.errorMessage,
      this.obscurePassword = true});

  final FormzStatus status;
  final Username username;
  final Password password;
  final String? errorMessage;
  final bool? obscurePassword;

  @override
  PasswordObscurityToggled copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return PasswordObscurityToggled(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  String toString() => 'PasswordObscurityToggled';
}

class TogglingPasswordObscurity extends LoginState {
  const TogglingPasswordObscurity(
      {this.status = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.errorMessage,
      this.obscurePassword = true});

  final FormzStatus status;
  final Username username;
  final Password password;
  final String? errorMessage;
  final bool? obscurePassword;

  @override
  TogglingPasswordObscurity copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return TogglingPasswordObscurity(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  String toString() => 'TogglingPasswordObscurity';
}
