import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String uid;
  final String username;
  final String postId;
  final  datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.postUrl,
    required this.uid,
    required this.datePublished,
    required this.profImage,
    required this.likes,
    required this.postId,
    required this.username,
  });

  Map<String, dynamic> toJson() =>{
    "description": description,
    "uid": uid,
    "postId": postId,
    "postUrl": postUrl,
    "datePublished": datePublished,
    "profImage": profImage,
    "likes": likes,
    "username": username,

  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      postId: snapshot['postId'], 
      postUrl: snapshot['postUrl'], 
      datePublished:snapshot['datePublished'], 
      profImage: snapshot['profImage'], 
      likes: snapshot['likes'], 
      uid: snapshot['uid'], 
      username: snapshot['username'],
      description: snapshot['description'],
      );
  }
}