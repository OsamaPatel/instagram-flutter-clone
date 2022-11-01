import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/comment_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Models/user_model.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  getComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLength = querySnapshot.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0.8.h, vertical: 0.8.h)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ProfileScreen(uid: widget.snap['uid']);
                            },
                          ));
                        },
                        child: Text(
                          widget.snap['username'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                      )
                    ],
                  ),
                )),
                widget.snap['uid'] == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: ListView(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map((e) => InkWell(
                                                onTap: () async {
                                                  await FirestoreMethods()
                                                      .deletePost(widget
                                                          .snap['postId']);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ));
                        },
                        icon: const Icon(Icons.more_vert))
                    : Container()
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 35.h,
                  width: double.infinity,
                  child: Hero(
                    tag: widget.snap['postImageUrl'],
                    child: Image.network(
                      widget.snap['postImageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(widget.snap['postId'],
                          user.uid, widget.snap['likes']);
                      setState(() {
                        isLikeAnimating = true;
                      });
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border)),
              ),
              SizedBox(
                width: 1.w,
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(snap: widget.snap)));
                  },
                  child: Image.asset(
                    'assets/images/comment.png',
                    height: 25,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 4.5.w,
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(snap: widget.snap)));
                  },
                  child: Image.asset(
                    'assets/images/send.png',
                    height: 3.h,
                    color: Colors.white,
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                ),
              ))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2 ??
                      const TextStyle(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return ProfileScreen(
                                            uid: widget.snap['uid']);
                                      },
                                    )),
                              text: widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: ' ${widget.snap['caption']}',
                            // style: const TextStyle(fontWeight: FontWeight.bold)
                          )
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CommentScreen(snap: widget.snap)));
                      },
                      child: Text(
                        'view all $commentLength comments',
                        style:
                            TextStyle(fontSize: 12.sp, color: secondaryColor),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(fontSize: 12.sp, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
