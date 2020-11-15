part of 'google_bloc.dart';

abstract class GoogleEvent extends Equatable {
  const GoogleEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class LoggedIn extends GoogleEvent {
  LoggedIn(this.user) : super([user]);
  final firebase.User user;
  @override
  String toString() => 'LoggedIn';
}
