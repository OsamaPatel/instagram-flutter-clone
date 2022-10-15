import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String uid;
  final String postImageUrl;
  final String caption;
  final String postId;
  final String profImage;
  final datePublished;
  final likes;

  Post({
    required this.postImageUrl,
    required this.caption,
    required this.datePublished,
    required this.postId,
    required this.likes,
    required this.username,
    required this.uid,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'postImageUrl': postImageUrl,
        'caption': caption,
        'uid': uid,
        'postId': postId,
        'profImage': profImage,
        'datePublished': datePublished,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return Post(
      username: snapshot['username'],
      caption: snapshot['caption'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      datePublished: snapshot['datePublished'],
      uid: snapshot['uid'],
      likes: snapshot['likes'],
      postImageUrl: snapshot['postImageUrl'],
    );
  }
}
