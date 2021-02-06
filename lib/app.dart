import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/navigator/navigator_bloc.dart';
import 'package:aulare/views/authentication/authentication_page.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/splash.dart';
import 'package:aulare/views/authentication/login_page.dart';
import 'package:aulare/views/authentication/registration_page.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AulareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (_) => AuthenticationBloc(),
      child: MaterialApp(
        home: Router(routerDelegate: MyRouterDelegate()),
      ),
    );
  }
}

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  bool showOtherPage = false;
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  // @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<AuthenticationBloc, AuthenticationState>(
  //     builder: (context, authenticationState) {
  //       return Navigator(
  //         key: navigatorKey,
  //         pages: [
  //           MaterialPage(
  //             key: ValueKey('MyConnectionPage'),
  //             child: MyConnexionWidget(),
  //           ),
  //           if (authenticationState is AuthenticatedState)
  //             MaterialPage(
  //               key: ValueKey('MyHomePage'),
  //               child: MyHomeWidget(),
  //             ),
  //         ],
  //         onPopPage: (route, result) {
  //           if (!route.didPop(result)) return false;
  //
  //           BlocProvider.of<AuthenticationBloc>(context).add(UserLogoutEvent());
  //           return true;
  //         },
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder <AuthenticationBloc
    ,
        AuthenticationState>
      (builder: (context, state) {
      return Navigator(
        key: navigatorKey,
        pages: [
          if (state is Uninitialized)
            MaterialPage(
              key: ValueKey('SplashPage'),
              child: Splash(),
            ),
          if (state is Authenticated)
          // BlocProvider.of<MessagingBloc>(context).add(FetchConversationList())
            const MaterialPage(
              key: ValueKey('HomePage'),
              child: HomePage(),
            ),
          if (state is Unauthenticated)
          // BlocProvider.of<MessagingBloc>(context).add(FetchConversationList())
            MaterialPage(
              key: const ValueKey('AuthenticationPage'),
              child: AuthenticationPage(),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          BlocProvider.of<MessagingBloc>(context).add(FetchConversationList());

          // BlocProvider.of<AuthenticationBloc>(context).add(UserLogoutEvent());
          return true;
        },
      );
    },
    );
  }

//for named navigation
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}


// class MyConnectionWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navigator 2.0 101 - Connexion screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             FlatButton(
//               child: Container(
//                 padding: EdgeInsets.all(8.0),
//                 color: Colors.greenAccent,
//                 child: Text('Click me to connect.'),
//               ),
//               onPressed: () =>
//                   BlocProvider.of<AuthenticationBloc>(context).add(UserLoginEvent()),
//             )
//           ],
//         ),
//       ),
//     );
//   }
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
