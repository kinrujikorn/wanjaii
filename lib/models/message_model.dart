import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String type;
  final String message;
  final String imageUrls;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.type,
    required this.message,
    required this.imageUrls,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'type': type,
      'message': message,
      'imageUrls': imageUrls,
      'timestamp': timestamp,
    };
  }
}
