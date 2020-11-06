// import 'package:aulare/config/settings.dart';
import 'package:aulare/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:aulare/models/User.dart';
// import 'package:aulare/utils/SharedObjects.dart';

class Conversation {
  String conversationId;
  User user;
  Conversation latestMessage;

  Conversation(this.conversationId, this.user, this.latestMessage);

  factory Conversation.fromFireStore(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data();
    List<String> members = List.from(data['members']);
    String selfUsername =
        // SharedObjects.prefs.getString(Constants.sessionUsername);
        "username";
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
