import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/providers/user_data_provider.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<void> logIn(String username, String password) =>
      userDataProvider.signIn(username, password);

  Future<void> signUp({String username, String password}) =>
      userDataProvider.signUp(username: username, password: password);

  Future<void> logOut() => userDataProvider.logOut();

  Future<bool> isSignedIn() => userDataProvider.isSignedIn();

  Future<User> getUser(String username) => userDataProvider.getUser(username);

  Future<String> authenticate(String username, String password) =>
      userDataProvider.authenticate(username: username, password: password);

  Future<void> deleteToken() => userDataProvider.deleteToken();

  Future<void> persistToken(String token) =>
      userDataProvider.persistToken(token);

  Future<bool> hasToken() => userDataProvider.hasToken();

  // Future<User> saveDetailsFromGoogleAuth(firebase.User user) =>
  //     userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(
          String uid, String profilePictureUrl, String username) =>
      userDataProvider.saveProfileDetails(uid, profilePictureUrl, username);

  Future<bool> isProfileComplete(String uid) =>
      userDataProvider.isProfileComplete(uid);

  Stream<List<Contact>> getContacts() => userDataProvider.getContacts();

  Future<void> addContact(String username) =>
      userDataProvider.addContact(username);

  Future<String> getUidByUsername(String username) =>
      userDataProvider.getUidByUsername(username);
}
