import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  Contact(this.documentId, this.username, this.name, this.avatarImageUrl,
      this.conversationId);

  factory Contact.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data();
    return Contact(document.id, data['username'], data['name'],
        data['photoUrl'], data['conversationId']);
  }

  factory Contact.fromConversationInfo(ConversationInfo conversationInfo) {
    return Contact(
      conversationInfo.user.documentId,
      conversationInfo.user.username,
      conversationInfo.user.name,
      conversationInfo.user.profilePictureUrl,
      conversationInfo.conversationId,
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
    return '{ documentId: $documentId, name: $name, username: $username, photoUrl: $avatarImageUrl , conversationId: $conversationId}';
  }

  //we don't want to encourage real name usage
  String getName() => name;
}
