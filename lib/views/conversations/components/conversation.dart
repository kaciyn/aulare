// import 'package:aulare/config/settings.dart';
import 'package:aulare/views/messages/components/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:aulare/models/User.dart';
// import 'package:aulare/utils/SharedObjects.dart';

class Conversation {
  String chatId;
  // User user;
  String user;
  Conversation latestMessage;

  Conversation(this.chatId, this.user, this.latestMessage);

  factory Conversation.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data;
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
    return Conversation(doc.documentID, contact,
        Conversation.fromMap(Map.from(data['latestMessage'])));
  }

  @override
  String toString() =>
      '{ user= $user, chatId = $chatId, latestMessage = $latestMessage}';
}
