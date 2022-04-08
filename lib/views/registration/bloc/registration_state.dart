part of 'registration_bloc.dart';

class RegistrationState extends Equatable {
  const RegistrationState(
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

  RegistrationState copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return RegistrationState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object> get props => [status, username, password];

  @override
  String toString() => 'RegistrationState';
}

class RegistrationInitial extends RegistrationState {
  @override
  List<Object> get props => [];
}

class UsernameInputActive extends RegistrationState {
  const UsernameInputActive(
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

  UsernameInputActive copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return UsernameInputActive(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  String toString() => 'UsernameInputActive';
}

class PasswordInputActive extends RegistrationState {
  const PasswordInputActive(
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
  PasswordInputActive copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return PasswordInputActive(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  String toString() => 'PasswordInputActive';
}

class RandomUsernameGenerated extends RegistrationState {
  const RandomUsernameGenerated(
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
  RandomUsernameGenerated copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return RandomUsernameGenerated(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  String toString() => 'RandomUsernameGenerated';
}

class RandomPassphraseGenerated extends RegistrationState {
  const RandomPassphraseGenerated(
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
  RandomPassphraseGenerated copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      String? errorMessage,
      bool? obscurePassword}) {
    return RandomPassphraseGenerated(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  String toString() => 'RandomPassphraseGenerated';
}

class PasswordObscurityToggled extends RegistrationState {
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
