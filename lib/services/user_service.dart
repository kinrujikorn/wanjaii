import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_dating_app/models/user.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

//use this
  Future<User> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Current user is null');
    }

    final userData =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return User.fromMap(userData.data() ?? {});
  }

  Future<void> updateUserBio({required String bio}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Current user is null');
    }

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .update({'bio': bio});
  }

//use this
  Future<void> updateUserImage({required String imageUrls}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Current user is null');
    }

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .update({'imageUrls': imageUrls});
  }

  Future<List<User>> fetchPotentialMatches() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Current user is null');
    }

    final querySnapshot = await _firestore
        .collection('users')
        .where('age', isGreaterThan: 18)
        .limit(10)
        .get();

    final List<User> potentialMatches = [];

    for (final doc in querySnapshot.docs) {
      final user = User.fromMap(doc.data());
      if (user.uid != currentUser.uid) {
        potentialMatches.add(user);
      }
    }

    return potentialMatches;
  }

  Future<List<User>> fetchMatchedUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Current user is null');
    }

    final querySnapshot = await _firestore
        .collection('chats')
        .where('users', arrayContains: currentUser.uid)
        .get();

    final List<User> matchedUsers = [];

    for (final doc in querySnapshot.docs) {
      final dynamic users = doc['users'];
      if (users is List) {
        for (final uid in users) {
          if (uid != currentUser.uid) {
            final userData =
                await _firestore.collection('users').doc(uid).get();
            final user = User.fromMap(userData.data() ?? {});
            matchedUsers.add(user);
          }
        }
      } else if (users is String) {
        final List<String> uids = users.split(',');
        for (final uid in uids) {
          if (uid != currentUser.uid) {
            final userData =
                await _firestore.collection('users').doc(uid).get();
            final user = User.fromMap(userData.data() ?? {});
            matchedUsers.add(user);
          }
        }
      }
    }

    return matchedUsers;
  }
}
