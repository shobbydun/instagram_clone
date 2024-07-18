import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic>? snap;

  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  late User user; // Define user variable
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap?['postId'])
          .collection('comments')
          .get();
      if (mounted) {
        setState(() {
          commentLen = snap.docs.length;
        });
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snap == null) {
      return Container(); // Or return a placeholder widget or loading indicator
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildPostImage(context),
          _buildInteractionRow(context),
          _buildDescription(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (widget.snap == null ||
        widget.snap!['username'] == null ||
        widget.snap!['profImage'] == null) {
      return Container(); // Or handle loading state or placeholder
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              widget.snap!['profImage'],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.snap!['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle more options dialog
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shrinkWrap: true,
                      children: [
                        InkWell(
                          onTap: () async {
                            await FirestoreMethods().deletePost(widget.snap?['postId']);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(BuildContext context) {
    if (widget.snap == null || widget.snap!['postUrl'] == null) {
      return Container(); // Or handle loading state or placeholder
    }

    return GestureDetector(
      onDoubleTap: () async {
        await likePost(); // Call the method to handle liking the post
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.snap!['postUrl'],
              fit: BoxFit.cover,
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              child: const Icon(Icons.favorite, color: Colors.white, size: 120),
              isAnimating: isLikeAnimating,
              duration: const Duration(milliseconds: 400),
              onEnd: () {
                if (mounted) {
                  setState(() {
                    isLikeAnimating = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionRow(BuildContext context) {
    if (widget.snap == null ||
        widget.snap!['likes'] == null ||
        user.uid == null) {
      return Container(); // Or handle loading state or placeholder
    }

    bool isLikedByUser = widget.snap!['likes'].contains(user.uid);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          LikeAnimation(
            isAnimating: isLikedByUser,
            smallLike: true,
            child: IconButton(
              onPressed: () async {
                await likePost(); // Call the method to handle liking the post
              },
              icon: Icon(
                isLikedByUser ? Icons.favorite : Icons.favorite_border,
                color: isLikedByUser ? Colors.red : null,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CommentsScreen(
                  snap: widget.snap,
                ),
              ),
            ),
            icon: const Icon(
              Icons.comment_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (widget.snap == null ||
        widget.snap!['likes'] == null ||
        widget.snap!['username'] == null ||
        widget.snap!['description'] == null ||
        widget.snap!['datePublished'] == null) {
      return Container(); // Or handle loading state or placeholder
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '${widget.snap!['likes']!.length} likes',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: widget.snap!['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' ${widget.snap!['description']}',
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'View all $commentLen comments',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(widget.snap!['datePublished']),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.yMMMd().format(dateTime);
  }

  Future<void> likePost() async {
    // Call Firestore method to handle liking the post
    await FirestoreMethods().likePost(
      widget.snap?['postId'],
      user.uid,
      widget.snap?['likes'],
    );
    if (mounted) {
      setState(() {
        isLikeAnimating = true;
      });
    }
  }
}
