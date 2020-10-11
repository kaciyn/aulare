import 'dart:async';

import '../../bloc/base_providers.dart';

class MessageProvider extends BaseMessageProvider {
  final Firestore fireStoreDb;

  ChatProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance;

  @override
  Stream<List<Chat>> getChats() {
    // TODO: implement getChats
    return null;
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    DocumentReference chatDocRef =
        fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    return messagesCollection.snapshots().transform(
        StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
                    mapDocumentToMessage(querySnapshot, sink)));
  }

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    List<Message> messages = List();
    for (DocumentSnapshot document in querySnapshot.documents) {
      print(document.data);
      messages.add(Message.fromFireStore(document));
    }
    sink.add(messages);
  }

  @override
  Future<void> sendMessage(String chatId, Message message) async {
    DocumentReference chatDocRef =
        fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
  }
}
