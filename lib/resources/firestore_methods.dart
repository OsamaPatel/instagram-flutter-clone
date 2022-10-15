import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram/Models/post_model.dart';
import 'package:instagram/resources/storage_methods.dart';

class FirestoreMethods {
  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          caption: caption,
          uid: uid,
          likes: [],
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postImageUrl: photoUrl,
          profImage: profImage);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> uploadComment(String comment, String postId, String uid,
      String username, String photoUrl) async {
    String res = "Some error occured";
    try {
      if (comment.isNotEmpty) {
        String id = const Uuid().v1();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(id)
            .set({
          'username': username,
          'photoUrl': photoUrl,
          'comment': comment,
          'datePublished': DateTime.now(),
        });
        res = "Commented successfully";
      } else {
        res = "Comment cannot be empty";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occured";
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      res = "Deleted Successfully";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
