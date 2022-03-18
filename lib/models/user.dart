import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {required this.id,
      this.documentId,
      this.name,
      this.username,
      this.profilePictureUrl});

  factory User.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data() as Map<dynamic, dynamic>;
    return User(
        id: data['uid'],
        documentId: document.id,
        name: data['name'],
        username: data['username'],
        profilePictureUrl: data['profilePictureUrl']);
  }

  factory User.fromMap(Map data) {
    return User(
      id: data['uid'],
      documentId: data['documentId'],
      name: data['name'],
      username: data['username'],
      profilePictureUrl: data['avatarImageUrl'],
    );
  }

  final String? id;
  final String? documentId;
  final String? name;
  final String? username;
  final String? profilePictureUrl;

  /// Empty user which represents an unauthenticated user.
  // static final empty = User(id: '');
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  String toString() {
    return '{ uid: $id, documentId: $documentId, name: $name,  username: $username, photoUrl: $profilePictureUrl }';
  }

  @override
  List<Object?> get props =>
      [id, documentId, name, username, profilePictureUrl];
}
