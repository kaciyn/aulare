import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  Contact(this.id, this.username, this.conversationId
      // this.name,
      // this.avatarImageUrl,
      );

  factory Contact.fromFirestore(DocumentSnapshot document) {
    // final Map data = document.data() as Map<dynamic, dynamic>;
    final Map data = document.data() as Map<String, dynamic>;
    return Contact(document.id, data['username'], data['conversationId']
        // data['name'],
        // data['photoUrl'],
        );
  }

  factory Contact.fromConversationInfo(ConversationInfo conversationInfo) {
    return Contact(
      conversationInfo.user.id,
      conversationInfo.user.username,
      conversationInfo.conversationId,
      // conversationInfo.user!.name,
      // conversationInfo.user!.profilePictureUrl,
    );
  }

  factory Contact.fromFireStoreAndConversationId(
      DocumentSnapshot document, String conversationId) {
    // final Map data = document.data() as Map<dynamic, dynamic>;
    final Map data = document.data() as Map<String, dynamic>;
    return Contact(document.id, data['username'], conversationId
        // data['name'],
        // data['photoUrl'],
        );
  }

  String? id;
  String? username;
  String? conversationId;

  // String? name;
  // String? documentId;
  // String? avatarImageUrl;

  @override
  String toString() {
    return '{'
            ' id: $id, '
            ' username: $username,'
            ' conversationId: $conversationId}'
        // 'name: $name,'
        // ' photoUrl: $avatarImageUrl ,'
        ;
  }

  //we don't want to encourage real name usage
// String? getName() => name;
  String? getUsername() => username;
}
