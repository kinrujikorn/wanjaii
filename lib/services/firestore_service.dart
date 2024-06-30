// firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../models/models.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> fetchUsers() async {
    print('Fetching users...');
    final querySnapshot = await _firestore.collection('users').get();
    print('Number of users: ${querySnapshot.size}');
    final users = querySnapshot.docs.map((doc) {
      print('User data: ${doc.data()}'); // Add this line
      return User.fromFirestore(doc.data());
    }).toList();
    return users;
  }

  Future<void> createUserDocument(String uid, String email) async {
    try {
      // Create a new user document in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        // Add other user properties if needed
      });
    } catch (error) {
      // Handle error
      print('Error creating user document: $error');
      rethrow; // Optional: Rethrow the error for handling in the UI
    }
  }

  Future<bool> checkIfUserLikedCurrentUser(
      String swipedUserId, String currentUserId) async {
    final docRef = _firestore.collection('users').doc(swipedUserId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final likes = docSnapshot.data()!['likes']
          as List<String>; // Assuming 'likes' is a list of user IDs
      return likes.contains(currentUserId);
    } else {
      return false; // User document doesn't exist or doesn't have 'likes' field
    }
  }

  // Get the current user ID
  Future<String> getCurrentUserId() async {
    // Assuming you have a way to get the current user from Firebase Auth
    // You'll need to implement this based on your authentication setup
    final user = await FirebaseAuth.instance
        .currentUser; // Implement based on your authentication provider
    return user!.uid;
  }

  // ... add other data access methods as needed
  // (e.g., fetchUserById, updateUserBio, createUser, deleteUser)
}
