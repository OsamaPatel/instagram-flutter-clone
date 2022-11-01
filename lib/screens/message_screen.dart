import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Models/user_model.dart' as model;
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/my_message_widget.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/sender_message_box.dart';

class MessageScreen extends StatefulWidget {
  final user;
  const MessageScreen({super.key, required this.user});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = TextEditingController();
  String message = '';

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User currentUser = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back)),
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(uid: widget.user['uid']),
                  ));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user['photoUrl']),
                  radius: 15,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(uid: widget.user['uid']),
                    ));
                  },
                  child: Text(widget.user['username'])),
            ],
          ),
          backgroundColor: mobileBackgroundColor,
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user['uid'])
                  .collection('chats')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('messages')
                  .orderBy('timeSent', descending: false)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data?.docs[index]['senderId'] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.user['uid'])
                                          .collection('chats')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('messages')
                                          .doc(snapshot.data?.docs[index]
                                              ['messageId'])
                                          .delete();
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('chats')
                                          .doc(widget.user['uid'])
                                          .collection('messages')
                                          .doc(snapshot.data?.docs[index]
                                              ['messageId'])
                                          .delete();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 8),
                                        child: const Text('delete')),
                                  ),
                                );
                              },
                            );
                          },
                          child: MyMessageBox(
                            message: snapshot.data?.docs[index]['message'],
                            messageBoxColor: Colors.blueAccent,
                            time: snapshot.data?.docs[index]['timeSent'],
                          ),
                        );
                      }
                      return SenderMessageBox(
                        message: snapshot.data?.docs[index]['message'],
                        messageBoxColor: const Color.fromRGBO(117, 117, 117, 1),
                        time: snapshot.data?.docs[index]['timeSent'],
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Message...",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await FirestoreMethods().uploadMessage(
                            senderUid: FirebaseAuth.instance.currentUser!.uid,
                            senderUsername: currentUser.username,
                            message: messageController.text,
                            recieverUid: widget.user['uid'],
                            recieverUsername: widget.user['username']);
                        messageController.clear();
                      },
                      child: const Text('Send'))
                ],
              ),
            ),
          ],
        ));
  }
}
