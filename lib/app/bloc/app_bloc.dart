// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:aulare/models/user.dart';
import 'package:aulare/views/authentication/bloc/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../models/user.dart';
import '../../views/authentication/bloc/authentication_repository.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository authenticationRepository;
  // final UserDataRepository userDataRepository;
  // final StorageRepository storageRepository;
  // final MessagingRepository messagingRepository;

  late final StreamSubscription<User> _userSubscription;

  AppBloc({
    required this.authenticationRepository,
    // required this.messagingRepository,
    // required this.storageRepository,
    // required this.userDataRepository
  }) :
        //initial state
        super(authenticationRepository.currentUser!.isNotEmpty
            ? Authenticated(authenticationRepository.currentUser!)
            : const Unauthenticated()) {
    on<AppUserChanged>((AppUserChanged event, Emitter<AppState> emit) {
      emit(
        event.user.isNotEmpty
            ? Authenticated(event.user)
            : const Unauthenticated(),
      );
    });

    on<AppLogoutRequested>((event, emit) {
      unawaited(authenticationRepository.logout());
      emit(const Unauthenticated());
    });

    // on<AppLaunched>((event, emit) async {
    //   try {
    //     // emit(Authenticating()); //show the progress bar
    //     final isLoggedIn = await authenticationRepository.isLoggedIn();
    //     // check if user is signed in
    //     if (isLoggedIn) {
    //       final user = await authenticationRepository.getCurrentUser();
    //       // final isProfileComplete = await userDataRepository.isProfileComplete(user
    //       //     .uid); // if he is signed in then check if his profile is complete
    //       // print(isProfileComplete);
    //       // if (isProfileComplete) {
    //       //if profile is complete then redirect to the home page
    //       //   emit(ProfileUpdated();
    //       // } else {
    //       emit(Authenticated(user));
    //     } else {
    //       emit(Unauthenticated()); // is not signed in then show the home page
    //     }
    //   } catch (_, stacktrace) {
    //     print(stacktrace);
    //     emit(Unauthenticated());
    //   }
    // });
    //
    // on<Logout>((event, emit) async {
    //   emit(Authenticating());
    //   // await authenticationRepository.deleteToken();
    //   emit(Unauthenticated()); // redirect to login page
    //
    //   await authenticationRepository.logout(); // terminate session
    // });
    //
    // _userSubscription = authenticationRepository.user.listen(
    //   (user) => add(AppUserChanged(user)),
    // );

    @override
    Future<void> close() {
      _userSubscription.cancel();
      return super.close();
    }
  }
}
