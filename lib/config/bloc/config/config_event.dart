part of 'config_bloc.dart';

@immutable
abstract class ConfigEvent extends Equatable {
  ConfigEvent([List props = const <dynamic>[]]);

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class ConfigValueChanged extends ConfigEvent {
  ConfigValueChanged(this.key, this.value) : super([key, value]);
  final String key;
  final bool value;
}

class UpdateProfilePicture extends ConfigEvent {
  UpdateProfilePicture(this.file) : super([file]);

  final File file;

  @override
  String toString() => 'UpdateProfilePicture';
}

class RestartApp extends ConfigEvent {
  @override
  String toString() => 'RestartApp';
}
