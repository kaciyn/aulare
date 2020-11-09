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
  final fireStoreDb = FirebaseFirestore.instance;

  @override
  Future<User> saveDetailsFromGoogleAuth(firebase.User user) async {
    var documentReference = fireStoreDb.collection(Paths.usersPath).doc(user
        .uid); //reference of the user's document node in database/users. This node is created using uid
    final userExists = await documentReference
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
    await documentReference.set(data, SetOptions(merge: true)); // set the data
    final currentDocument =
        await documentReference.get(); // get updated data reference
    return User.fromFirestore(
        currentDocument); // create a user object and return
  }

  @override
  Future<User> saveProfileDetails(
      String uid, String profileImageUrl, String username) async {
    var documentReference = fireStoreDb.collection(Paths.usersPath).doc(
        uid); //reference of the user's document node in database/users. This node is created using uid
    var data = {
      'profileImageUrl': profileImageUrl,
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
  Future<bool> isProfileComplete(String uid) async {
    final documentReference = fireStoreDb
        .collection(Paths.usersPath)
        .doc(uid); // get reference to the user/ uid node
    final currentDocument = await documentReference.get();

    return currentDocument.exists &&
        currentDocument.data().containsKey(
            'username'); // check if it exists, if yes then check if username and age field are there or not. If not then profile incomplete else complete
  }

  @override
  Stream<List<Contact>> getContacts() {
    final userReference = fireStoreDb.collection(Paths.usersPath);
    final reference =
        userReference.doc(SharedObjects.preferences.get(Constants.sessionUid));
    // DocumentSnapshot documentSnapshot = await ref.get();

    return reference.snapshots().transform(
        StreamTransformer<DocumentSnapshot, List<Contact>>.fromHandlers(
            handleData: (DocumentSnapshot documentSnapshot,
                EventSink<List<Contact>> sink) async {
      List<String> contacts;
      if (documentSnapshot.data()['contacts'] == null) {
        await reference.update({'contacts': []});
        contacts = List();
      } else {
        contacts = List.from(documentSnapshot.data()['contacts']);
      }
      final contactList = <Contact>[];
      for (final username in contacts) {
        print(username);
        final uid = await getUidByUsername(username);
        final contactSnapshot = await userReference.document(uid).get();
        contactList.add(Contact.fromFirestore(contactSnapshot));
      }
      sink.add(contactList);
    }));
  }

  @override
  Future<void> addContact(String username) async {
    await getUser(username);
    //create a node with the username provided in the contacts collection
    final ref = fireStoreDb
        .collection(Paths.usersPath)
        .doc(SharedObjects.preferences.get(Constants.sessionUid));
    //await to fetch user details of the username provided and set data
    final documentSnapshot = await ref.get();
    print(documentSnapshot.data);
    final contacts = documentSnapshot.data()['contacts'] != null
        ? List.from(documentSnapshot.data()['contacts'])
        : [];

    if (contacts.contains(username)) {
      throw ContactAlreadyExistsException();
    }

    contacts.add(username);
    await ref.update({'contacts': contacts});
  }

  @override
  Future<User> getUser(String username) async {
    final uid = await getUidByUsername(username);
    final ref = fireStoreDb.collection(Paths.usersPath).document(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return User.fromFirestore(snapshot);
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Future<String> getUidByUsername(String username) async {
    //get reference to the mapping using username
    final ref =
        fireStoreDb.collection(Paths.usernameUidMapPath).document(username);
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
}
