import 'dart:async';
import 'dart:io';

import 'package:aulare/models/user.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/authentication/bloc/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/cupertino.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required this.authenticationRepository,
      required this.userDataRepository,
      required this.storageRepository})
      : super(Uninitialized()) {
    on<AppLaunched>(_onAppLaunched);
    on<Register>(_onRegister);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<UsernameInputActivated>(_onUsernameInputActivated);
    on<PasswordInputActivated>(_onPasswordInputActivated);
    // on<SaveProfile>(_onSaveProfile);
  }

  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  Stream<AuthenticationState> _onAppLaunched(
      AppLaunched event, Emitter<AuthenticationState> emit) async* {
    try {
      emit(Authenticating()); //show the progress bar

      final isLoggedIn = await authenticationRepository.isLoggedIn();
      // check if user is signed in
      if (isLoggedIn) {
        final user = await authenticationRepository.getCurrentUser();
        // final isProfileComplete = await userDataRepository.isProfileComplete(user
        //     .uid); // if he is signed in then check if his profile is complete
        // print(isProfileComplete);
        // if (isProfileComplete) {
        //if profile is complete then redirect to the home page
        //   emit(ProfileUpdated();
        // } else {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated()); // is not signed in then show the home page
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      emit(Unauthenticated());
    }
  }

  Stream<AuthenticationState> _onRegister(
      Register event, Emitter<AuthenticationState> emit) async* {
    emit(Authenticating());
    try {
      await authenticationRepository.register(event.username, event.password);

      await authenticationRepository.login(event.username, event.password);

      add(SaveProfile(event.username));

      emit(Authenticated(await authenticationRepository.getCurrentUser()));
    } catch (error) {
      //todo add custom error here
      emit(Failed(error: error.toString()));
      emit(Unauthenticated()); // redirect to login page
    }
  }

  Stream<AuthenticationState> _onLogin(
      Login event, Emitter<AuthenticationState> emit) async* {
    emit(Authenticating());

    try {
      await authenticationRepository.login(event.username, event.password);

      emit(Authenticated(await authenticationRepository.getCurrentUser()));
    } catch (error) {
      //todo add custom error here
      emit(Failed(error: error.toString()));
      emit(Unauthenticated()); // redirect to login page

    }
  }

  Stream<AuthenticationState> _onLogout(
      Logout event, Emitter<AuthenticationState> emit) async* {
    emit(Authenticating());
    await authenticationRepository.deleteToken();
    emit(Unauthenticated()); // redirect to login page
    await authenticationRepository.logout(); // terminate session}
  }

  Stream<AuthenticationState> _onUsernameInputActivated(
      UsernameInputActivated event, Emitter<AuthenticationState> emit) async* {
    emit(UsernameInputActive());
  }

  Stream<AuthenticationState> _onPasswordInputActivated(
      PasswordInputActivated event, Emitter<AuthenticationState> emit) async* {
    emit(PasswordInputActive());
  }

  // Stream<AuthenticationState> _onSaveProfile(
  //     SaveProfile event, Emitter<AuthenticationState> emit) async* {
  //   // Stream<AuthenticationState> mapSaveProfileToState() async* {
  //   // File profilePictureFile, username
  //
  //   emit(ProfileUpdateInProgress()); // shows progress bar
  //
  //   // final profilePictureUrl = await storageRepository.uploadImage(
  //   //     profilePictureFile,
  //   //     Paths.profilePicturePath); // upload image to firebase storage
  //
  //   final user = await (authenticationRepository.getCurrentUser()
  //       as FutureOr<firebase.User>); // retrieve user from firebase
  //
  //   await userDataRepository.saveProfileDetails(
  //       user.uid,
  //       // profilePictureUrl,username);
  //       // save profile details to firestore
  //       emit(ProfileUpdated())); //redirect to home page
  // }
}
