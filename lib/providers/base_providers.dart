import 'dart:io';

import 'package:aulare/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

abstract class BaseAuthenticationProvider {
  Future<firebase.User> signInWithGoogle();

  Future<void> signOutUser();

  Future<firebase.User> getCurrentUser();

  Future<bool> isLoggedIn();
}

abstract class BaseUserDataProvider {
  Future<User> saveDetailsFromGoogleAuth(firebase.User user);

  Future<User> saveProfileDetails(
      String uid, String profileImageUrl, String username);

  Future<bool> isProfileComplete(String uid);
}

abstract class BaseStorageProvider {
  Future<String> uploadImage(File file, String path);
}
