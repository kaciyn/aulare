import 'dart:async';

import 'package:aulare/config/paths.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/views/messaging/bloc/message.dart';
import 'package:aulare/views/rooms/components/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingProvider extends BaseMessagingProvider {
  MessagingProvider({FirebaseFirestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? FirebaseFirestore.instance;

  final FirebaseFirestore fireStoreDb;

  @override
  Stream<List<Room>> getRooms() {
    // TODO: implement getChats
    return null;
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    var messagingDocumentReference =
        fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
        messagingDocumentReference.collection(Paths.messagesPath);
    return messagesCollection.snapshots().transform(
        StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
                    mapDocumentToMessage(querySnapshot, sink)));
  }

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    List<Message> messages = List();
    for (DocumentSnapshot document in querySnapshot.docs) {
      print(document.data);
      messages.add(Message.fromFireStore(document));
    }
    sink.add(messages);
  }

  @override
  Future<void> sendMessage(String chatId, Message message) async {
    DocumentReference conversationDocumentReference =
        fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
        conversationDocumentReference.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
  }

  @override
  void dispose() {
    // if(conversationStreamController!=null)
    //   conversationStreamController.close();
  }

  @override
  Future<void> createChatIdForContact(User user) {
    // TODO: implement createChatIdForContact
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> getAttachments(String chatId, int type) {
    // TODO: implement getAttachments
    throw UnimplementedError();
  }

  @override
  Future<String> getChatIdByUsername(String username) {
    // TODO: implement getChatIdByUsername
    throw UnimplementedError();
  }

  @override
  Stream<List<Room>> getChats() {
    // TODO: implement getChats
    throw UnimplementedError();
  }

  @override
  Stream<List<Room>> getConversations() {
    // TODO: implement getConversations
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> getPreviousMessages(
      String chatId, Message prevMessage) {
    // TODO: implement getPreviousMessages
    throw UnimplementedError();
  }
}
