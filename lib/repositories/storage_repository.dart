import 'dart:io';

import 'package:aulare/providers/storage_provider.dart';

class StorageRepository {
  StorageProvider storageProvider = StorageProvider();

  Future<String> uploadFile(File file, String path) =>
      storageProvider.uploadFile(file, path);
}
