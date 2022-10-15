import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/Models/user_model.dart' as model;
import 'package:instagram/resources/storage_methods.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String username,
      required String bio,
      required String email,
      required String password,
      required Uint8List file}) async {
    String res = "Please enter all the fields.";
    try {
      if (username.isNotEmpty ||
          bio.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty) {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            username: username,
            email: email,
            bio: bio,
            uid: userCred.user!.uid,
            followers: [],
            following: [],
            photoUrl: photoUrl);

        await _firestore
            .collection('users')
            .doc(userCred.user!.uid)
            .set(user.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "Email invalid.";
      } else if (e.code == 'weak-password') {
        res = "Please create a strong password.";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Please enter all the fields.";
    if (email.isNotEmpty || password.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Logged in successfully.";
      } on FirebaseAuthException catch (e) {
        if (e.code == "invalid-email") {
          res = "email address not valid.";
        } else if (e.code == "user-not-found") {
          res = "user does not exist.";
        } else if (e.code == "wrong-password") {
          res = "incorrect password.";
        }
      } catch (e) {
        res = e.toString();
      }
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
