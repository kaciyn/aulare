import 'package:aulare/config/default_theme.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/routes.dart';
import 'package:aulare/views/authentication/authentication_page.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/bloc/authentication_repository.dart';
import 'package:aulare/views/authentication/components/splash.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/bloc/app_bloc.dart';

class AulareApp extends StatelessWidget {
  const AulareApp({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required UserDataRepository userDataRepository,
    required StorageRepository storageRepository,
    required MessagingRepository messagingRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userDataRepository = userDataRepository,
        _storageRepository = storageRepository,
        _messagingRepository = messagingRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;
  final UserDataRepository _userDataRepository;
  final StorageRepository _storageRepository;
  final MessagingRepository _messagingRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authenticationRepository),
          RepositoryProvider.value(value: _userDataRepository),
          RepositoryProvider.value(value: _storageRepository),
          RepositoryProvider.value(value: _messagingRepository),
        ],
        child: BlocProvider<AppBloc>(
          create: (_) => AppBloc(
            authenticationRepository: _authenticationRepository,
            messagingRepository: _messagingRepository,
            storageRepository: _storageRepository,
            userDataRepository: _userDataRepository,
          ),
          child: const AppView(),
        ));
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AULARE',
      theme: darkTheme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     // return BlocProvider<AuthenticationBloc>.value(
//     //     value: BlocProvider.of<AuthenticationBloc>(context),
//     //     child:
//     return MaterialApp(
//       title: 'AULARE',
//       theme: darkTheme,
//       home: FlowBuilder<AppStatus>(
//         state: context.select((AppBloc bloc) => bloc.state.status),
//         onGeneratePages: onGenerateAppViewPages,
//       ),
//     );
//   }
// }
// class MyRouterDelegate extends RouterDelegate
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin {
//   MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
//   @override
//   final GlobalKey<NavigatorState> navigatorKey;
//
//   bool showOtherPage = false;
//
//   @override
//   Widget build(BuildContext context)  {
//     return BlocBuilder<AuthenticationBloc, AuthenticationState>(
//       builder: (context, state) {
//         return Navigator(
//           key: navigatorKey,
//           pages: [
//             const MaterialPage(
//               key: ValueKey('AuthenticationPage'),
//               child: AuthenticationPage(),
//             ),
//             // if (state is Uninitialized)
//             //   MaterialPage(
//             //     key: const ValueKey('SplashPage'),
//             //     child: Splash(),
//             //   ),
//             if (state is Authenticated)
//               // BlocProvider.of<MessagingBloc>(context).add(FetchConversationList())
//               const MaterialPage(
//                 key: ValueKey('HomePage'),
//                 child: HomePage(),
//               ),
//             if (state is Unauthenticated)
//               const MaterialPage(
//                 key: ValueKey('AuthenticationPage'),
//                 child: AuthenticationPage(),
//               ),
//           ],
//           onPopPage: (route, result) {
//             if (!route.didPop(result)) {
//               return false;
//             }
//             BlocProvider.of<MessagingBloc>(context)
//                 .add(FetchConversationList());
//             BlocProvider.of<AuthenticationBloc>(context).add(Logout());
//             return true;
//           },
//         );
//       },
//     );
//   }
//
// //for named navigation
//   @override
//   Future<void> setNewRoutePath(configuration) async => null;
// }

// @override
// Widget build(BuildContext context) {
//   return BlocProvider<NavigatorBloc>(
//       create: (context) => NavigatorBloc(navigatorKey: _navigatorKey),
//       child: MaterialApp(
//           navigatorKey: _navigatorKey,
//           title: 'AULARE',
//           theme: darkTheme,
//           //TODO stick a toggle later for dark/light theme
//           home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//               builder: (context, state) {
//                 if (state is Uninitialized) {
//                   return Splash();
//                 } else if (state is Authenticated) {
//                   BlocProvider.of<MessagingBloc>(context)
//                       .add(FetchConversationList());
//                   return HomePage();
//                 } else if (state is Unauthenticated) {
//                   return AuthenticationPage();
//                 } else {
//                   return AuthenticationPage();
//                 }
//               }),
//           routes: {
//             // '/': (context) => Splash(),
//             '/home': (context) => HomePage(),
//             '/authentication': (context) => AuthenticationPage(),
//             '/login': (context) => LoginPage(),
//             '/register': (context) => RegistrationPage(),
//           }));
// }
// }
