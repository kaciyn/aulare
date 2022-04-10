import 'package:aulare/models/user.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/contact.dart';
import '../../../utilities/exceptions.dart';

// import 'package:aulare/models/User.dart';
// import 'package:aulare/utils/SharedObjects.dart';

class Conversation {
  Conversation(this.conversationId, this.contact, this.latestMessage);

  Conversation.withoutLatestMessage(this.conversationId, this.contact);

  factory Conversation.fromFireStore(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final members = List<String>.from(data['members']);
    var membersData = data['memberData'];

    final ownUsername =
        SharedObjects.preferences.getString(Constants.sessionUsername);
    'username';

    Contact contact = Contact.empty;

    for (int i = 0; i < members.length; i++) {
      if (members[i] != ownUsername) {
        //TODO SORT THIS OUT WHEN YOU FIX THE CONTACTS THING
        var memberData = membersData[i];
        var conversationId = data['documentId'];
        var id = data['id'];
        var contactUsername = data['username'];
        final userDetails = Map<String, dynamic>.from(memberData);

        contact = Contact.fromMap(userDetails, conversationId);
      }
    }

    if (contact.username == '') {
      throw ConversationContactNotFoundException();
    }

    // return Conversation(
    //     document.id, contact, Message.fromMap(Map.from(data['latestMessage'])));
    return Conversation(
        document.id, contact, Message.fromMap(Map.from(data['latestMessage'])));
  }

  String conversationId;
  Contact contact;
  Message? latestMessage;

  @override
  String toString() =>
      '{ user= $contact, conversationId = $conversationId, latestMessage = $latestMessage}';
}

//old conversation class
// class Conversation {
//   Conversation(this.contactUsername, this.conversationId);
//
//   @override
//   String toString() =>
//       '{ username= $contactUsername, chatId = $conversationId}';
//
//   String contactUsername;
//   String conversationId;
// }
// // i really don't see why this a different thing than conversation
