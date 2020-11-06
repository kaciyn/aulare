import 'package:aulare/app.dart';
import 'package:aulare/repositories/authentication_repository.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'StateObserver.dart';
import 'views/registration/blocs/bloc.dart';

void main() {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();

  StateObserver observer = StateObserver();

  runApp(BlocProvider(
    create: (BuildContext context) => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userDataRepository: userDataRepository,
        storageRepository: storageRepository)
      ..add(AppLaunched()),
    child: Aulare(),
  ));
}

class Aulare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AulareApp();
  }
}
