import 'dart:io';

import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  ConfigBloc(
      {required this.userDataRepository, required this.storageRepository})
      : super(Unconfigured()) {
    on<ConfigValueChanged>(_onConfigValueChanged);
    // on<UpdateProfilePicture>(_onUpdateProfilePicture);
    on<RestartApp>(_onRestartApp);
  }

  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  void _onConfigValueChanged(event, emit) {
    SharedObjects.preferences.setBool(event.key, event.value);

    emit(ConfigChanged(event.key, event.value));
  }

  // Stream<Future<void>> _onUpdateProfilePicture(event, emit) async* {
  //   emit(UpdatingProfilePicture());
  //   final profilePictureUrl = await storageRepository.uploadFile(
  //       event.file, Paths.profilePicturePath);
  //   await userDataRepository.updateProfilePicture(profilePictureUrl);
  //   emit(ProfilePictureChanged(profilePictureUrl));
  // }

  void _onRestartApp(event, emit) {
    emit(RestartedApp());
  }
}
