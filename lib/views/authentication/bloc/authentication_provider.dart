import 'package:aulare/providers/base_providers.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final firebase.FirebaseAuth firebaseAuth = firebase.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<firebase.User> login() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<firebase.User> signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    return Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut()
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
