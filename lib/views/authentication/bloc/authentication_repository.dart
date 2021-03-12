import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/views/authentication/bloc/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<void> login(String username, String password) =>
      authenticationProvider.login(username, password);

  Future<void> register(String username, String password) =>
      authenticationProvider.register(username, password);

  Future<void> logout() => authenticationProvider.logout();

  Future<firebase.User> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();

  Future<void> deleteToken() => authenticationProvider.deleteToken();

  Future<void> persistToken(String token) =>
      authenticationProvider.persistToken(token);

  Future<bool> hasToken() => authenticationProvider.hasToken();


}
