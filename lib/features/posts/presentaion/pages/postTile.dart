import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
import 'package:instagram/features/posts/presentaion/cubits/posts_cubit/post_cubit.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../profile/domain/profile_user.dart';
import '../../../profile/presentaion/cubite/profile_cubit/profile_cubit.dart';
import '../../domain/entities/post_entity.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser?.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed?.call();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl = postUser?.profileImageUrl ?? '';
    final resolvedImageUrl = profileImageUrl.isNotEmpty
        ? '$profileImageUrl?v=${postUser?.uid}' // simple versioning to bust cache
        : '';

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User row with avatar and name
          Row(
            children: [
              // Profile avatar
              resolvedImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                key: ValueKey(resolvedImageUrl),
                imageUrl: resolvedImageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.person),
              )
                  : const Icon(Icons.person, size: 40),

              const SizedBox(width: 10),

              // Username
              Expanded(
                child: Text(
                  widget.post.userName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              // Delete button (if own post)
              if (isOwnPost)
                IconButton(
                  onPressed: showOptions,
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Post image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ],
      ),
    );
  }
}
