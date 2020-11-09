import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final firebase.FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<firebase.User> signInWithGoogle() async {
    final account = await googleSignIn.signIn(); //show the goggle login prompt

    final authentication =
        await account.authentication; //get the authentication object

    final credential = GoogleAuthProvider.credential(
        //retrieve the authentication credentials
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    await firebaseAuth.signInWithCredential(
        credential); //sign in to firebase using the generated credentials

    final firebaseUser = firebaseAuth.currentUser;

    await SharedObjects.preferences
        .setString(Constants.sessionUid, firebaseUser.uid);

    return firebaseAuth.currentUser; //return the firebase user created
  }

  @override
  Future<void> signOutUser() async {
    return Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut()
    ]); // terminate the session
  }

  @override
  Future<firebase.User> getCurrentUser() async {
    return await firebaseAuth.currentUser; //retrieve the current user
  }

  @override
  Future<bool> isLoggedIn() async {
    final user =
        await firebaseAuth.currentUser; //check if user is logged in or not
    return user != null;
  }
}
