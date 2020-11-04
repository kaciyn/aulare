import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => <dynamic>[];

  const AuthenticationEvent([List props = const <dynamic>[]]) : super();
}

class AppLaunched extends AuthenticationEvent {
  @override
  String toString() => 'AppLaunched';
}

class ClickedGoogleLogin extends AuthenticationEvent {
  @override
  String toString() => 'ClickedGoogleLogin';
}

class LoggedIn extends AuthenticationEvent {
  final firebase.User user;

  LoggedIn(this.user) : super([user]);

  @override
  String toString() => 'LoggedIn';
}

class PickedProfilePicture extends AuthenticationEvent {
  final File file;

  PickedProfilePicture(this.file) : super([file]);

  @override
  String toString() => 'PickedProfilePicture';
}

class SaveProfile extends AuthenticationEvent {
  final File profileImage;
  final String username;

  SaveProfile(this.profileImage, this.username)
      : super([profileImage, username]);

  @override
  String toString() => 'SaveProfile';
}

class ClickedLogout extends AuthenticationEvent {
  @override
  String toString() => 'ClickedLogout';
}
