import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String documentId;
  String name;
  String username;
  String avatarImageUrl;

  User(
      {this.uid,
      this.documentId,
      this.name,
      this.username,
      this.avatarImageUrl});

  factory User.fromFirestore(DocumentSnapshot document) {
    Map data = document.data();
    return User(
        uid: data['uid'],
        documentId: document.id,
        name: data['name'],
        username: data['username'],
        avatarImageUrl: data['avatarImageUrl']);
  }

  @override
  String toString() {
    return '{ uid: $uid, documentId: $documentId, name: $name,  username: $username, photoUrl: $avatarImageUrl }';
  }
}
