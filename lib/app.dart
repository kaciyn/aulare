import 'package:flutter/material.dart';

import 'themes/defaultTheme.dart';

// import 'counter/counter.dart';

class AulareApp extends MaterialApp {
  const AulareApp({Key key})
      : super(
            key: key,
            title: 'AULARE',
            theme:
                darkTheme, //TODO stick a toggle later for dark/light theme ALSO HOW DO I SET THIS WITH A CONST APP
            home: const ChatScreen());
}
