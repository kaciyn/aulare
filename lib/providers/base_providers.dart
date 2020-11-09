//this is copied wholesale from https://medium.com/@adityadroid/60-days-of-flutter-building-a-messenger-day-15-17-implementing-registration-screen-using-d3a708d866a9
//i didn't write this!!!!

import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/views/messaging/bloc/message.dart';
import 'package:aulare/views/rooms/components/room.dart';
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

  Stream<List<Contact>> getContacts();

  Future<void> addContact(String username);

  Future<User> getUser(String username);

  Future<String> getUidByUsername(String username);
}

abstract class BaseStorageProvider {
  // Future<String> uploadImage(File file, String path);
}

abstract class BaseMessagingProvider {
  Stream<List<Room>> getConversations();

  Stream<List<Message>> getMessages(String chatId);

  Future<List<Message>> getPreviousMessages(String chatId, Message prevMessage);

  Future<List<Message>> getAttachments(String chatId, int type);

  Stream<List<Room>> getChats();

  Future<void> sendMessage(String chatId, Message message);

  Future<String> getChatIdByUsername(String username);

  Future<void> createChatIdForContact(User user);
}
