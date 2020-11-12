import 'dart:async';
import 'dart:io';

import 'package:aulare/config/paths.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/authentication/bloc/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {this.authenticationRepository,
      this.userDataRepository,
      this.storageRepository})
      : super(Uninitialized());

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
      yield* mapAppLaunchedToState(hasToken);
    } else if (event is ClickedLogIn) {
      yield* mapClickedLoginToState();
    } else if (event is ClickedRegister) {
      yield* mapClickedRegisterToState();
      // } else if (event is ClickedGoogleLogin) {
      //   yield* mapClickedGoogleLoginToState();
    } else if (event is LoggedIn) {
      yield* mapLoggedInToState(event.token);
    } else if (event is PickedProfilePicture) {
      yield ProfilePictureReceived(event.file);
    } else if (event is SaveProfile) {
      yield* mapSaveProfileToState(event.profilePicture, event.username);
    } else if (event is Logout) {
      yield* mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> mapAppLaunchedToState(bool hasToken) async* {
    try {
      yield Authenticating(); //show the progress bar
      final isSignedIn = await authenticationRepository
          .isLoggedIn(); // check if user is signed in
      if (isSignedIn) {
        final user = await authenticationRepository.getCurrentUser();
        final isProfileComplete = await userDataRepository.isProfileComplete(user
            .uid); // if he is signed in then check if his profile is complete
        print(isProfileComplete);
        if (isProfileComplete) {
          //if profile is complete then redirect to the home page
          yield ProfileUpdated();
        } else {
          yield Authenticated();
          // yield Authenticated(
          //     user); // else yield the authenticated state and redirect to profile page to complete profile.
          // add(LoggedIn(
          //     user)); // also disptach a login event so that the data from gauth can be prefilled

          // add(LoggedIn(token));
        }
      } else {
        yield Unauthenticated(); // is not signed in then show the home page
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> mapClickedLoginToState() async* {
    //TODO implement login
  }

  Stream<AuthenticationState> mapLoggedInToState(String token) async* {
    yield Authenticating(); //show progress bar
    await userDataRepository.persistToken(token);
    yield Authenticated();
  }

  Stream<AuthenticationState> mapClickedRegisterToState() async* {
    //TODO implement register
  }

  // Stream<AuthenticationState> mapClickedGoogleLoginToState() async* {
  //   yield Authenticating(); //show progress bar
  //   try {
  //     final firebaseUser = await authenticationRepository
  //         .signInWithGoogle(); // show the google auth prompt and wait for user selection, retrieve the selected account
  //     final isProfileComplete = await userDataRepository.isProfileComplete(
  //         firebaseUser.uid); // check if the user's profile is complete
  //     print(isProfileComplete);
  //     if (isProfileComplete) {
  //       yield ProfileUpdated(); //if profile is complete go to home page
  //     } else {
  //       yield Authenticated(
  //           firebaseUser); // else yield the authenticated state and redirect to profile page to complete profile.
  //       add(LoggedIn(
  //           firebaseUser)); // also dispatch a login event so that the data from gauth can be prefilled
  //     }
  //   } catch (_, stacktrace) {
  //     print(stacktrace);
  //     yield Unauthenticated(); // in case of error go back to first registration page
  //   }
  // }

  Stream<AuthenticationState> mapSaveProfileToState(
      File profilePictureFile, String username) async* {
    yield ProfileUpdateInProgress(); // shows progress bar

    final profilePictureUrl = await storageRepository.uploadImage(
        profilePictureFile,
        Paths.profilePicturePath); // upload image to firebase storage

    final user = await authenticationRepository
        .getCurrentUser(); // retrieve user from firebase

    await userDataRepository.saveProfileDetails(user.uid, profilePictureUrl,
        username); // save profile details to firestore
    yield ProfileUpdated(); //redirect to home page
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield Authenticating();
    await userDataRepository.deleteToken();
    yield Unauthenticated(); // redirect to login page
    await authenticationRepository.logout(); // terminate session
  }
}
