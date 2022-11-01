import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

import 'message_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // getUsers() async {
  //   var users = await FirebaseFirestore.instance.collection('users').snapshots();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text("Chats"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MessageScreen(user: snapshot.data?.docs[index]),
                  ));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data?.docs[index]['photoUrl']),
                  ),
                  title: Text(snapshot.data?.docs[index]['username']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
