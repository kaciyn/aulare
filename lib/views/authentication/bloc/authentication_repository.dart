import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/views/authentication/bloc/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<firebase.User> login() => authenticationProvider.login();

  Future<firebase.User> signUp() => authenticationProvider.signUp();

  Future<firebase.User> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<void> logout() => authenticationProvider.logout();

  Future<firebase.User> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();
}
