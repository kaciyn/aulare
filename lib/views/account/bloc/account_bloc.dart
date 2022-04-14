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
    on<GetCurrentUserData>((event, emit) async {
      final currentUser = await authenticationRepository.getCurrentUser();
      var username = currentUser?.email?.replaceAll('@aula.re', '') ?? '';
      var id = currentUser?.uid ?? '';
      emit(CurrentUserDataFetched().copyWith(username: username, uid: id));
    });
  }
}
