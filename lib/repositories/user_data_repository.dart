import 'package:aulare/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> saveDetailsFromGoogleAuth(firebase.User user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(
          String uid, String profileImageUrl, String username) =>
      userDataProvider.saveProfileDetails(uid, profileImageUrl, username);

  Future<bool> isProfileComplete(String uid) =>
      userDataProvider.isProfileComplete(uid);
}
