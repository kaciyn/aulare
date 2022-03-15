import 'package:aulare/config/default_theme.dart';
import 'package:aulare/views/authentication/authentication_page.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/splash.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AulareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: MaterialApp(
          title: 'AULARE',
          theme: darkTheme,
          home: Router(routerDelegate: MyRouterDelegate()),
        ));
  }
}

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  bool showOtherPage = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Navigator(
          key: navigatorKey,
          pages: [
            const MaterialPage(
              key: ValueKey('AuthenticationPage'),
              child: AuthenticationPage(),
            ),
            // if (state is Uninitialized)
            //   MaterialPage(
            //     key: const ValueKey('SplashPage'),
            //     child: Splash(),
            //   ),
            if (state is Authenticated)
              // BlocProvider.of<MessagingBloc>(context).add(FetchConversationList())
              const MaterialPage(
                key: ValueKey('HomePage'),
                child: HomePage(),
              ),
            if (state is Unauthenticated)
              const MaterialPage(
                key: ValueKey('AuthenticationPage'),
                child: AuthenticationPage(),
              ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            BlocProvider.of<MessagingBloc>(context)
                .add(FetchConversationList());
            BlocProvider.of<AuthenticationBloc>(context).add(Logout());
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

class MyConnectionWidget extends StatelessWidget {
  const MyConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator 2.0 101 - Connexion screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.greenAccent,
                child: const Text('Click me to connect.'),
              ),
              // onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
              //     .add(Login(username: null, password: null)),
            )
          ],
        ),
      ),
    );
  }
}

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
