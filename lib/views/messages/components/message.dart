import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  DateTime timeStamp;

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

  // ignore: sort_constructors_first
  Message(this.text, this.imageUrl, this.videoUrl, this.fileUrl, this.timeStamp,
      this.senderName, this.senderUsername);

//get these from network SOMEHOW instead of firestore
  factory Message.fromFireStore(DocumentSnapshot document) {
    Map data = document.data();
    return Message.fromMap(data);
  }

  factory Message.fromMap(Map data) {
    return Message(
        data['text'],
        data['imageUrl'],
        data['videoUrl'],
        data['fileUrl'],
        data['timeStamp'],
        data['senderName'],
        data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['text'] = text;
    map['imageUrls'] = imageUrl;
    map['videoUrls'] = videoUrl;
    map['fileUrls'] = fileUrl;

    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;

    return map;
  }

  @override
  String toString() =>
      '{ senderName : $senderName, senderUsername : $senderUsername, timeStamp : $timeStamp, text: $text,imageUrl:$imageUrl,videoUrl:$videoUrl,fileUrl:$fileUrl }';
}
