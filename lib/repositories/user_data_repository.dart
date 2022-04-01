import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/providers/user_data_provider.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> getUser({required String username}) =>
      userDataProvider.getUser(username: username);

  Future<User> saveProfileDetails(
          String id,
          // String profilePictureUrl,
          String? username) =>
      userDataProvider.saveProfileDetails(
          id,
          // profilePictureUrl,
          username!);

  // Future<bool> isProfileComplete(String id) =>
  //     userDataProvider.isProfileComplete(id);

  Stream<List<Contact>> getContacts() => userDataProvider.getContacts();

  Future<void> addContact({required String username}) =>
      userDataProvider.addContact(contactUsername: username);

  Future<String?> getUidByUsername({required String username}) =>
      userDataProvider.getUserIdByUsername(username: username);
}
