import 'dart:async';

import 'package:aulare/views/authentication/bloc/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/user.dart';
import '../../../repositories/user_data_repository.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({required AuthenticationRepository authenticationRepository})
      : super(AccountInitial()) {
    on<GetCurrentUserData>((event, emit) {
      final currentUser = authenticationRepository.currentUser;
      var username = currentUser?.username ?? '';
      var id = currentUser?.id ?? '';
      emit(CurrentUserDataFetched().copyWith(username: username, uid: id));
    });
  }
}
