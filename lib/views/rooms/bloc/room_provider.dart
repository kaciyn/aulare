import 'dart:async';

import 'package:aulare/config/paths.dart';
import 'package:aulare/providers/base_providers.dart';
import 'package:aulare/views/rooms/components/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageProvider extends BaseMessagingProvider {
  final FirebaseFirestore fireStoreDb;

  MessageProvider({FirebaseFirestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? FirebaseFirestore.instance;

  @override
  Stream<List<Room>> getRooms() {
    // TODO: implement getChats
    return null;
  }

  @override
  Stream<List<Room>> getMessages(String chatId) {
    DocumentReference messageDocumentReference =
        fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
        messageDocumentReference.collection(Paths.messagesPath);
    return messagesCollection.snapshots().transform(
        StreamTransformer<QuerySnapshot, List<Room>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Room>> sink) =>
                    mapDocumentToMessage(querySnapshot, sink)));
  }

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    List<Room> messages = List();
    for (DocumentSnapshot document in querySnapshot.docs) {
      print(document.data);
      messages.add(Room.fromFireStore(document));
    }
    sink.add(messages);
  }

  @override
  Future<void> sendMessage(String chatId, Room message) async {
    DocumentReference chatDocRef =
        fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
  }
}
