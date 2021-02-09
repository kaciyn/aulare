import 'dart:async';

import 'package:aulare/config/paths.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'base_providers.dart';

class UserDataProvider extends BaseUserDataProvider {
  UserDataProvider({firebase.FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  final firebase.FirebaseAuth _firebaseAuth;

  final fireStoreDb = FirebaseFirestore.instance;




  @override
  Future<User> saveProfileDetails(
      String uid,
      // String profilePictureUrl,
      String username) async {
    final documentReference = fireStoreDb.collection(Paths.usersPath).doc(
        uid); //reference of the user's document node in database/users. This node is created using uid
    final data = {
      // 'profilePictureUrl': profilePictureUrl,
      'username': username,
    };
    await documentReference.set(
        data, SetOptions(merge: true)); // set the photourl and username
    final currentDocument =
        await documentReference.get(); // get updated data back from firestore
    return User.fromFirestore(
        currentDocument); // create a user object and return it
  }

  @override
  Future<void> updateProfilePicture(String profilePictureUrl) async {
    final uid = SharedObjects.preferences.getString(Constants.sessionUid);
    final ref = fireStoreDb.collection(Paths.usersPath).doc(
        uid); //reference of the user's document node in database/users. This node is created using uid
    final data = {
      'photoUrl': profilePictureUrl,
    };
    await ref.set(data, SetOptions(merge: true)); // set the photourl
  }

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
  Future<User> getUser(String username) async {
    // return (await _firebaseAuth.currentUser);

    final uid = await getUidByUsername(username);
    final ref = fireStoreDb.collection(Paths.usersPath).doc(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return User.fromFirestore(snapshot);
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  @override
  Stream<List<Contact>> getContacts() {
    CollectionReference userRef;
    userRef = fireStoreDb.collection(Paths.usersPath);
    final ref =
        userRef.doc(SharedObjects.preferences.getString(Constants.sessionUid));
    return ref.snapshots().transform(
        StreamTransformer<DocumentSnapshot, List<Contact>>.fromHandlers(
            handleData: (documentSnapshot, sink) =>
                mapDocumentToContact(userRef, ref, documentSnapshot, sink)));
  }

  Future<void> mapDocumentToContact(
      CollectionReference userRef,
      DocumentReference ref,
      DocumentSnapshot documentSnapshot,
      Sink sink) async {
    List<String> contacts;

    if (documentSnapshot.data()['contacts'] == null ||
        documentSnapshot.data()['chats'] == null) {
      await ref.update({'contacts': []});
      contacts = [];
    } else {
      contacts = List.from(documentSnapshot.data()['contacts']);
    }
    final contactList = <Contact>[];
    final Map conversations = documentSnapshot.data()['chats'];
    for (final username in contacts) {
      // ignore: omit_local_variable_types
      final uid = await getUidByUsername(username);
      final contactSnapshot = await userRef.doc(uid).get();
      contactSnapshot.data()['chatId'] = conversations[username];
      contactList.add(Contact.fromFirestore(contactSnapshot));
    }
    contactList.sort((a, b) => a.name.compareTo(b.name));
    sink.add(contactList);
  }

  @override
  Future<void> addContact(String username) async {
    final contactUser = await getUser(username);
    //create a node with the username provided in the contacts collection
    final collectionReference = fireStoreDb.collection(Paths.usersPath);
    final documentReference = collectionReference
        .doc(SharedObjects.preferences.get(Constants.sessionUid));

    //await to fetch user details of the username provided and set data
    final documentSnapshot = await documentReference.get();
    print(documentSnapshot.data);
    var contacts = documentSnapshot.data()['contacts'] != null
        ? List.from(documentSnapshot.data()['contacts'])
        : [];

    if (contacts.contains(username)) {
      throw ContactAlreadyExistsException();
    }

    contacts.add(username);
    await documentReference.update({'contacts': contacts});

    await documentReference
        .set({'contacts': contacts}, SetOptions(merge: true));
    //contact should be added in the contactlist of both the users. Adding to the second user here
    final sessionUsername =
        SharedObjects.preferences.getString(Constants.sessionUsername);
    final contactRef = collectionReference.doc(contactUser.documentId);
    final contactSnapshot = await contactRef.get();
    contacts = contactSnapshot.data()['contacts'] != null
        ? List.from(contactSnapshot.data()['contacts'])
        : [];
    if (contacts.contains(sessionUsername)) {
      throw ContactAlreadyExistsException();
    }
    contacts.add(sessionUsername);
    await contactRef.set({'contacts': contacts}, SetOptions(merge: true));
  }

  @override
  Future<String> getUidByUsername(String username) async {
    //get reference to the mapping using username
    final ref = fireStoreDb.collection(Paths.usernameUidMapPath).doc(username);
    final documentSnapshot = await ref.get();
    print(documentSnapshot.exists);
    //check if uid mapping for supplied username exists
    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data()['uid'] != null) {
      return documentSnapshot.data()['uid'];
    } else {
      throw UsernameMappingUndefinedException();
    }
  }

  @override
  void dispose() {}
}
