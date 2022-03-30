import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../models/input_models.dart';
import '../../../repositories/user_data_repository.dart';
import '../../authentication/bloc/authentication_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;
  final UserDataRepository _userDataRepository;

  LoginBloc(
      {required AuthenticationRepository authenticationRepository,
      required UserDataRepository userDataRepository})
      : _authenticationRepository = authenticationRepository,
        _userDataRepository = userDataRepository,
        super(const LoginState()) {
    on<UsernameInputActivated>((event, emit) async {
      emit(UsernameInputActive().copyWith(
          username: state.username,
          status: Formz.validate([state.password, state.username])));
    });

    on<PasswordInputActivated>((event, emit) async {
      emit(PasswordInputActive().copyWith(
          username: state.username,
          status: Formz.validate([state.password, state.username])));
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

          final user = await _authenticationRepository
              .getCurrentUser(); // retrieve user from firebase

          await _userDataRepository.saveProfileDetails(
              user!.uid, state.username.value);

          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } catch (_) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      }
    });
  }
}
