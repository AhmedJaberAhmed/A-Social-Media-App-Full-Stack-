import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:instagram/features/posts/domain/repos/post_repo.dart';
import 'package:instagram/features/storage/domain/storage_repo/storage_repo.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/comment.dart';
import '../../../domain/entities/post_entity.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostInitial());

  Future<void> craetePost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.UploadPostImageMobile(imagePath, post.id);
      } else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.UploadPostImageWeb(imageBytes, post.id);
      }

      final newPost = post.copyWith(imageUrl: imageUrl);
      postRepo.createPost(newPost);
      fetchAllPosts();
    } catch (e) {
      emit(PostError("Failed to create a posts"));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostILoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError("Failed to fetch posts"));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError("Failed to delete a post"));
    }
  }

  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
      // fetchAllPosts();
    } catch (e) {
      emit(PostError("Failed to toggle like"));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError("Failed to add comment"));
    }
  }


  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError("Failed to delete comment"));
    }
  }




}
