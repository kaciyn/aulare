import 'dart:async';

import 'package:aulare/config/firebase_paths.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/models/user.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/cupertino.dart';

import 'base_providers.dart';

class UserDataProvider extends BaseUserDataProvider {
  UserDataProvider({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  final firebase.FirebaseAuth _firebaseAuth;

  final fireStoreDb = FirebaseFirestore.instance;

  @override
  Future<User> saveProfileDetails(
      String id,
      // String profilePictureUrl,
      String username) async {
    final usersCollection = fireStoreDb.collection(FirebasePaths.usersPath).doc(
        id); //reference of the user's document node in database/users. This node is created using id
    final userDetails = {
      // 'profilePictureUrl': profilePictureUrl,
      'username': username,
    };

    await usersCollection.set(userDetails, SetOptions(merge: true)).catchError(
        (error) => print("Failed to add user: $error")); // set the user details
    final newUser =
        await usersCollection.get(); // get updated data back from firestore

    //add username/id mapping
    final usernameUidMapPathCollection =
        fireStoreDb.collection(FirebasePaths.usernameIdMapPath);

    await usernameUidMapPathCollection.doc(username).set({'id': id}).catchError(
        (error) => print("Failed to add user/id map: $error"));
    //todo proper error handling

    SharedObjects.preferences.setString(Constants.sessionUsername, username);

    SharedObjects.preferences.setString(Constants.sessionUserId, id);

    return User.fromFirestore(newUser); // create a user object and return it
  }

  @override
  Future<User> getUser({required String username}) async {
    // return (await _firebaseAuth.currentUser);
//TODO CAN CHANGE THIS TO DISPLAYNAME LATER IF IMPLEMENTING PRIVATE USERNAME
    final id = await getUserIdByUsername(username: username);
    final ref = fireStoreDb.collection(FirebasePaths.usersPath).doc(id);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return User.fromFirestore(snapshot);
    } else {
      throw UserNotFoundException();
    }
  }

  // @override
  Future<List<Contact>?> getContactsList() async {
    if (SharedObjects.preferences.getString(Constants.sessionUserId) ==
        'sessionUid') {
      final firebaseUser = _firebaseAuth.currentUser!;
      final username = firebaseUser.email?.replaceAll('@aula.re', '');

      SharedObjects.preferences
          .setString(Constants.sessionUserId, firebaseUser.uid);

      SharedObjects.preferences.setString(Constants.sessionUsername, username!);
    }

    final userCollectionReference =
        fireStoreDb.collection(FirebasePaths.usersPath);

    final userSnapshot = await userCollectionReference
        .doc('${SharedObjects.preferences.getString(Constants.sessionUserId)}')
        .get();

    final userData = userSnapshot.data();
    final List<dynamic> contactUsernameList = userData?['contacts'].toList();

    final contactList = <Contact>[];

    final conversations = userData?['conversations'];

    for (final username in contactUsernameList) {
      final id = await getUserIdByUsername(username: username);

      final contactSnapshot = await userCollectionReference.doc(id).get();

      contactList.add(Contact.fromFireStoreAndConversationId(
          contactSnapshot, conversations?[username]));
    }

    contactList.sort((a, b) => a.username.compareTo(b.username));
    return contactList;
  }

  @override
  Stream<List<Contact>> getContacts() {
    //in case for some reason sessionUid hasn't been set
    if (SharedObjects.preferences.getString(Constants.sessionUserId) ==
        'sessionUid') {
      final firebaseUser = _firebaseAuth.currentUser!;
      final username = firebaseUser.email?.replaceAll('@aula.re', '');

      SharedObjects.preferences
          .setString(Constants.sessionUserId, firebaseUser.uid);

      SharedObjects.preferences.setString(Constants.sessionUsername, username!);
    }

    final CollectionReference usersRef =
        fireStoreDb.collection(FirebasePaths.usersPath);
    final DocumentReference userRef = usersRef
        .doc(SharedObjects.preferences.getString(Constants.sessionUserId));

    // final userSnapStream = userRef.collection('contacts');

    // final streamToList = userSnapStream.snapshots().toList();
    // //stream of the user document snapshot

    final contactsStream = userRef.snapshots().transform(StreamTransformer<
            DocumentSnapshot<Map<String, dynamic>>, List<Contact>>.fromHandlers(
        handleData: (documentSnapshot, sink) =>
            mapDocumentToContact(usersRef, userRef, documentSnapshot, sink)));

    return contactsStream;
  }

  Future<void> mapDocumentToContact(
      CollectionReference userCollectionReference,
      DocumentReference contactReference,
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
      Sink sink) async {
    List<String> contacts;

    // DocumentSnapshot<Map<String, dynamic>> data = DocumentSnapshot<Map<String, dynamic>>.from(documentSnapshot.data());
    final data =
        documentSnapshot.data()! as DocumentSnapshot<Map<String, dynamic>>;

    if (data['contacts'] == null || data['conversations'] == null) {
      await contactReference.update({'contacts': []});
      contacts = [];
    } else {
      contacts = List.from(data['contacts']);
    }

    final contactList = <Contact>[];

    final Map? conversations = data['conversations'];

    for (final username in contacts) {
      final id = await getUserIdByUsername(username: username);
      final contactSnapshot = await userCollectionReference.doc(id).get();
      final Map<String, dynamic> contactSnapshotData =
          contactSnapshot.data() as Map<String, dynamic>;

      contactSnapshotData['conversationId'] = conversations![username];

      contactList.add(Contact.fromFirestore(contactSnapshot));
    }
    contactList.sort((a, b) => a.username.compareTo(b.username));
    sink.add(contactList);
  }

  @override
  Future<void> addContact({required String contactUsername}) async {
    final sessionUsername =
        SharedObjects.preferences.getString(Constants.sessionUsername);
    final sessionUserId =
        SharedObjects.preferences.getString(Constants.sessionUserId);

    await addContactToUser(
        contactUsername: contactUsername, userId: sessionUserId ?? '');

    //add current user to new contact's contact list
    final contactUser = await getUser(username: contactUsername);
    final newContactId = contactUser.id;

    if (newContactId != null) {
      await addContactToUser(
          contactUsername: sessionUsername ?? '', userId: newContactId);
    } else {
      print('NEW CONTACT COULD NOT BE FOUND');
    }
  }

  Future<void> addContactToUser(
      {required String contactUsername, required String userId}) async {
    if (userId == '') {
      throw Exception('USER SESSIONID NOT SET');
    }

    //create a node with the username provided in the contacts collection
    final usersCollectionReference =
        fireStoreDb.collection(FirebasePaths.usersPath);

    final userDocumentReference = usersCollectionReference.doc(userId);
    //await to fetch user details of the username provided and set data
    final documentSnapshot = await userDocumentReference.get();
    print(documentSnapshot.data);

    final contacts = documentSnapshot.data()!['contacts'] != null
        ? List.from(documentSnapshot.data()!['contacts'])
        : [];

    if (!contacts.contains(contactUsername)) {
      contacts.add(contactUsername);
      await userDocumentReference.update({'contacts': contacts});

      await userDocumentReference
          .set({'contacts': contacts}, SetOptions(merge: true));
    } else {
      print('CONTACT ALREADY EXISTS IN YOUR CONTACT LIST');
    }
  }

  @override
  Future<String?> getUserIdByUsername({required String username}) async {
    //get reference to the mapping using username
    final ref =
        fireStoreDb.collection(FirebasePaths.usernameIdMapPath).doc(username);
    final documentSnapshot = await ref.get();
    print(documentSnapshot.exists);
    //check if id mapping for supplied username exists
    if (documentSnapshot.exists && documentSnapshot.data()!['id'] != null) {
      return documentSnapshot.data()!['id'];
    } else {
      throw UsernameMappingUndefinedException();
    }
  }

// @override
// Future<void> updateProfilePicture(String profilePictureUrl) async {
//   final id = SharedObjects.preferences.getString(Constants.sessionUid);
//   final ref = fireStoreDb.collection(FirebasePaths.usersPath).doc(
//       id); //reference of the user's document node in database/users. This node is created using id
//   final data = {
//     'photoUrl': profilePictureUrl,
//   };
//   await ref.set(data, SetOptions(merge: true)); // set the photourl
// }

// @override
// Future<bool> isProfileComplete(String id) async {
//   final documentReference = fireStoreDb
//       .collection(Paths.usersPath)
//       .doc(id); // get reference to the user/ id node
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
