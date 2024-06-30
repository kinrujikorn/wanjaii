import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String id;
  final String user1;
  final String user2;

  Match({required this.id, required this.user1, required this.user2});

  factory Match.fromFirestore(DocumentSnapshot doc) {
    return Match(
      id: doc.id,
      user1: doc.get('user1'),
      user2: doc.get('user2'),
    );
  }

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] ?? '',
      user1: json['user1'] ?? '',
      user2: json['user2'] ?? '',
    );
  }
}
