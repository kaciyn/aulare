import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../models/input_models.dart';
import '../../authentication/bloc/authentication_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<UsernameInputActivated>((event, emit) async {
      emit(UsernameInputActive());
    });

    on<PasswordInputActivated>((event, emit) async {
      emit(PasswordInputActive());
    });

    on<LoginUsernameChanged>((event, emit) {
      final username = Username.dirty(event.username);
      emit(state.copyWith(
        username: username,
        status: Formz.validate([state.password, username]),
      ));
    });

    on<LoginPasswordChanged>((event, emit) {
      final password = Password.dirty(event.password);
      emit(state.copyWith(
        password: password,
        status: Formz.validate([password, state.username]),
      ));
    });

    on<LoginSubmitted>((event, emit) async {
      if (state.status.isValidated) {
        emit(state.copyWith(status: FormzStatus.submissionInProgress));
        try {
          await _authenticationRepository.login(
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