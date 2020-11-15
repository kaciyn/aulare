import 'package:aulare/views/authentication/authentication_page.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/splash.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/defaultTheme.dart';

class AulareApp extends MaterialApp {
  AulareApp({Key key})
      : super(
            key: key,
            title: 'AULARE',
            theme: darkTheme, //TODO stick a toggle later for dark/light theme
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
              if (state is Uninitialized) {
                return Splash();
              } else if (state is Authenticated) {
                return HomePage();
              } else if (state is Unauthenticated) {
                return AuthenticationPage();
              } else {
                return AuthenticationPage();
              }
            }));
}
