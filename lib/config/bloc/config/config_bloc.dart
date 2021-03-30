// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// import 'package:aulare/config/paths.dart';
// import 'package:aulare/repositories/storage_repository.dart';
// import 'package:aulare/repositories/user_data_repository.dart';
// import 'package:aulare/utilities/shared_objects.dart';
//
// part 'config_event.dart';
//
// part 'config_state.dart';
//
// class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
//   ConfigBloc(
//       { @required this.userDataRepository,
//         @required this.storageRepository})
//       :  assert(userDataRepository != null),
//         assert(storageRepository != null),
//         super(Unconfigured());
//
//  final UserDataRepository userDataRepository;
//  final StorageRepository storageRepository;
//
//   @override
//   Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
//     // TODO: Add your event logic
//   }
// }
//
// class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
//   @override
//   Stream<ConfigState> mapEventToState(
//     ConfigEvent event,
//   ) async* {
//     if (event is ConfigValueChanged) {
//       SharedObjects.prefs.setBool(event.key, event.value);
//       yield ConfigChangeState(event.key, event.value);
//     }
//     if (event is UpdateProfilePicture) {
//       yield* mapUpdateProfilePictureToState(event);
//     }
//   }
//
//   Stream<ConfigState> mapUpdateProfilePictureToState(
//       UpdateProfilePicture event) async* {
//     yield UpdatingProfilePictureState();
//     final profilePictureUrl = await storageRepository.uploadFile(
//         event.file, Paths.profilePicturePath);
//     await userDataRepository.updateProfilePicture(profilePictureUrl);
//     yield ProfilePictureChangedState(profilePictureUrl);
//   }
// }
