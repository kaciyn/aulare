import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> saveDetailsFromGoogleAuth(firebase.User user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(
          String uid, String profileImageUrl, String username) =>
      userDataProvider.saveProfileDetails(uid, profileImageUrl, username);

  // Future<bool> isProfileComplete(String uid) =>
  //     userDataProvider.isProfileComplete(uid);

  Stream<List<Contact>> getContacts() => userDataProvider.getContacts();

  Future<void> addContact(String username) =>
      userDataProvider.addContact(username);

  Future<User> getUser(String username) => userDataProvider.getUser(username);

  Future<String?> getUidByUsername(String username) =>
      userDataProvider.getUidByUsername(username);
}
