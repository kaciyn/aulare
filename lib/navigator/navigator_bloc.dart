import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'navigator_event.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  NavigatorBloc({this.navigatorKey}) : super(0) {
    on<Pop>(_onPop);
    on<NavigateToHome>(_onNavigateToHome);
    on<NavigateToAuthentication>(_onNavigateToAuthentication);
    on<NavigateToLogin>(_onNavigateToLogin);
    on<NavigateToRegistration>(_onNavigateToRegistration);
    on<NavigateToMessages>(_onNavigateToMessages);
  }

  final GlobalKey<NavigatorState> navigatorKey;

  void _onPop(event, emit) => emit(navigatorKey.currentState.pop());

  void _onNavigateToHome(event, emit) =>
      emit(navigatorKey.currentState.pushNamed('/home'));

  void _onNavigateToAuthentication(event, emit) =>
      emit(navigatorKey.currentState.pushNamed('/authentication'));

  void _onNavigateToLogin(event, emit) =>
      emit(navigatorKey.currentState.pushNamed('/login'));

  void _onNavigateToRegistration(event, emit) =>
      emit(navigatorKey.currentState.pushNamed('/register'));

  void _onNavigateToMessages(event, emit) =>
      emit(navigatorKey.currentState.pushNamed('/messages'));

// @override
// Stream<dynamic> mapEventToState(
//   NavigatorEvent event,
// ) async* {
//   if (event is Pop) {
//     navigatorKey.currentState.pop();
//   } else if (event is NavigateToHome) {
//     await navigatorKey.currentState.pushNamed('/home');
//   } else if (event is NavigateToAuthentication) {
//     await navigatorKey.currentState.pushNamed('/authentication');
//   } else if (event is NavigateToLogin) {
//     await navigatorKey.currentState.pushNamed('/login');
//   } else if (event is NavigateToRegistration) {
//     await navigatorKey.currentState.pushNamed('/register');
//   }
// }
}
