import 'dart:io';

import 'package:aulare/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];

  AuthenticationState([List props = const <dynamic>[]]) : super();
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class AuthInProgress extends AuthenticationState {
  @override
  String toString() => 'AuthInProgress';
}

class Authenticated extends AuthenticationState {
  final firebase.User user;

  Authenticated(this.user);

  @override
  String toString() => 'Authenticated';
}

class PreFillData extends AuthenticationState {
  final User user;

  PreFillData(this.user);

  @override
  String toString() => 'PreFillData';
}

class UnAuthenticated extends AuthenticationState {
  @override
  String toString() => 'UnAuthenticated';
}

class ReceivedProfilePicture extends AuthenticationState {
  final File file;

  ReceivedProfilePicture(this.file);

  @override
  toString() => 'ReceivedProfilePicture';
}

class ProfileUpdateInProgress extends AuthenticationState {
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class ProfileUpdated extends AuthenticationState {
  @override
  String toString() => 'ProfileComplete';
}
