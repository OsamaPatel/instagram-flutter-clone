import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String photoUrl;
  final String email;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'bio': bio,
        'uid': uid,
        'followers': followers,
        'following': following,
        'photoUrl': photoUrl
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return User(
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      email: snapshot['email'],
    );
  }
}
