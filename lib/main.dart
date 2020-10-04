import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp(
    home: MyAppHome(),
    routes:<String,WidgetBuilder>{
      '/welcome':(BuildContext context) => MyPage(title: 'Welcome Page'),
      '/login': (BuildContext context) => MyPage(title: 'Login'),
      '/message': (BuildContext context) => MyPage(title: 'Message'),
    },
  ));

}

class CounterCubit extends Cubit<int>{
  CounterCubit(int initialState):super(initialState);
  void increment ()=>emit(state+1);
}
