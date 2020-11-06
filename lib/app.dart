import 'package:aulare/views/registration/registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'file:///D:/BigBadCodeRepos/aulare/lib/views/messages/bloc/messaging_page.dart';

import 'themes/defaultTheme.dart';
import 'views/registration/blocs/bloc.dart';

class AulareApp extends MaterialApp {
  AulareApp({Key key})
      : super(
            key: key,
            title: 'AULARE',
            theme: darkTheme, //TODO stick a toggle later for dark/light theme
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
              if (state is UnAuthenticated) {
                return RegistrationPage();
              } else if (state is ProfileUpdated) {
                return ConversationPage();
              } else {
                return RegistrationPage();
              }
            }));
}

// const AulareApp({
//   Key key,
// }) : super(key: key);

//this is the conprog way
// @override
// Widget build(BuildContext context) {
//   return BlocProviderTree(
//       blocProviders: <BlocProvider>[
//         BlocProvider<AuthBloc>(bloc: AuthBloc()),
//         BlocProvider<PrefBloc>(bloc: PrefBloc()),
//       ],
//       return MaterialApp(
//   title: 'AULARE',
//   theme: darkTheme, //TODO stick a toggle later for dark/light theme
//       home: ChatPage(),);
// }
