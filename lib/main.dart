import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'themes/defaultTheme.dart';
import 'views/chat/ChatScreen.dart';
import 'StateObserver.dart';

void main() {
  StateObserver observer=StateObserver();
  runApp(AulareApp());
}


class AulareApp extends StatelessWidget {
  const AulareApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AULARE',
      theme: darkTheme, //TODO stick a toggle later for dark/light theme
      home: ChatPage(),
    );
  }
}


class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1);
}
