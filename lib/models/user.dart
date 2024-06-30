class User {
  final String id;
  final String name;
  final String bio;
  final String? imageUrls;
  final String uid; // Add this field

  User({
    required this.id,
    required this.name,
    required this.bio,
    required this.uid, // Add this parameter
    this.imageUrls,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      uid: data['uid'] ?? '', // Assign uid here
      imageUrls: data['imageUrls'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'uid': uid, // Include uid in the map
      'imageUrls': imageUrls,
    };
  }
}
