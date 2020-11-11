import 'package:cloud_firestore/cloud_firestore.dart';

import 'file:///D:/BigBadCodeRepos/aulare/lib/views/messaging/models/conversation.dart';

class Contact {
  Contact(this.documentId, this.username, this.name, this.avatarImageUrl,
      this.conversationId);

  factory Contact.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data();
    return Contact(document.id, data['username'], data['name'],
        data['photoUrl'], data['chatId']);
  }

  factory Contact.fromConversation(Conversation conversation) {
    return Contact(
      conversation.user.documentId,
      conversation.user.username,
      conversation.user.name,
      conversation.user.avatarImageUrl,
      conversation.conversationId,
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
