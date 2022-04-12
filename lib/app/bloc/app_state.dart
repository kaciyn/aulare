part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState(this.user);
  // const AppState({
  //   // required this.status,
  //   this.user = User.empty,
  // });
  //
  // const AppState.authenticated(User user)
  //     : this._(status: AppStatus.authenticated, user: user);
  //
  // const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);
  //
  // final AppStatus status;
  final User user;

  @override
  // List<Object> get props => [user];
  List<Object> get props => [];
}

class Authenticated extends AppState {
  const Authenticated(User user) : super(user);

  @override
  String toString() => 'Authenticated';
}

class Unauthenticated extends AppState {
  const Unauthenticated() : super(User.empty);

  @override
  String toString() => 'Unauthenticated';
}
