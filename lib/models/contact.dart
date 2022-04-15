import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/user_data_repository.dart';
import '../utilities/exceptions.dart';

class Contact {
  Contact(this.id, this.username, this.conversationId
      // this.name,
      // this.avatarImageUrl,
      );

  Contact.idLess(this.username, this.conversationId
      // this.name,
      // this.avatarImageUrl,
      );

  // Contact.conversationLess(this.id, this.username
  //     // this.name,
  //     // this.avatarImageUrl,
  //     );

  // Contact.withoutConversationId(this.id, this.username
  //     // this.name,
  //     // this.avatarImageUrl,
  //     );
  factory Contact.fromFirestore(DocumentSnapshot conversationContactDocument,
      String contactId, ownUsername) {
    final Map data = conversationContactDocument.data() as Map<String, dynamic>;
    final conversations = data['conversations'] as Map<String, dynamic>;
    final conversationId = conversations[ownUsername];
    if (conversationId == null) {
      throw ContactConversationNotCreated(data['username']);
    }

    return Contact(contactId, data['username'], conversationId
        // data['name'],
        // data['photoUrl'],
        );
  }

  factory Contact.fromConversationInfo(Conversation conversationInfo) {
    return Contact(
      conversationInfo.contact.id,
      conversationInfo.contact.username,
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

  // factory Contact.fromFireStorePreConversationCreation(
  //     DocumentSnapshot document, String contactId) {
  //   // final Map data = document.data() as Map<dynamic, dynamic>;
  //   final Map data = document.data() as Map<String, dynamic>;
  //   return Contact.conversationLess(contactId, data['username']
  //       // data['name'],
  //       // data['photoUrl'],
  //       );
  // }

  factory Contact.fromMap(Map data, String conversationId) {
    // final Map data = document.data() as Map<dynamic, dynamic>;
    return Contact.idLess(data['username'], conversationId);
  }

  factory Contact.fromConversationAndRepository(
      Map data, String conversationId, String contactId) {
    // final Map data = document.data() as Map<dynamic, dynamic>;
    return Contact(contactId, data['username'], conversationId);
  }

  String? id;
  String username;
  String conversationId;

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

  static Contact empty = Contact('', '', '');
}
