import 'dart:async';

import 'package:aulare/config/paths.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/conversations/models/conversation.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingProvider extends BaseMessagingProvider {
  MessagingProvider({FirebaseFirestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? FirebaseFirestore.instance;

  final FirebaseFirestore fireStoreDb;

  @override
  Stream<List<Conversation>> getConversations() {
    final uid = SharedObjects.preferences.getString(Constants.sessionUid);
    return fireStoreDb
        .collection(Paths.usersPath)
        .doc(uid)
        .snapshots()
        .transform(StreamTransformer<DocumentSnapshot,
                List<Conversation>>.fromHandlers(
            handleData: (DocumentSnapshot documentSnapshot,
                    EventSink<List<Conversation>> sink) =>
                mapDocumentToConversation(documentSnapshot, sink)));
  }

  Future<void> mapDocumentToConversation(
      DocumentSnapshot documentSnapshot, EventSink sink) async {
    final conversations = <Conversation>[];
    final Map data = documentSnapshot.data()['conversations'];
    if (data != null) {
      data.forEach((key, value) => conversations.add(Conversation(key, value)));
      sink.add(conversations);
    }
  }

  @override
  Stream<List<Message>> getMessages(String conversationId) {
    final messagingDocumentReference =
        fireStoreDb.collection(Paths.conversationsPath).doc(conversationId);
    final messagesCollection =
        messagingDocumentReference.collection(Paths.messagesPath);
    return messagesCollection
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
                    mapDocumentToMessage(querySnapshot, sink)));
  }

  Future<void> mapDocumentToMessage(
      QuerySnapshot querySnapshot, EventSink sink) async {
    final messages = <Message>[];
    for (final DocumentSnapshot document in querySnapshot.docs) {
      print(document.data);
      messages.add(Message.fromFireStore(document));
    }
    sink.add(messages);
  }

  @override
  Future<void> sendMessage(String conversationId, Message message) async {
    final conversationDocument =
        fireStoreDb.collection(Paths.conversationsPath).doc(conversationId);
    final messagesCollection =
        conversationDocument.collection(Paths.messagesPath);
    await messagesCollection.add(message.toMap());
    await conversationDocument.update({'latestMessage': message.toMap()});
  }

  @override
  Future<String> getConversationIdByUsername(String username) async {
    final uId = SharedObjects.preferences.getString(Constants.sessionUid);
    final selfUsername =
        SharedObjects.preferences.getString(Constants.sessionUsername);
    final userRef = fireStoreDb.collection(Paths.usersPath).doc(uId);
    final documentSnapshot = await userRef.get();
    String chatId = documentSnapshot.data()['conversations'][username];
    if (chatId == null) {
      chatId = await createConversationIdForUsers(selfUsername, username);
      await userRef.update({
        'conversations': {username: chatId}
      });
    }
    return chatId;
  }

  @override
  Future<void> createConversationIdForContact(User user) async {
    final contactUid = user.documentId;
    final contactUsername = user.username;
    final uId = SharedObjects.preferences.getString(Constants.sessionUid);

    final selfUsername =
        SharedObjects.preferences.getString(Constants.sessionUsername);

    final usersCollection = fireStoreDb.collection(Paths.usersPath);

    final userReference = usersCollection.doc(uId);

    final contactReference = usersCollection.doc(contactUid);

    final userSnapshot = await userReference.get();

    if (userSnapshot.data()['conversations'] == null ||
        userSnapshot.data()['conversations'][contactUsername] == null) {
      final conversationId =
          await createConversationIdForUsers(selfUsername, contactUsername);
      await userReference.set({
        'conversations': {contactUsername: conversationId}
      }, SetOptions(merge: true));
      await contactReference.set({
        'conversations': {selfUsername: conversationId}
      }, SetOptions(merge: true));
    }
  }

  Future<String> createConversationIdForUsers(
      String selfUsername, String contactUsername) async {
    final collectionReference = fireStoreDb.collection(Paths.conversationsPath);
    final documentReference = await collectionReference.add({
      'members': [selfUsername, contactUsername]
    });
    return documentReference.id;
  }

  @override
  void dispose() {
    // if (conversationStreamController != null)
    //   conversationStreamController.close();
  }
}
