import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'navigator_event.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  NavigatorBloc({this.navigatorKey}) : super(0);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Stream<dynamic> mapEventToState(
    NavigatorEvent event,
  ) async* {
    if (event is Pop) {
      navigatorKey.currentState.pop();
    } else if (event is NavigateToHome) {
      await navigatorKey.currentState.pushNamed('/home');
    } else if (event is NavigateToAuthentication) {
      await navigatorKey.currentState.pushNamed('/authentication');
    } else if (event is NavigateToLogin) {
      await navigatorKey.currentState.pushNamed('/login');
    } else if (event is NavigateToRegistration) {
      await navigatorKey.currentState.pushNamed('/register');
    }
  }
}
