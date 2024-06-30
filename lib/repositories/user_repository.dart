// user_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart'; // Assuming User model

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users'; // Replace with your collection name

  Future<List<User>> getUsers() async {
    final querySnapshot = await _firestore.collection(_usersCollection).get();
    final users = querySnapshot.docs
        .map((doc) => User.fromFirestore(doc.data()))
        .toList();
    return users;
  }

  // You can add other methods for specific user retrieval or updates as needed
  // (e.g., getUserById, updateUser)
}
