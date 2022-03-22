import 'package:aulare/app/bloc/app_bloc.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/views/authentication/authentication_page.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:flutter/widgets.dart';

// List<Page> onGenerateAppViewPages(
//     AuthenticationState state, List<Page<dynamic>> pages) {
//   if (state is Authenticated) {
//     return [HomePage.page()];
//   } else if (state is Unauthenticated) {
//     return [AuthenticationPage.page()];
//   } else {
//     print('Current state:' + state.toString());
//
//     throw InvalidStateException();
//   }
// }

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [AuthenticationPage.page()];
  }
}