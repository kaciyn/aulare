import 'package:aulare/app.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
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

import 'StateObserver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authenticationRepository = AuthenticationRepository();
  final userDataRepository = UserDataRepository();
  final storageRepository = StorageRepository();
  final messagingRepository = MessagingRepository();

  // SharedObjects.preferences = await CachedSharedPreferences.getInstance();
  // Constants.cacheDirPath = (await getTemporaryDirectory()).path;
  // Constants.downloadsDirPath =
  //     (await DownloadsPathProvider.downloadsDirectory).path;
  //
  // final observer = StateObserver();
  //
  // Bloc.observer = observer;

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
            authenticationRepository: authenticationRepository,
            userDataRepository: userDataRepository,
            storageRepository: storageRepository)
          ..add(AppLaunched()),
      ),
      BlocProvider<ContactsBloc>(
        create: (context) => ContactsBloc(
            userDataRepository: userDataRepository,
            messagingRepository: messagingRepository),
      ),
      BlocProvider<MessagingBloc>(
        create: (context) => MessagingBloc(
            userDataRepository: userDataRepository,
            storageRepository: storageRepository,
            messagingRepository: messagingRepository),
      ),
      // BlocProvider<AttachmentsBloc>(
      //   create: (context) => AttachmentsBloc(chatRepository: chatRepository),
      // ),
      BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(messagingRepository: messagingRepository),
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
  @override
  Widget build(BuildContext context) {
    return AulareApp();
  }
}
