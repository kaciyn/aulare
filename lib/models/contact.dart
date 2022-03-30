import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  Contact(
      this.id,
      this.username,
      // this.name,
      // this.avatarImageUrl,
      this.conversationId);

  factory Contact.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data() as Map<dynamic, dynamic>;
    return Contact(
        document.id,
        data['username'],
        // data['name'],
        // data['photoUrl'],
        data['conversationId']);
  }

  factory Contact.fromConversationInfo(ConversationInfo conversationInfo) {
    return Contact(
      conversationInfo.user.id,
      conversationInfo.user.username,
      // conversationInfo.user!.name,
      // conversationInfo.user!.profilePictureUrl,
      conversationInfo.conversationId,
    );
  }

  String? id;
  String? username;
  // String? name;
  // String? documentId;
  String? conversationId;
  // String? avatarImageUrl;

  @override
  String toString() {
    return '{'
        ' id: $id, '
        // 'name: $name,'
        ' username: $username,'
        // ' photoUrl: $avatarImageUrl ,'
        ' conversationId: $conversationId}';
  }

  //we don't want to encourage real name usage
// String? getName() => name;
  String? getUsername() => username;
}
