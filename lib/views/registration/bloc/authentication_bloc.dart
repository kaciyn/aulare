import 'dart:async';
import 'dart:io';

import 'package:aulare/config/paths.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/registration/bloc/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
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

  // AuthenticationBloc(
  //     {this.authenticationRepository,
  //     this.userDataRepository,
  //     this.storageRepository})
  //     : assert(authenticationRepository != null),
  //       assert(userDataRepository != null),
  //       assert(storageRepository != null);

  // @override
  // AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    print(event);
    if (event is AppLaunched) {
      yield* mapAppLaunchedToState();
    } else if (event is ClickedGoogleLogin) {
      yield* mapClickedGoogleLoginToState();
    } else if (event is LoggedIn) {
      yield* mapLoggedInToState(event.user);
    } else if (event is PickedProfilePicture) {
      yield ReceivedProfilePicture(event.file);
    } else if (event is SaveProfile) {
      yield* mapSaveProfileToState(event.profileImage, event.username);
    } else if (event is ClickedLogout) {
      yield* mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> mapAppLaunchedToState() async* {
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
          yield Authenticated(
              user); // else yield the authenticated state and redirect to profile page to complete profile.
          add(LoggedIn(
              user)); // also disptach a login event so that the data from gauth can be prefilled
        }
      } else {
        yield Unauthenticated(); // is not signed in then show the home page
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> mapClickedGoogleLoginToState() async* {
    yield Authenticating(); //show progress bar
    try {
      final firebaseUser = await authenticationRepository
          .signInWithGoogle(); // show the google auth prompt and wait for user selection, retrieve the selected account
      final isProfileComplete = await userDataRepository.isProfileComplete(
          firebaseUser.uid); // check if the user's profile is complete
      print(isProfileComplete);
      if (isProfileComplete) {
        yield ProfileUpdated(); //if profile is complete go to home page
      } else {
        yield Authenticated(
            firebaseUser); // else yield the authenticated state and redirect to profile page to complete profile.
        add(LoggedIn(
            firebaseUser)); // also dispatch a login event so that the data from gauth can be prefilled
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield Unauthenticated(); // in case of error go back to first registration page
    }
  }

  Stream<AuthenticationState> mapLoggedInToState(
      firebase.User firebaseUser) async* {
    yield ProfileUpdateInProgress(); // shows progress bar
    final user = await userDataRepository.saveDetailsFromGoogleAuth(
        firebaseUser); // save the gAuth details to firestore database
    yield PreFillData(user); // prefill the gauth data in the form
  }

  Stream<AuthenticationState> mapSaveProfileToState(
      File profileImageFile, String username) async* {
    yield ProfileUpdateInProgress(); // shows progress bar

    final profilePictureUrl = await storageRepository.uploadImage(
        profileImageFile,
        Paths.profilePicturePath); // upload image to firebase storage

    final user = await authenticationRepository
        .getCurrentUser(); // retrieve user from firebase

    await userDataRepository.saveProfileDetails(user.uid, profilePictureUrl,
        username); // save profile details to firestore
    yield ProfileUpdated(); //redirect to home page
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield Unauthenticated(); // redirect to login page
    await authenticationRepository.signOutUser(); // terminate session
  }
}
