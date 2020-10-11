class Message {
  DateTime timeStamp;

  String senderName;
  String senderUsername;

  String text;
  List<String> imageUrls;
  List<String> videoUrls;
  List<String> fileUrls;

  Message(this.text, this.imageUrls, this.videoUrls, this.fileUrls, timeStamp,
      senderName, senderUsername);

  //get these from network SOMEHOW instead of firestore
  factory Message.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Message(
        data['text'],
        data['imageUrls'],
        data['videoUrls'],
        data['fileUrls'],
        data['timeStamp'],
        data['senderName'],
        data['senderUsername']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['text'] = text;
    map['imageUrls'] = imageUrls;
    map['videoUrls'] = videoUrls;
    map['fileUrls'] = fileUrls;

    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    return map;
  }
}
