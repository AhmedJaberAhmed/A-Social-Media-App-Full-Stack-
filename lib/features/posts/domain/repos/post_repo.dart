import 'package:instagram/features/posts/domain/entities/comment.dart';
import 'package:instagram/features/posts/domain/entities/post_entity.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();

  Future<void> createPost(Post post);

  Future<void> deletePost(String postId);

  Future<List<Post>> fetchPostByUserId(String userId);

  Future <void>toggleLikePost(String postId,String userId);

  Future<void> addComment(String postId,Comment comment);
  Future<void> deleteComment(String postId,String commentId);


}
