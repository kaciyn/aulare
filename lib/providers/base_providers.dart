//this is copied wholesale from https://medium.com/@adityadroid/60-days-of-flutter-building-a-messenger-day-15-17-implementing-registration-screen-using-d3a708d866a9
//i didn't write this!!!!

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
      String uid, String profileImageUrl, int age, String username);

  Future<bool> isProfileComplete(String uid);
}

abstract class BaseStorageProvider {
  Future<String> uploadImage(File file, String path);
}

abstract class BaseMessagingProvider {
  // Stream<List<Conversation>> getConversations();
  //
  // Stream<List<Message>> getMessages(String chatId);
  //
  // Future<List<Message>> getPreviousMessages(String chatId, Message prevMessage);
  //
  // Future<List<Message>> getAttachments(String chatId, int type);
  //
  // Stream<List<Conversation>> getChats();
  //
  // Future<void> sendMessage(String chatId, Message message);
  //
  // Future<String> getChatIdByUsername(String username);
  //
  // Future<void> createChatIdForContact(User user);
}
