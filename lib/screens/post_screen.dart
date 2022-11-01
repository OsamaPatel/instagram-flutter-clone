import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

import '../widgets/post_card.dart';

class PostScreen extends StatefulWidget {
  final snap;
  const PostScreen({super.key, required this.snap});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back)),
          backgroundColor: mobileBackgroundColor,
          title: const Text('Post'),
          centerTitle: false,
        ),
        body: PostCard(snap: widget.snap));
  }
}
