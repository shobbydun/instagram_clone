import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData; // Change to nullable Map
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up any active operations if needed
  }

  Future<void> getData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>?> userSnap = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userSnap.exists) {
        // Fetch user's posts count
        QuerySnapshot postSnap = await FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: widget.uid)
            .get();

        setState(() {
          userData = userSnap.data();
          postLength = postSnap.size;
          followers = userData?['followers']?.length ?? 0;
          following = userData?['following']?.length ?? 0;
          isFollowing = userData?['followers']
                  ?.contains(FirebaseAuth.instance.currentUser!.uid) ??
              false;
          isLoading = false;
        });
      } else {
        // Handle case where user document doesn't exist
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User data not found'),
          ),
        );
      }
    } catch (e) {
      // Handle error gracefully
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData?['username'] ?? 'Loading...'),
              centerTitle: false,
            ),
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : userData != null
                    ? ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: userData?['photoUrl'] !=
                                                  null &&
                                              userData?['photoUrl'].isNotEmpty
                                          ? NetworkImage(userData?['photoUrl'])
                                          : null,
                                      radius: 56,
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildStateColumn(
                                                  postLength, 'posts'),
                                              buildStateColumn(
                                                  followers, 'followers'),
                                              buildStateColumn(
                                                  following, 'following'),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          FirebaseAuth.instance.currentUser!
                                                      .uid ==
                                                  widget.uid
                                              ? FollowButton(
                                                  text: 'Sign Out',
                                                  backgroundColor:
                                                      mobileBackgroundColor,
                                                  textColor: primaryColor,
                                                  borderColor: Colors.grey,
                                                  function: () async {
                                                    await AuthMethods()
                                                        .signout();
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen(),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : isFollowing
                                                  ? FollowButton(
                                                      text: 'Unfollow',
                                                      backgroundColor:
                                                          Colors.white,
                                                      textColor: Colors.black,
                                                      borderColor: Colors.grey,
                                                      function: () async {
                                                        await FirestoreMethods()
                                                            .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData?['uid'],
                                                        );
                                                        setState(() {
                                                          isFollowing = false;
                                                          followers--;
                                                        });
                                                      },
                                                    )
                                                  : FollowButton(
                                                      text: 'Follow',
                                                      backgroundColor:
                                                          Colors.blue,
                                                      textColor: Colors.white,
                                                      borderColor: Colors.blue,
                                                      function: () async {
                                                        await FirestoreMethods()
                                                            .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData?['uid'],
                                                        );
                                                        setState(() {
                                                          isFollowing = true;
                                                          followers++;
                                                        });
                                                      },
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  userData?['username'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  userData?['bio'] ?? 'No bio available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('posts')
                                  .where('uid', isEqualTo: widget.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot snap =
                                        (snapshot.data! as dynamic).docs[index];

                                    return Container(
                                      child: Image(
                                        image: NetworkImage(
                                          snap['postUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                );
                              })
                        ],
                      )
                    : Center(child: Text('User data not found')),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
