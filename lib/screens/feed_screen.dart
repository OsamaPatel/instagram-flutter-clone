import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/screens/chat_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:sizer/sizer.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset(
            'assets/images/ic_instagram.svg',
            color: primaryColor,
            height: 5.h,
          ),
          backgroundColor: mobileBackgroundColor,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const ChatScreen();
                    },
                  ));
                },
                child: Container(
                  height: 6.h,
                  width: 6.w,
                  margin: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    'assets/images/message.png',
                    color: Colors.white,
                  ),
                ))
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('posts').get(),
          builder: (context, snapshot) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return PostCard(
                  snap: (snapshot.data! as dynamic)[index].data(),
                );
              },
            );
          },
        )
        // StreamBuilder(
        //   stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        //   builder: ((context,
        //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        //     if (!snapshot.hasData ||
        //         snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     return ListView.builder(
        //       physics: const BouncingScrollPhysics(),
        //       itemCount: snapshot.data!.docs.length,
        //       itemBuilder: (context, index) {
        //         return PostCard(snap: snapshot.data!.docs[index].data());
        //       },
        //     );
        //   }),
        // ),
        );
  }
}
