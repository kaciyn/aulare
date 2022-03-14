part of 'config_bloc.dart';

@immutable
abstract class ConfigState extends Equatable {
  const ConfigState([List props = const <dynamic>[]]);

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class ConfigChanged extends ConfigState {
  ConfigChanged(this.key, this.value) : super([key, value]);
  final String key;
  final bool value;
}

class Unconfigured extends ConfigState {}

class UpdatingProfilePicture extends ConfigState {}

class ProfilePictureChanged extends ConfigState {
  ProfilePictureChanged(this.profilePictureUrl) : super([profilePictureUrl]);

  final String profilePictureUrl;

  @override
  String toString() =>
      'ProfilePictureChangedState {profilePictureUrl: $profilePictureUrl}';
}

class RestartedApp extends ConfigState {
  RestartedApp() : super([]);
}
