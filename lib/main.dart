import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'StateObserver.dart';
import 'themes/defaultTheme.dart';
import 'views/chat/ConversationPage.dart';

void main() {
  StateObserver observer = StateObserver();
  runApp(AulareApp());
}

class AulareApp extends StatelessWidget {
  // const AulareApp({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
        blocProviders: <BlocProvider>[
          BlocProvider<AuthBloc>(bloc: AuthBloc()),
          BlocProvider<PrefBloc>(bloc: PrefBloc()),
        ],
    return MaterialApp(
      title: 'AULARE',
      theme: darkTheme, //TODO stick a toggle later for dark/light theme
      home: ChatPage(),
    );
  }
}
