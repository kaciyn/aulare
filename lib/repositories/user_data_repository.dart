import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/providers/user_data_provider.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> getUser(String username) => userDataProvider.getUser(username);

  Future<User> saveProfileDetails(
          String uid,
          // String profilePictureUrl,
          String username) =>
      userDataProvider.saveProfileDetails(
          uid,
          // profilePictureUrl,
          username);

  // Future<bool> isProfileComplete(String uid) =>
  //     userDataProvider.isProfileComplete(uid);

  Stream<List<Contact>> getContacts() => userDataProvider.getContacts();

  Future<void> addContact(String username) =>
      userDataProvider.addContact(username);

  Future<String> getUidByUsername(String username) =>
      userDataProvider.getUidByUsername(username);
}
