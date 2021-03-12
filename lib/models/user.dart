import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  factory User.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data();
    return User(
        uid: data['uid'],
        documentId: document.id,
        name: data['name'],
        username: data['username'],
        profilePictureUrl: data['profilePictureUrl']);
  }

  factory User.fromMap(Map data) {
    return User(
        documentId: data['uid'],
        name: data['name'],
        username: data['username'],
        profilePictureUrl: data['avatarImageUrl']);
  }

  String uid;
  String documentId;
  String name;
  String username;
  String profilePictureUrl;

  User(
      {this.uid,
      this.documentId,
      this.name,
      this.username,
      this.profilePictureUrl});

  @override
  String toString() {
    return '{ uid: $uid, documentId: $documentId, name: $name,  username: $username, photoUrl: $profilePictureUrl }';
  }
}
