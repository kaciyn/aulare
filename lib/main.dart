import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'themes/defaultTheme.dart';
import 'screens/chat/ChatScreen.dart';

void main() {
  runApp(ChatboyApp());
}


class ChatboyApp extends StatelessWidget {
  const ChatboyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AULARE',
      theme: darkTheme, //TODO stick a toggle later for dark/light theme
      home: ChatScreen(),
    );
  }
}


class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1);
}
