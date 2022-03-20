import 'dart:async';

import 'package:aulare/views/registration/bloc/registration_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../models/input_models.dart';
import '../../authentication/bloc/authentication_repository.dart';
part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegistrationState()) {
    on<UsernameInputActivated>((event, emit) async {
      emit(UsernameInputActive());
    });

    on<PasswordInputActivated>((event, emit) async {
      emit(PasswordInputActive());
    });

    on<RegistrationUsernameChanged>((event, emit) {
      final username = Username.dirty(event.username);
      emit(state.copyWith(
        username: username,
        status: Formz.validate([state.password, username]),
      ));
    });

    on<RegistrationPasswordChanged>((event, emit) {
      final password = Password.dirty(event.password);
      emit(state.copyWith(
        password: password,
        status: Formz.validate([password, state.username]),
      ));
    });

    on<RegistrationSubmitted>((event, emit) async {
      if (state.status.isValidated) {
        emit(state.copyWith(status: FormzStatus.submissionInProgress));
        try {
          await _authenticationRepository.register(
            username: state.username.value,
            password: state.password.value,
          );
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } catch (_) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
}
