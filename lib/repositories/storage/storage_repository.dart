import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_dating_app/repositories/storage/base_storage_repository.dart';
import 'package:flutter_dating_app/repositories/databases/database_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/models.dart';

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<void> uploadImage(User user, XFile image) async {
    try {
      await storage
          .ref('${user.uid}/${image.name}')
          .putFile(File(image.path))
          .then((p0) =>
              DatabaseRepository().updateUserPictures(user, image.name));
    } catch (_) {}
  }

  @override
  Future<String> getDownloadURL(User user, String imageName) async {
    String downloadURL =
        await storage.ref('${user.uid}/$imageName').getDownloadURL();
    return downloadURL;
  }
}
