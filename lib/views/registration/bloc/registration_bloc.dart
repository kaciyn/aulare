import 'package:aulare/repositories/user_data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:passwd_gen/passwd_gen.dart' hide Password;
import 'package:username_gen/username_gen.dart';

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
        super(RegistrationInitial()) {
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

          final user = await _authenticationRepository
              .getCurrentUser(); // retrieve user from firebase

          await _userDataRepository.saveProfileDetails(
              user!.uid, state.username.value);

          await _authenticationRepository.login(
              username: state.username.value, password: state.password.value);

          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } catch (_) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    });

    on<TogglePasswordObscurity>((event, emit) {
      final bool toggledObscurePassword;
      if (state.obscurePassword == null || state.obscurePassword == true) {
        toggledObscurePassword = false;
      } else {
        toggledObscurePassword = true;
      }

      emit(const PasswordObscurityToggled().copyWith(
          password: state.password,
          username: state.username,
          status: Formz.validate([state.password, state.username]),
          obscurePassword: toggledObscurePassword));
    });

    on<GenerateRandomUsername>((event, emit) {
      final randomUsername = UsernameGen().generate();
      final username = Username.dirty(randomUsername);
      emit(RandomUsernameGenerated().copyWith(
          status: Formz.validate([state.password, username]),
          username: username,
          password: state.password,
          obscurePassword: state.obscurePassword));
      // add(AutoFillGeneratedUsername(randomUsername));
    });

    //these should really be in the repository/provider but whatever
    on<AutoFillGeneratedUsername>((event, emit) {
      final username = Username.dirty(event.randomUsername);
      emit(RandomUsernameGenerated().copyWith(
          status: Formz.validate([state.password, username]),
          username: username,
          password: state.password,
          obscurePassword: state.obscurePassword));
      print('username: ${state.username}');
      print('randomusername: ${username}');
    });

    on<GenerateRandomPassphrase>((event, emit) {
      final passwordGenerator = PasswordService.effLargeListWords();
      const passwordEntropy = 5;
      final randomPassphrase = passwordGenerator(passwordEntropy).toString();

      add(AutoFillGeneratedPassphrase(randomPassphrase));
    });

    on<AutoFillGeneratedPassphrase>((event, emit) {
      final passphrase = Password.dirty(event.randomPassphrase);

      emit(RandomPassphraseGenerated().copyWith(
          status: Formz.validate([passphrase, state.username]),
          username: state.username,
          password: passphrase,
          obscurePassword: state.obscurePassword));
    });
  }
}
