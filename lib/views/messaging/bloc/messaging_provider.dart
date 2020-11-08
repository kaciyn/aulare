import 'dart:async';

import 'package:aulare/config/paths.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/views/conversations/components/conversation.dart';
import 'package:aulare/views/messaging/bloc/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingProvider extends BaseMessagingProvider {
  MessagingProvider({FirebaseFirestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? FirebaseFirestore.instance;

  final FirebaseFirestore fireStoreDb;

  @override
  Stream<List<Conversation>> getConversations() {
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
    DocumentReference chatDocRef =
        fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
  }

  @override
  void dispose() {
    // if(conversationStreamController!=null)
    //   conversationStreamController.close();
  }
}
