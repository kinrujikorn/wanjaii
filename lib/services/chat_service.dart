// import 'dart:html';
// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dating_app/models/message_model.dart';

class ChatServices {
  //Send Message
  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        type: "text",
        message: message,
        imageUrls: "",
        timestamp: timestamp);

    //Construct a chat room id
    List<String> ids = [currentUserID, receiverId];
    ids.sort(); //ensure chatroomid contain only 2 people
    String chatRoomId = ids.join('_');

    await FirebaseFirestore.instance
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    // Update match collection for both user1 and user2 using logical OR
    await FirebaseFirestore.instance
        .collection("matches")
        .where("user1", whereIn: [currentUserID, receiverId])
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if ([currentUserID, receiverId].contains(doc["user2"])) {
              doc.reference.update({"chat": "Yes"});
            }
          });
        });
  }

  Future<void> sendImage(String receiverId, imageUrls) async {
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //Construct a chat room id
    List<String> ids = [currentUserID, receiverId];
    ids.sort(); //ensure chatroomid contain only 2 people
    String chatRoomId = ids.join('_');

    Message newMessage = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        type: "image",
        message: "",
        imageUrls: imageUrls,
        timestamp: timestamp);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Current user is null');
    }

    await FirebaseFirestore.instance
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // File? imageFile; // Declare imageFile as a nullable File object

  // Future<void> getImage() async {
  //   ImagePicker _picker = ImagePicker();
  //   // Use try-catch block to handle any potential exceptions
  //   try {
  //     // Use await to wait for the image picking process to complete
  //     var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     // Check if an image was picked
  //     if (pickedFile != null) {
  //       // Assign the picked image file to imageFile
  //       imageFile = File(pickedFile.path);
  //     }
  //   } catch (e) {
  //     // Handle any potential errors
  //     print('Error picking image: $e');
  //   }
  // }

  // Future uploadImage() async {

  // }

  //Get Message
  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return FirebaseFirestore.instance
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Stream<DocumentSnapshot?> getLatestMessage(
  //     String userId, String otherUserId) {
  //   List<String> ids = [userId, otherUserId];
  //   ids.sort();
  //   String chatRoomId = ids.join('_');
  //   return FirebaseFirestore.instance
  //       .collection("chat_room")
  //       .doc(chatRoomId)
  //       .collection("messages")
  //       .orderBy("timestamp", descending: true)
  //       .limit(1) // Limit to only one document (the latest)
  //       .snapshots()
  //       .map((snapshot) {
  //     if (snapshot.docs.isEmpty) {
  //       return null; // Return null if there are no messages
  //     } else {
  //       return snapshot.docs.first;
  //     }
  //   });
  // }
}
