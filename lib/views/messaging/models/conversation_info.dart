import 'package:aulare/models/user.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:aulare/models/User.dart';
// import 'package:aulare/utils/SharedObjects.dart';

class ConversationInfo {
  ConversationInfo(this.conversationId, this.user, this.latestMessage);

  ConversationInfo.withoutLatestMessage(this.conversationId, this.user);

  factory ConversationInfo.fromFireStore(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final members = List<String>.from(data['members']);
    var membersData = data['memberData'];

    final ownUsername =
        SharedObjects.preferences.getString(Constants.sessionUsername);
    'username';
    User? contact;
    for (int i = 0; i < members.length; i++) {
      if (members[i] != ownUsername) {
        //TODO SORT THIS OUT WHEN YOU FIX THE CONTACTS THING
        var memberData = membersData[i];
        var docid = data['documentId'];
        var id = data['id'];
        var contactUsername = data['username'];
        // var contactId =
        final userDetails = Map<String, dynamic>.from(memberData);

        contact = User.fromMap(userDetails);
      }
    }

    // return Conversation(
    //     document.id, contact, Message.fromMap(Map.from(data['latestMessage'])));
    return ConversationInfo(document.id, contact!,
        Message.fromMap(Map.from(data['latestMessage'])));
  }

  String conversationId;
  User user;
  Message? latestMessage;

  @override
  String toString() =>
      '{ user= $user, conversationId = $conversationId, latestMessage = $latestMessage}';
}
