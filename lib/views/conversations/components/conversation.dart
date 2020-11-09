// import 'package:aulare/config/settings.dart';
import 'package:aulare/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:aulare/models/User.dart';
// import 'package:aulare/utils/SharedObjects.dart';

class Conversation {
  Conversation(this.conversationId, this.user, this.latestMessage);

  String conversationId;
  User user;
  Conversation latestMessage;

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
    return Conversation(document.id, contact,
        Conversation.fromMap(Map.from(data['latestMessage'])));
  }

  @override
  String toString() =>
      '{ user= $user, chatId = $conversationId, latestMessage = $latestMessage}';
}
