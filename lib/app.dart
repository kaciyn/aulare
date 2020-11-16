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
  AulareApp();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigatorBloc>(
        create: (context) => NavigatorBloc(navigatorKey: _navigatorKey),
        child: MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'AULARE',
            theme: darkTheme,
            //TODO stick a toggle later for dark/light theme
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
              if (state is Uninitialized) {
                return Splash();
              } else if (state is Authenticated) {
                BlocProvider.of<MessagingBloc>(context)
                    .add(FetchConversationList());
                return HomePage();
              } else if (state is Unauthenticated) {
                return AuthenticationPage();
              } else {
                return AuthenticationPage();
              }
            }),
            routes: {
              // '/': (context) => Splash(),
              '/home': (context) => HomePage(),
              '/authentication': (context) => AuthenticationPage(),
              '/login': (context) => LoginPage(),
              '/register': (context) => RegistrationPage(),
            }));
  }
}
