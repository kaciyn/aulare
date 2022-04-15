//this is copied wholesale from https://medium.com/@adityadroid/60-days-of-flutter-building-a-messenger-day-15-17-implementing-registration-screen-using-d3a708d866a9
//i didn't write this!!!!

import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';

abstract class BaseProvider {
  void dispose();
}

// abstract class BaseAppProvider extends BaseProvider {
//   Future<void> logout();
//
//   // Future<firebase.User?> getCurrentUser();
//
//   Future<bool> isLoggedIn();
// }

abstract class BaseAuthenticationProvider extends BaseProvider {
  User? get currentUser => null;

  get user => null;

  Future<void> login({required String username, required String password});

  Future<void> register({required String username, required String password});

  Future<void> logout();

  Future<firebase.User?> getCurrentUser();

  Future<bool> isLoggedIn();

// Future<String> authenticate({
//   required String username,
//   required String password,
// });

// Future<void> deleteToken();
//
// Future<void> persistToken(String token);
//
// Future<bool> hasToken();
}

abstract class BaseUserDataProvider extends BaseProvider {
  Future<User> getUser({required String username});

  Future<User> saveProfileDetails(String id, String username
      // String profilePictureUrl,
      );

  // Future<bool> isProfileComplete(String id);

  Stream<List<Contact>> getContacts();

  // Future<List<Contact>?> getContactsList();

  // Future<void> addContact({required String contactUsername});
  Future<void> addContactAndCreateConversation(
      {required String contactUsername});

  Future<String?> getUserIdByUsername({required String username});
}

abstract class BaseStorageProvider extends BaseProvider {
  // Future<String> uploadImage(File file, String path);
}

abstract class BaseMessagingProvider extends BaseProvider {
  Stream<List<Conversation>> getConversationsWithLatestMessage();

  Stream<List<Conversation>> getConversations();

  Stream<List<Message>> getMessages(String conversationId);

  Future<List<Message>> getPreviousMessages(
      String conversationId, Message previousMessage);

  // Future<List<Message>> getAttachments(String conversationId, int type);

  Future<void> sendMessage(String conversationId, Message message);

  Future<String> getConversationIdByContactUsername(String username);

  Future<void> createConversationIdForContact(User user);
}
