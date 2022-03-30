import 'dart:async';

import 'package:aulare/config/firebase_paths.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'base_providers.dart';

class UserDataProvider extends BaseUserDataProvider {
  UserDataProvider({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  final firebase.FirebaseAuth _firebaseAuth;

  final fireStoreDb = FirebaseFirestore.instance;

  @override
  Future<User> saveProfileDetails(
      String uid,
      // String profilePictureUrl,
      String? username) async {
    final userDocumentReference = fireStoreDb
        .collection(FirebasePaths.usersPath)
        .doc(
            uid); //reference of the user's document node in database/users. This node is created using uid
    final data = {
      // 'profilePictureUrl': profilePictureUrl,
      'username': username,
    };
    await userDocumentReference.set(
        data, SetOptions(merge: true)); // set the photourl and username
    final currentDocument = await userDocumentReference
        .get(); // get updated data back from firestore
    return User.fromFirestore(
        currentDocument); // create a user object and return it
  }

  @override
  Future<User> getUser({required String username}) async {
    // return (await _firebaseAuth.currentUser);
//TODO CAN CHANGE THIS TO DISPLAYNAME LATER IF IMPLEMENTING PRIVATE USERNAME
    final uid = await getUidByUsername(username: username);
    final ref = fireStoreDb.collection(FirebasePaths.usersPath).doc(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return User.fromFirestore(snapshot);
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Stream<List<Contact>> getContacts() {
    if (Constants.sessionUid == 'sessionUid') {
      final firebaseUser = _firebaseAuth.currentUser!;
      SharedObjects.preferences
          .setString(Constants.sessionUid, firebaseUser.uid);
    }

    CollectionReference userCollectionReference;
    userCollectionReference = fireStoreDb.collection(FirebasePaths.usersPath);
    var sessionUid = Constants.sessionUid;
    final ref = userCollectionReference
        .doc(SharedObjects.preferences.getString(Constants.sessionUid));
    final contacts = ref.snapshots().transform(
        StreamTransformer<DocumentSnapshot, List<Contact>>.fromHandlers(
            handleData: (documentSnapshot, sink) => mapDocumentToContact(
                userCollectionReference, ref, documentSnapshot, sink)));
    return contacts;
  }

  Future<void> mapDocumentToContact(
      CollectionReference userRef,
      DocumentReference ref,
      DocumentSnapshot documentSnapshot,
      Sink sink) async {
    List<String> contacts;

    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

    if (data['contacts'] == null || data['conversations'] == null) {
      await ref.update({'contacts': []});
      contacts = [];
    } else {
      contacts = List.from(data['contacts']);
    }
    final contactList = <Contact>[];
    final Map? conversations = data['conversations'];
    for (final username in contacts) {
      final uid = await getUidByUsername(username: username);
      final contactSnapshot = await userRef.doc(uid).get();
      final Map<String, dynamic> contactSnapshotData =
          contactSnapshot.data() as Map<String, dynamic>;

      contactSnapshotData['conversationId'] = conversations![username];
      contactList.add(Contact.fromFirestore(contactSnapshot));
    }
    contactList.sort((a, b) => a.username!.compareTo(b.username!));
    sink.add(contactList);
  }

  @override
  Future<void> addContact({required String username}) async {
    final contactUser = await getUser(username: username);
    //create a node with the username provided in the contacts collection
    final usersCollectionReference =
        fireStoreDb.collection(FirebasePaths.usersPath);
    final userDocumentReference = usersCollectionReference
        .doc(SharedObjects.preferences.getString(Constants.sessionUid));
    //await to fetch user details of the username provided and set data
    final documentSnapshot = await userDocumentReference.get();
    print(documentSnapshot.data);

    var contacts = documentSnapshot.data()!['contacts'] != null
        ? List.from(documentSnapshot.data()!['contacts'])
        : [];

    if (contacts.contains(username)) {
      throw InvalidStateException();
    }

    contacts.add(username);
    await userDocumentReference.update({'contacts': contacts});

    await userDocumentReference
        .set({'contacts': contacts}, SetOptions(merge: true));
    //contact should be added in the contactlist of both the users. Adding to the second user here
    final sessionUsername =
        SharedObjects.preferences.getString(Constants.sessionUsername);
    final contactReference =
        usersCollectionReference.doc(contactUser.documentId);
    final contactSnapshot = await contactReference.get();
    contacts = contactSnapshot.data()!['contacts'] != null
        ? List.from(contactSnapshot.data()!['contacts'])
        : [];
    if (contacts.contains(sessionUsername)) {
      throw InvalidStateException();
    }
    contacts.add(sessionUsername);
    await contactReference.set({'contacts': contacts}, SetOptions(merge: true));
  }

  @override
  Future<String?> getUidByUsername({required String username}) async {
    //get reference to the mapping using username
    var mockEmail = username + '@aula.re';
    final ref =
        fireStoreDb.collection(FirebasePaths.usernameUidMapPath).doc(mockEmail);
    final documentSnapshot = await ref.get();
    print(documentSnapshot.exists);
    //check if uid mapping for supplied username exists
    if (documentSnapshot.exists && documentSnapshot.data()!['uid'] != null) {
      return documentSnapshot.data()!['uid'];
    } else {
      throw UsernameMappingUndefinedException();
    }
  }
// @override
// Future<void> updateProfilePicture(String profilePictureUrl) async {
//   final uid = SharedObjects.preferences.getString(Constants.sessionUid);
//   final ref = fireStoreDb.collection(FirebasePaths.usersPath).doc(
//       uid); //reference of the user's document node in database/users. This node is created using uid
//   final data = {
//     'photoUrl': profilePictureUrl,
//   };
//   await ref.set(data, SetOptions(merge: true)); // set the photourl
// }

// @override
// Future<bool> isProfileComplete(String uid) async {
//   final documentReference = fireStoreDb
//       .collection(Paths.usersPath)
//       .doc(uid); // get reference to the user/ uid node
//   final currentDocument = await documentReference.get();
//
//   final isProfileComplete = currentDocument != null &&
//       currentDocument.exists &&
//       currentDocument.data().containsKey('profilePictureUrl') &&
//       currentDocument.data().containsKey(
//           'username'); // check if it exists, if yes then check if username and age field are there or not. If not then profile incomplete else complete
//   if (isProfileComplete) {
//     await SharedObjects.preferences.setString(
//         Constants.sessionUsername, currentDocument.data()['username']);
//     await SharedObjects.preferences
//         .setString(Constants.sessionName, currentDocument.data()['name']);
//     await SharedObjects.preferences.setString(
//         Constants.sessionProfilePictureUrl,
//         currentDocument.data()['photoUrl']);
//   }
//   return isProfileComplete;
// }
  @override
  void dispose() {}
}
