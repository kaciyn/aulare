import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Expanded authenticationButton(String buttonLabel, Icon icon,
    AuthenticationEvent authenticationEvent, BuildContext context) {
  return Expanded(
    child: Container(
        margin: const EdgeInsets.only(top: 100, right: 10, left: 10),
        decoration:
            BoxDecoration(border: Border.all(color: darkTheme.accentColor)),
        child: FlatButton.icon(
            onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
                .add(authenticationEvent),
            color: Colors.transparent,
            icon: icon,
            label: Text(buttonLabel,
                style: const TextStyle(
                    // color: darkTheme.primaryTextColorLight,
                    fontWeight: FontWeight.w800)))),
  );
}
