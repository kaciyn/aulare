import 'package:aulare/app.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/bloc/authentication_repository.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final _authenticationRepository = AuthenticationRepository();
  final _userDataRepository = UserDataRepository();
  final _storageRepository = StorageRepository();
  final _messagingRepository = MessagingRepository();

  SharedObjects.preferences = (await CachedSharedPreferences.getInstance())!;
  Constants.cacheDirPath = (await getTemporaryDirectory()).path;
  // Constants.downloadsDirPath =
  //     (await DownloadsPathProvider.downloadsDirectory).path;

  //necessary even??
  BlocOverrides.runZoned(
    () {
      // ...
    },
    blocObserver: StateObserver(),
    // eventTransformer: customEventTransformer(),
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            authenticationRepository: _authenticationRepository,
            userDataRepository: _userDataRepository,
            storageRepository: _storageRepository)
          ..add(AppLaunched()),
      ),
      BlocProvider<ContactsBloc>(
        create: (context) => ContactsBloc(
            userDataRepository: _userDataRepository,
            messagingRepository: _messagingRepository),
      ),
      BlocProvider<MessagingBloc>(
        create: (context) => MessagingBloc(
            userDataRepository: _userDataRepository,
            storageRepository: _storageRepository,
            messagingRepository: _messagingRepository),
      ),
      // BlocProvider<AttachmentsBloc>(
      //   create: (context) => AttachmentsBloc(chatRepository: chatRepository),
      // ),
      BlocProvider<HomeBloc>(
        create: (context) =>
            HomeBloc(messagingRepository: _messagingRepository),
      ),
      // BlocProvider<ConfigBloc>(
      //   create: (context) => ConfigBloc(
      //       storageRepository: storageRepository,
      //       userDataRepository: userDataRepository),
      // )
    ],
    child: Aulare(),
  ));
}

class Aulare extends StatelessWidget {
  const Aulare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AulareApp();
  }
}
