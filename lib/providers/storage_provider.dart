import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'base_providers.dart';

class StorageProvider extends BaseStorageProvider {
  StorageProvider({FirebaseStorage? firebaseStorage})
      : firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;
  final FirebaseStorage firebaseStorage;

  @override
  Future<String> uploadFile(File file, String path) async {
    final reference = firebaseStorage
        .ref()
        .child(path); // get a reference to the path of the image directory
    final uploadTask = reference.putFile(file); // put the file in the path
    final result = await uploadTask
        .whenComplete(() => null); // wait for the upload to complete
    final url = await result.ref
        .getDownloadURL(); //retrieve the download link and return it
    print(url);
    return url;
  }

  @override
  void dispose() {}
}
