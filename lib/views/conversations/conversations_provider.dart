import 'package:aulare/config/paths.dart';
import 'package:aulare/views/conversations/components/conversation.dart';
import 'package:aulare/views/messages/components/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'file:///D:/BigBadCodeRepos/aulare/lib/providers/base_providers.dart';

class MessageProvider extends BaseMessagingProvider {
  final FirebaseFirestore fireStoreDb;

  MessageProvider({FirebaseFirestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? FirebaseFirestore.instance;

  @override
  Stream<List<Conversation>> getConversations() {
    // TODO: implement getChats
    return null;
  }

  @override
  Stream<List<Conversation>> getMessages(String chatId) {
    DocumentReference messageDocumentReference =
        fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
        messageDocumentReference.collection(Paths.messagesPath);
    return messagesCollection.snapshots().transform(
        StreamTransformer<QuerySnapshot, List<Conversation>>.fromHandlers(
            handleData: (QuerySnapshot querySnapshot,
                    EventSink<List<Conversation>> sink) =>
                mapDocumentToMessage(querySnapshot, sink)));
  }

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    List<Conversation> messages = List();
    for (DocumentSnapshot document in querySnapshot.documents) {
      print(document.data);
      messages.add(Conversation.fromFireStore(document));
    }
    sink.add(messages);
  }

  @override
  Future<void> sendMessage(String chatId, Conversation message) async {
    DocumentReference chatDocRef =
        fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
  }
}
