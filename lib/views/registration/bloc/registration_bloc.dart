import 'dart:async';

import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/registration/bloc/registration_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../models/input_models.dart';
import '../../authentication/bloc/authentication_repository.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserDataRepository _userDataRepository;

  RegistrationBloc(
      {required AuthenticationRepository authenticationRepository,
      required UserDataRepository userDataRepository})
      : _authenticationRepository = authenticationRepository,
        _userDataRepository = userDataRepository,
        super(const RegistrationState()) {
    on<UsernameInputActivated>((event, emit) async {
      emit(const UsernameInputActive().copyWith(
          username: state.username,
          password: state.password,
          status: Formz.validate([state.password, state.username])));
    });

    on<PasswordInputActivated>((event, emit) async {
      emit(const PasswordInputActive().copyWith(
          username: state.username,
          password: state.password,
          status: Formz.validate([state.password, state.username])));
    });

    on<RegistrationUsernameChanged>((event, emit) {
      final username = Username.dirty(event.username);

      emit(const UsernameInputActive().copyWith(
        username: username,
        password: state.password,
        status: Formz.validate([state.password, username]),
      ));
    });

    on<RegistrationPasswordChanged>((event, emit) {
      final password = Password.dirty(event.password);
      emit(const PasswordInputActive().copyWith(
        password: password,
        username: state.username,
        status: Formz.validate([password, state.username]),
      ));
    });

    on<RegistrationSubmitted>((event, emit) async {
      if (!state.status.isValidated) {
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.register(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzStatus.submissionSuccess));

        try {
          // await _authenticationRepository.login(
          //   username: state.username.value,
          //   password: state.password.value,
          // );

          final user = await authenticationRepository
              .getCurrentUser(); // retrieve user from firebase

          // await _userDataRepository.saveProfileDetails(user?.uid, name);
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } catch (_) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    });
  }
}
