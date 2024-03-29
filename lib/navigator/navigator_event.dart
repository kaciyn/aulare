part of 'navigator_bloc.dart';

abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class Pop extends NavigatorEvent {
  @override
  String toString() => 'Pop';
}

class NavigateToHome extends NavigatorEvent {
  @override
  String toString() => 'NavigateToHome';
}

class NavigateToAuthentication extends NavigatorEvent {
  @override
  String toString() => 'NavigateToAuthentication';
}

class NavigateToLogin extends NavigatorEvent {
  @override
  String toString() => 'NavigateToLogin';
}

class NavigateToRegistration extends NavigatorEvent {
  @override
  String toString() => 'NavigateToRegistration';
}
