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
      {@required this.authenticationRepository,
      @required this.userDataRepository,
      @required this.storageRepository})
      : assert(authenticationRepository!=null),
  assert(userDataRepository!=null),
  assert(storageRepository!=null), super(Uninitialized());

  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    print(event);
    if (event is AppLaunched) {
      final hasToken = await userDataRepository.hasToken();
      yield* mapAppLaunchedToState();
    } else if (event is Register) {
      yield* mapRegisterToState(event.username, event.password);
      // } else if (event is ClickedGoogleLogin) {
      //   yield* mapClickedGoogleLoginToState();
    } else if (event is Login) {
      yield* mapLoginToState(event.username, event.password);
    } else if (event is PickedProfilePicture) {
      yield ProfilePictureReceived(event.file);
    } else if (event is SaveProfile) {
      yield* mapSaveProfileToState(
          // event.profilePicture,
          event.username);
    } else if (event is Logout) {
      yield* mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> mapAppLaunchedToState() async* {
    try {
      yield Authenticating(); //show the progress bar

      final isSignedIn = await userDataRepository.isSignedIn();
      // check if user is signed in
      if (isSignedIn) {
        final user = await authenticationRepository.getCurrentUser();
        final isProfileComplete = await userDataRepository.isProfileComplete(user
            .uid); // if he is signed in then check if his profile is complete
        print(isProfileComplete);
        if (isProfileComplete) {
          //if profile is complete then redirect to the home page
          yield ProfileUpdated();
        } else {
          yield Authenticated(user);
        }
      } else {
        yield Unauthenticated(); // is not signed in then show the home page
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> mapLoginToState(
      String username, String password) async* {
    yield Authenticating();

    try {
      await userDataRepository.logIn(username, password);

      yield Authenticated(await authenticationRepository.getCurrentUser());
    } catch (error) {
      //todo add custom error jere
      yield Failed(error: error.toString());
    }
  }

  Stream<AuthenticationState> mapRegisterToState(
      String username, String password) async* {
    yield Authenticating();
    try {
      await authenticationRepository.register(username, password);

      yield Authenticated(await authenticationRepository.getCurrentUser());
    } catch (error) {
      //todo add custom error here
      yield Failed(error: error.toString());
    }
  }

  Stream<AuthenticationState> mapSaveProfileToState(
      // File profilePictureFile,
      String username) async* {
    yield ProfileUpdateInProgress(); // shows progress bar

    // final profilePictureUrl = await storageRepository.uploadImage(
    //     profilePictureFile,
    //     Paths.profilePicturePath); // upload image to firebase storage

    final user = await authenticationRepository
        .getCurrentUser(); // retrieve user from firebase

    await userDataRepository.saveProfileDetails(
        user.uid,
        // profilePictureUrl,
        username);
    // save profile details to firestore
    yield ProfileUpdated(); //redirect to home page
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield Authenticating();
    await userDataRepository.deleteToken();
    yield Unauthenticated(); // redirect to login page
    await authenticationRepository.logout(); // terminate session
  }
}
