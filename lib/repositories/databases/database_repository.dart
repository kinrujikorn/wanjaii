import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dating_app/models/user_model.dart';
import 'package:flutter_dating_app/repositories/databases/base_database_repository.dart';
import 'package:flutter_dating_app/repositories/storage/storage_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUserPictures(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);
    return _firebaseFirestore.collection('users').doc(user.uid).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update(user.toMap())
        .then((value) => print('User document update.'));
  }
}
