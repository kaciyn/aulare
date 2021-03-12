import 'package:aulare/app.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/registration/bloc/authentication_bloc.dart';
import 'package:aulare/views/registration/bloc/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'StateObserver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authenticationRepository = AuthenticationRepository();
  final userDataRepository = UserDataRepository();
  final storageRepository = StorageRepository();

  var observer = StateObserver();

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
