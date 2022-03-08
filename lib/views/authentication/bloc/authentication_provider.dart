import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final firebase.FirebaseAuth firebaseAuth = firebase.FirebaseAuth.instance;

  @override
  Future<void> login(String? username, String? password) async {
    final mockEmail = username! + '@aula.re';
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: mockEmail, password: password ?? '');
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that username.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Future<void> register(String? username, String? password) async {
    username = username!.trim();
    password = password!.trim();
    final mockEmail = username + '@aula.re';

    try {
      firebaseAuth.createUserWithEmailAndPassword(
          email: mockEmail, password: password);
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
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

  @override
  Future<bool> isLoggedIn() async {
    final user = firebaseAuth.currentUser; //check if user is logged in or not
    return user != null;
  }

  @override
  void dispose() {}

  @override
  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  @override
  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }

  @override
  Future<String> authenticate({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'token';
  }

  @override
  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
}
