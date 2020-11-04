import 'dart:io';

class StorageRepository {
  StorageProvider storageProvider = StorageProvider();

  Future<String> uploadImage(File file, String path) =>
      storageProvider.uploadImage(file, path);
}
