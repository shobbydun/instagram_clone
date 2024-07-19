import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
  });

  static User? fromSnapshot(DocumentSnapshot? snap) {
    if (snap == null || !snap.exists) {
      return null; // Return null if snapshot is null or document doesn't exist
    }

    var snapshotData = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshotData["username"] ?? "",
      uid: snapshotData["uid"] ?? "",
      email: snapshotData["email"] ?? "",
      photoUrl: snapshotData["photoUrl"] ?? "",
      bio: snapshotData["bio"] ?? "",
      followers: snapshotData["followers"] ?? [],
      following: snapshotData["following"] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
