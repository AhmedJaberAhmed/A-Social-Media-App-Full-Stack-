import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/features/posts/domain/entities/comment.dart';
import 'package:instagram/features/posts/domain/entities/post_entity.dart';

import '../../domain/repos/post_repo.dart';

class PostRepoImp implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Store the posts in a collection called 'posts'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all posts with most recent posts at the top
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      // convert each firestore document from json -> list of posts
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      // fetch posts snapshot with this uid
      final postsSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      // convert firestore documents from json => list of posts
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error fetching posts by user: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        final hasLiked = post.likes.contains(userId);
        if (hasLiked) {
          post.likes.remove(userId);
        }else{
          post.likes.add(userId);
        }
        await postsCollection.doc(postId).update({
          'likes':post.likes
        });
      }else{
        throw Exception("Post Not Found");
      }
    } catch (e) {
      throw Exception("Error Toggling Like");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async{
    try {
      // get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert json object --> post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the new comment
        post.comments.add(comment);

        // update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }

  }

  @override
  Future<void> deleteComment(String postId, String commentId) async{



    try {
      // get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert json object --> post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error deleting comment: $e");
    }






  }
}
