import 'package:aulare/views/conversations/components/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  Contact(this.documentId, this.username, this.name, this.avatarImageUrl,
      this.conversationId);

  factory Contact.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data();
    return Contact(document.id, data['username'], data['name'],
        data['photoUrl'], data['chatId']);
  }

  factory Contact.fromConversation(Conversation room) {
    return Contact(
      room.user.documentId,
      room.user.username,
      room.user.name,
      room.user.avatarImageUrl,
      room.conversationId,
    );
  }

  String username;
  String name;
  String uid;
  String documentId;
  String conversationId;
  String avatarImageUrl;

  @override
  String toString() {
    return '{ documentId: $documentId, name: $name, username: $username, photoUrl: $avatarImageUrl , chatId: $conversationId}';
  }

  //we don't want to encourage real name usage
  String getName() => name;
}
