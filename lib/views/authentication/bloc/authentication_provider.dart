import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';

import '../../../cache.dart';
import '../../../config/firebase_paths.dart';
import '../../../models/user.dart';
import '../../../utilities/constants.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final firebase.FirebaseAuth firebaseAuth = firebase.FirebaseAuth.instance;
  final fireStoreDb = FirebaseFirestore.instance;

  final CacheClient cache = CacheClient();

  @override
  Future<void> login(
      {required String username, required String password}) async {
    final mockEmail = username + '@aula.re';
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: mockEmail,
        password: password,
      );
      final firebaseUser = firebaseAuth.currentUser!;
      SharedObjects.preferences
          .setString(Constants.sessionUid, firebaseUser.uid);

      print('Logged in.');
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that username.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Future<void> register(
      {
      // required String displayName,
      required String username,
      required String password}) async {
    // displayName = displayName.trim();
    username = username.trim();
    password = password.trim();
    final mockEmail = username + '@aula.re';

    try {
      //creates user in firebase
      await firebaseAuth.createUserWithEmailAndPassword(
          email: mockEmail, password: password);
      //todo check that this sets the new user as the currentuser
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
    } catch (e) {
      rethrow;
    }

    await login(username: mockEmail, password: password);

    final newUser = firebaseAuth.currentUser;
    var newUserUid = '';
    if (newUser != null) {
      newUserUid = newUser.uid;
      // try {
      final usersCollectionReference =
          fireStoreDb.collection(FirebasePaths.usersPath);

      //adds new user+details to user collection
      usersCollectionReference.doc(newUserUid).set({
        'id': newUserUid,
        // 'displayName': displayName,
        'username': username
      }).catchError((error) => print("Failed to add user: $error"));

      //add username/uid mapping
      final usernameUidMapPathCollectionReference =
          fireStoreDb.collection(FirebasePaths.usernameUidMapPath);

      usernameUidMapPathCollectionReference
          .doc(newUserUid)
          .set({'uid': newUserUid, 'username': username}).catchError(
              (error) => print("Failed to add user/uid map: $error"));
    } //todo proper error handling
    else {
      print('ERROR: NO CURRENT USER');
      return;
    }
    SharedObjects.preferences.setString(Constants.sessionUsername, username);
    SharedObjects.preferences.setString(Constants.sessionUid, newUserUid);
  }

  @override
  Future<void> logout() async {
    Future.wait([
      firebaseAuth.signOut(),
    ]); // terminate the session
  }

  @override
  Future<firebase.User?> getCurrentUser() async {
    return firebaseAuth.currentUser; //retrieve the current user
  }

  static const userCacheKey = '__user_cache_key__';

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  @override
  User get currentUser {
    return cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  @override
  Stream<User> get user {
    return firebaseAuth.authStateChanges().map((firebaseUser) {
      final User user;
      if (firebaseUser == null) {
        user = User.empty;
      } else {
        user = firebaseUser.toUser;
      }
      cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = firebaseAuth.currentUser; //check if user is logged in or not
    return user != null;
  }

  @override
  void dispose() {}
}

extension on firebase.User {
  User get toUser {
    final username = email?.replaceAll('@aula.re', '');
    return User(
      id: uid,
      username: username,
      // name: displayName,
      // profilePictureUrl: photoURL
    );
  }
}
