import 'package:aulare/views/authentication/authentication_page.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:flutter/widgets.dart';

List<Page> onGenerateAppViewPages(
    AuthenticationState state, List<Page<dynamic>> pages) {
  if (state is Authenticated) {
    return [HomePage.page()];
  } else if (state is Unauthenticated) {
    return [AuthenticationPage.page()];
  }
}
