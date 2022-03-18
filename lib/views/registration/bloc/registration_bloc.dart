import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<UsernameInputActivated>((event, emit) async {
      emit(UsernameInputActive());
    });

    on<PasswordInputActivated>((event, emit) async {
      emit(PasswordInputActive());
    });
  }
}
