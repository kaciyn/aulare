// ignore_for_file: unnecessary_cast

import 'dart:async';

import 'package:aulare/config/firebase_paths.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingProvider extends BaseMessagingProvider {
  MessagingProvider({FirebaseFirestore? fireStoreDb})
      : fireStoreDb = fireStoreDb ?? FirebaseFirestore.instance;

  final FirebaseFirestore fireStoreDb;
  late StreamController<List<Conversation>> conversationInfoStreamController;

  @override
  Stream<List<Conversation>> getConversationsWithLatestMessage() {
    conversationInfoStreamController = StreamController();
    conversationInfoStreamController.sink;
    final username =
        SharedObjects.preferences.getString(Constants.sessionUsername);
//get all the chats the user is part of
    //won't get anything if there's no messages in conversation yet

    final userConversationDocuments = fireStoreDb
        .collection(FirebasePaths.conversationsPath)
        .where('members', arrayContains: username);

    final orderedUserConversationDocuments = userConversationDocuments
        .orderBy('latestMessage.timestamp',
            descending: true) //order by timestamp . latest on top
        .snapshots();

    return orderedUserConversationDocuments.transform(StreamTransformer<
                QuerySnapshot<Map<String, dynamic>>,
                List<Conversation>>.fromHandlers(
            handleData: (QuerySnapshot<Map<String, dynamic>> querySnapshot,
                    EventSink<List<Conversation>> sink) =>
                mapQueryToConversationInfo(querySnapshot, sink))
        as StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
            List<Conversation>>);
  }

  void mapQueryToConversationInfo(
      QuerySnapshot<Map<String, dynamic>> querySnapshot,
      EventSink<List<Conversation>> sink) {
    final conversations = <Conversation>[];
    for (final document in querySnapshot.docs) {
      conversations.add(Conversation.fromFireStore(document));
    }
    sink.add(conversations);
  }

  @override
  Stream<List<Conversation>> getConversations() {
    final userId = SharedObjects.preferences.getString(Constants.sessionUserId);

    return fireStoreDb
        .collection(FirebasePaths.usersPath)
        .doc(userId)
        .snapshots()
        .transform(StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
                    List<Conversation>>.fromHandlers(
                handleData:
                    (DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
                            EventSink<List<Conversation>> sink) =>
                        mapDocumentToConversation(documentSnapshot, sink))
            as StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
                List<Conversation>>);
  }

  Future<void> mapDocumentToConversation(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
      EventSink sink) async {
    final conversations = <Conversation>[];

    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

    final Map conversationData = data['conversations'];

    conversationData.forEach((key, value) =>
        conversations.add(Conversation.withoutLatestMessage(key, value)));
    sink.add(conversations);
  }

  @override
  Stream<List<Message>> getMessages(String conversationId) {
    final messagingDocument = fireStoreDb
        .collection(FirebasePaths.conversationsPath)
        .doc(conversationId);
    final messagesCollection =
        messagingDocument.collection(FirebasePaths.messagesPath);
    return messagesCollection
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
                List<Message>>.fromHandlers(
            handleData: (QuerySnapshot<Map<String, dynamic>> querySnapshot,
                    EventSink<List<Message>> sink) =>
                mapDocumentToMessage(querySnapshot, sink)) as StreamTransformer<
            QuerySnapshot<Map<String, dynamic>>, List<Message>>);
  }

  Future<void> mapDocumentToMessage(
      QuerySnapshot<Map<String, dynamic>> querySnapshot, EventSink sink) async {
    final messages = <Message>[];
    for (final DocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      // print(document.data);
      messages.add(Message.fromFireStore(document));
    }
    sink.add(messages);
  }

  @override
  Future<List<Message>> getPreviousMessages(
      String conversationId, Message previousMessage) async {
    final messagingDocument = fireStoreDb
        .collection(FirebasePaths.conversationsPath)
        .doc(conversationId);

    final messagesCollection =
        messagingDocument.collection(FirebasePaths.messagesPath);

    DocumentSnapshot previousDocument;
    previousDocument = await messagesCollection
        .doc(previousMessage.id)
        .get(); // gets a reference to the last message in the existing list
    final querySnapshot = await messagesCollection
        .startAfterDocument(
            previousDocument) // Start reading documents after the specified document
        .orderBy('timeStamp', descending: true) // order them by timestamp
        .limit(20) // limit the read to 20 items
        .get();
    final messageList = <Message>[];
    for (final doc in querySnapshot.docs) {
      messageList.add(Message.fromFireStore(doc));
    }
    return messageList;
  }

  @override
  Future<void> sendMessage(String conversationId, Message message) async {
    final conversationDocument = fireStoreDb
        .collection(FirebasePaths.conversationsPath)
        .doc(conversationId);

    var messageToMap = message.toMap();

    await conversationDocument
        .collection(FirebasePaths.messagesPath)
        .add(messageToMap);

    // await conversationDocument
    //     .set({'latestMessage': message.toMap()}, SetOptions(merge: true));
    // await messagesCollection.add(message.toMap());
    await conversationDocument.update({'latestMessage': message.toMap()});
  }

  @override
  Future<String> getConversationIdByContactUsername(
      String? contactUsername) async {
    final userId = SharedObjects.preferences.getString(Constants.sessionUserId);
    final username =
        SharedObjects.preferences.getString(Constants.sessionUsername);
    final userRef = fireStoreDb.collection(FirebasePaths.usersPath).doc(userId);
    final documentSnapshot = await userRef.get();
    String? conversationId =
        documentSnapshot.data()!['conversations'][contactUsername];
    if (conversationId == null) {
      conversationId = await createConversationAndReturnConversationIdForUsers(
          username, contactUsername);
      await userRef.update({
        'conversations': {contactUsername: conversationId}
      });
    }

    return conversationId;
  }

  @override
  Future<void> createConversationIdForContact(User contact) async {
    final contactId = contact.id;
    final contactUsername = contact.username;
    final userId = SharedObjects.preferences.getString(Constants.sessionUserId);

    final username =
        SharedObjects.preferences.getString(Constants.sessionUsername);

    final usersCollection = fireStoreDb.collection(FirebasePaths.usersPath);

    final userReference = usersCollection.doc(userId);

    final contactReference = usersCollection.doc(contactId);

    final userSnapshot = await userReference.get();

    if (userSnapshot.data()!['conversations'] == null ||
        userSnapshot.data()!['conversations'][contactUsername] == null) {
      final conversationId =
          await createConversationAndReturnConversationIdForUsers(
              username, contactUsername);
      await userReference.set({
        'conversations': {contactUsername: conversationId}
      }, SetOptions(merge: true));
      await contactReference.set({
        'conversations': {username: conversationId}
      }, SetOptions(merge: true));
    }
  }

  Future<String> createConversationAndReturnConversationIdForUsers(
      String? username, String? contactUsername) async {
    final conversationCollection =
        fireStoreDb.collection(FirebasePaths.conversationsPath);
    final userIdMapCollection =
        fireStoreDb.collection(FirebasePaths.usernameIdMapPath);
    final usersCollection = fireStoreDb.collection(FirebasePaths.usersPath);

    final String? userId =
        (await userIdMapCollection.doc(username).get()).data()!['id'];
    final String? contactId =
        (await userIdMapCollection.doc(contactUsername).get()).data()!['id'];
    print('my id: $userId , contact id: $contactId');

    final userReference = await usersCollection.doc(userId).get();
    final contactReference = await usersCollection.doc(contactId).get();

    final conversation = await conversationCollection.add({
      // 'messages': [],
      'members': [username, contactUsername],
      'memberIds': [userId, contactId],
      'memberData': [userReference.data(), contactReference.data()]
    });

    return conversation.id;
  }

  @override
  void dispose() {
    conversationInfoStreamController.close();
  }
}
