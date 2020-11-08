import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message(
      this.text,
      // this.imageUrl,
      // this.videoUrl,
      // this.fileUrl,
      this.timestamp,
      this.senderName,
      this.senderUsername);

  //get these from network SOMEHOW instead of firestore
  factory Message.fromFireStore(DocumentSnapshot document) {
    Map data = document.data();
    return Message.fromMap(data);
  }

  factory Message.fromMap(Map data) {
    return Message(
        data['text'],
        // data['imageUrl'],
        // data['videoUrl'],
        // data['fileUrl'],
        data['timestamp'],
        data['senderName'],
        data['senderUsername']);
  }

  DateTime timestamp;

  String senderName;
  String senderUsername;

  String text;

  String imageUrl;
  String videoUrl;
  String fileUrl;

  //maybe let's worry about multiple attachments in the future hm
  // List<String> imageUrls;
  // List<String> videoUrls;
  // List<String> fileUrls;

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['text'] = text;
    // map['imageUrls'] = imageUrl;
    // map['videoUrls'] = videoUrl;
    // map['fileUrls'] = fileUrl;

    map['timestamp'] = timestamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;

    return map;
  }

  @override
  String toString() => '{ senderName : $senderName'
      ', senderUsername : $senderUsername'
      ', timestamp : $timestamp'
      ', text: $text'
      // ',imageUrl:$imageUrl'
      // ',videoUrl:$videoUrl'
      // ',fileUrl:$fileUrl '
      '}';
}
