import 'package:aulare/config/paths.dart';
import 'package:aulare/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'base_providers.dart';

class UserDataProvider extends BaseUserDataProvider {
  final fireStoreDb = FirebaseFirestore.instance;

  @override
  Future<User> saveDetailsFromGoogleAuth(firebase.User user) async {
    DocumentReference documentReference = fireStoreDb
        .collection(Paths.usersPath)
        .doc(user
            .uid); //reference of the user's document node in database/users. This node is created using uid
    final bool userExists = await documentReference
        .snapshots()
        .isEmpty; // check if user exists or not
    var data = {
      //add details received from google auth

      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
    };
    if (!userExists) {
      // if user entry exists then we would not want to override the photo url with the one received from googel auth
      data['photoUrl'] = user.photoURL;
    }
    documentReference.set(data, SetOptions(merge: true)); // set the data
    final DocumentSnapshot currentDocument =
        await documentReference.get(); // get updated data reference
    return User.fromFirestore(
        currentDocument); // create a user object and return
  }

  @override
  Future<User> saveProfileDetails(
      String uid, String profileImageUrl, String username) async {
    DocumentReference documentReference = fireStoreDb
        .collection(Paths.usersPath)
        .doc(
            uid); //reference of the user's document node in database/users. This node is created using uid
    var data = {
      'profileImageUrl': profileImageUrl,
      'username': username,
    };
    documentReference.set(
        data, SetOptions(merge: true)); // set the photourl and username
    final DocumentSnapshot currentDocument =
        await documentReference.get(); // get updated data back from firestore
    return User.fromFirestore(
        currentDocument); // create a user object and return it
  }

  @override
  Future<bool> isProfileComplete(String uid) async {
    DocumentReference documentReference = fireStoreDb
        .collection(Paths.usersPath)
        .doc(uid); // get reference to the user/ uid node
    final DocumentSnapshot currentDocument = await documentReference.get();

    return currentDocument.exists &&
        currentDocument.data().containsKey(
            'username'); // check if it exists, if yes then check if username and age field are there or not. If not then profile incomplete else complete
  }
}
