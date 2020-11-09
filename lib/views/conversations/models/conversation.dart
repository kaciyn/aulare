import 'package:aulare/models/user.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:aulare/models/User.dart';
// import 'package:aulare/utils/SharedObjects.dart';

class Conversation {
  Conversation(this.conversationId, this.user, this.latestMessage);

  Conversation.withoutLatestMessage(this.conversationId, this.user);

  factory Conversation.fromFireStore(DocumentSnapshot document) {
    final data = document.data();
    final members = List<String>.from(data['members']);
    const selfUsername =
        // SharedObjects.prefs.getString(Constants.sessionUsername);
        'username';
    User contact;
    for (int i = 0; i < members.length; i++) {
      if (members[i] != selfUsername) {
        final userDetails = Map<String, dynamic>.from((data['membersData'])[i]);
        contact = User.fromMap(userDetails);
      }
    }

    return Conversation(
        document.id, contact, Message.fromMap(Map.from(data['latestMessage'])));
  }

  String conversationId;
  User user;
  Message latestMessage;

  @override
  String toString() =>
      '{ user= $user, chatId = $conversationId, latestMessage = $latestMessage}';
}
