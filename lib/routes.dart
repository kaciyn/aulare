import 'package:aulare/app/bloc/app_bloc.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/views/authentication/authentication_page.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:aulare/views/login/login_page.dart';
import 'package:aulare/views/registration/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:routemaster/routemaster.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [AuthenticationPage.page()];
  }
}

// List<Page> onGenerateHomePages(HomeState state, List<Page<dynamic>> pages) {}
final routes = RouteMap(routes: {
  '/home': (_) => const MaterialPage(child: HomePage()),
  // '/settings': (_) => MaterialPage(child: SettingsPage()),
  '/authentication': (_) => const MaterialPage(child: AuthenticationPage()),
  '/login': (_) => const MaterialPage(child: LoginPage()),
  '/register': (_) => const MaterialPage(child: RegistrationPage()),
  // '/messages': (_) => const MaterialPage(child: HomePage()),
  // '/account': (_) => const MaterialPage(child: HomePage()),

  // '/feed/profile/:id': (info) =>
  //     MaterialPage(child: ProfilePage(id: info.pathParameters['id'])),
});
