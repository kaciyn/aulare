import 'package:aulare/providers/base_providers.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthenticationProvider extends BaseAuthenticationProvider {
  final firebase.FirebaseAuth firebaseAuth = firebase.FirebaseAuth.instance;

  @override
  Future<void> login(String username, String password) {
    final email = username + 'aula.re';
    return firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //automatically logs new user in
  @override
  Future<void> register(String username, String password) {
    final email = username + 'aula.re';
    return firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> logout() async {
    return Future.wait([
      firebaseAuth.signOut(),
    ]); // terminate the session
  }

  @override
  Future<firebase.User> getCurrentUser() async {
    return firebaseAuth.currentUser; //retrieve the current user
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = firebaseAuth.currentUser; //check if user is logged in or not
    return user != null;
  }

  @override
  void dispose() {}
}
