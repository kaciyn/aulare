import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<firebase.User> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => authenticationProvider.signOutUser();

  Future<firebase.User> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();
}
