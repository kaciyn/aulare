import 'package:aulare/config/assets.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Container authenticationButton(String buttonLabel,
    AuthenticationEvent authenticationEvent, BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top: 100),
      child: FlatButton.icon(
          onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
              .add(authenticationEvent),
          color: Colors.transparent,
          icon: Image.asset(
            Assets.google_button,
            height: 25,
          ),
          label: Text(buttonLabel,
              style: const TextStyle(
                  // color: darkTheme.primaryTextColorLight,
                  fontWeight: FontWeight.w800))));
}
