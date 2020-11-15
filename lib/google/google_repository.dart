import 'package:aulare/google/google_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class GoogleRepository {
  GoogleProvider googleProvider = GoogleProvider();

  Future<firebase.User> signInWithGoogle() => googleProvider.signInWithGoogle();
}
