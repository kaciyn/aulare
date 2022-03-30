import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message(
      this.text,
      // this.imageUrl,
      // this.videoUrl,
      // this.fileUrl,
      this.timestamp,
      // this.senderName,
      this.senderUsername);

  //get these from network SOMEHOW instead of firestore
  factory Message.fromFireStore(DocumentSnapshot document) {
    final Map data = document.data() as Map<dynamic, dynamic>;
    final message = Message.fromMap(data);
    message.isFromSelf =
        SharedObjects.preferences.getString(Constants.sessionUsername) ==
            message.senderUsername;
    message.documentId = document.id;
    return message;
  }

  factory Message.fromMap(Map data) {
    final message = Message(
        data['text'],
        // data['imageUrl'],
        // data['videoUrl'],
        // data['fileUrl'],
        data['timestamp'],
        // data['senderName'],
        data['senderUsername']);
    message.isFromSelf =
        SharedObjects.preferences.getString(Constants.sessionUsername) ==
            message.senderUsername;
    return message;
  }

  DateTime? timestamp;

  // String? senderName;
  String? senderUsername;

  String? text;

  String? imageUrl;
  String? videoUrl;
  String? fileUrl;

  late bool isFromSelf;

  String? documentId;

  //maybe let's worry about multiple attachments in the future hm
  // List<String> imageUrls;
  // List<String> videoUrls;
  // List<String> fileUrls;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['text'] = text;
    // map['imageUrls'] = imageUrl;
    // map['videoUrls'] = videoUrl;
    // map['fileUrls'] = fileUrl;

    map['timestamp'] = timestamp;
    // map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;

    return map;
  }

  @override
  String toString() => '{ '
      // 'senderName : $senderName'
      ', senderUsername : $senderUsername'
      ', timestamp : $timestamp'
      ', text: $text'
      ', isFromSelf : $isFromSelf'
      // ',imageUrl:$imageUrl'
      // ',videoUrl:$videoUrl'
      // ',fileUrl:$fileUrl '
      '}';
}
