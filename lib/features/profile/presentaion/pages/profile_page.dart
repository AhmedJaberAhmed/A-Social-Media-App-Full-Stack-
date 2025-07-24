import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/posts/presentaion/pages/postTile.dart';

import '../../../authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
import '../../../posts/presentaion/cubits/posts_cubit/post_cubit.dart';
import '../component/bio_box.dart';
import '../cubite/profile_cubit/profile_cubit.dart';
import 'editProfilePage.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  int postCount = 0;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchProfileUser(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfilepage(profileUser: user),
                      ),
                    );
                  },
                  icon: Icon(Icons.settings),
                )
              ],
              centerTitle: true,
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Profile Image
                  CachedNetworkImage(
                    key: ValueKey(
                        '${user.profileImageUrl}?v=${DateTime.now().millisecondsSinceEpoch}'),
                    imageUrl:
                        '${user.profileImageUrl}?v=${DateTime.now().millisecondsSinceEpoch}',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Bio Section
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Text(
                          "Bio",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  BioBox(
                    text: user.bio.isNotEmpty ? user.bio : "No bio added yet.",
                  ),

                  // Posts Placeholder
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 25),
                    child: Row(
                      children: [
                        Text(
                          "Posts",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),

                  BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                    if (state is PostLoaded) {
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();
                      postCount = userPosts.length;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: postCount,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];
                          return PostTile(
                              post: post,
                              onDeletePressed: () {
                                context.read<PostCubit>().deletePost(post.id);
                              });
                        },
                      );
                    } else if (state is PostILoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text("No Posts"),
                      );
                    }
                  })
                ],
              ),
            ),
          );
        }

        // Loading state
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error or empty state
        else {
          return const Scaffold(
            body: Center(
              child: Text("No profile found.."),
            ),
          );
        }
      },
    );
  }
}
