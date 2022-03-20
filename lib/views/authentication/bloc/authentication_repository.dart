import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/views/authentication/bloc/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../../models/user.dart';

class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();
  final firebase.FirebaseAuth firebaseAuth = firebase.FirebaseAuth.instance;

  Future<void> login({required String username, required String password}) =>
      authenticationProvider.login(username: username, password: password);

  Future<void> register({required String username, required String password}) =>
      authenticationProvider.register(username: username, password: password);

  Future<void> logout() => authenticationProvider.logout();

  Future<firebase.User?> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  User? get currentUser => authenticationProvider.currentUser;

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();
  //
  // Future<void> deleteToken() => authenticationProvider.deleteToken();
  //
  // Future<void> persistToken(String token) =>
  //     authenticationProvider.persistToken(token);
  //
  // Future<bool> hasToken() => authenticationProvider.hasToken();
}
