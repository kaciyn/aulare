import 'dart:async';

import 'package:aulare/google/google_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

part 'google_event.dart';
part 'google_state.dart';

class GoogleBloc extends Bloc<GoogleEvent, GoogleState> {
  GoogleBloc({this.googleRepository, this.userDataRepository})
      : super(GoogleInitial());
  final GoogleRepository googleRepository;
  final UserDataRepository userDataRepository;

  @override
  Stream<GoogleState> mapEventToState(
    GoogleEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  Stream<AuthenticationState> mapClickedGoogleLoginToState() async* {
    yield Authenticating(); //show progress bar
    try {
      final firebaseUser = await googleRepository
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
}
