import 'dart:async';

import 'package:aulare/config/paths.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/messaging/models/chat.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
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
    //watch out! this isn't conversations but it's chat but we'll see about merging the two
    final conversations = <Chat>[];
    final Map data = documentSnapshot.data()['conversations'];
    if (data != null) {
      data.forEach((key, value) => conversations.add(Chat(key, value)));
      sink.add(conversations);
    }
  }

  @override
  Stream<List<Message>> getMessages(String conversationId) {
    final messagingDocument =
        fireStoreDb.collection(Paths.conversationsPath).doc(conversationId);
    final messagesCollection = messagingDocument.collection(Paths.messagesPath);
    return messagesCollection
        .orderBy('timestamp', descending: true)
        .limit(20)
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
  Future<List<Message>> getPreviousMessages(
      String conversationId, Message previousMessage) async {
    final messagingDocument =
        fireStoreDb.collection(Paths.conversationsPath).doc(conversationId);

    final messagesCollection = messagingDocument.collection(Paths.messagesPath);

    DocumentSnapshot previousDocument;
    previousDocument = await messagesCollection
        .doc(previousMessage.documentId)
        .get(); // gets a reference to the last message in the existing list
    final querySnapshot = await messagesCollection
        .startAfterDocument(
            previousDocument) // Start reading documents after the specified document
        .orderBy('timeStamp', descending: true) // order them by timestamp
        .limit(20) // limit the read to 20 items
        .get();
    final messageList = <Message>[];
    querySnapshot.docs
        .forEach((doc) => messageList.add(Message.fromFireStore(doc)));
    return messageList;
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
    String conversationId = documentSnapshot.data()['conversations'][username];
    if (conversationId == null) {
      conversationId =
          await createConversationIdForUsers(selfUsername, username);
      await userRef.update({
        'conversations': {username: conversationId}
      });
    }
    return conversationId;
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
