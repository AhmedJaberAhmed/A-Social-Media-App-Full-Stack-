import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/posts/presentaion/pages/postTile.dart';
import 'package:instagram/features/profile/presentaion/pages/followers_page.dart';

import '../../../../responsive/canstariant_scaffold.dart';
import '../../../authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
import '../../../posts/presentaion/cubits/posts_cubit/post_cubit.dart';
import '../component/bio_box.dart';
import '../component/follow_button.dart';
import '../component/profile_status.dart';
import '../cubite/profile_cubit/profile_cubit.dart';
import 'editProfilePage.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthCubit authCubit;
  late ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    profileCubit = context.read<ProfileCubit>();
    profileCubit.fetchProfileUser(widget.uid);
  }

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final currentUser = authCubit.currentUser;

    final isFollowing = profileUser.followers.contains(currentUser!.uid);
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser.uid);
      } else {
        profileUser.followers.add(currentUser.uid);
      }
    });

    profileCubit.toggleFollow(currentUser.uid, widget.uid).catchError((error) {
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(currentUser.uid);
        } else {
          profileUser.followers.remove(currentUser.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authCubit.currentUser;
    final bool isOwnProfile =
        currentUser != null && widget.uid == currentUser.uid;

    final postState = context.watch<PostCubit>().state;
    int postCount = 0;
    if (postState is PostLoaded) {
      postCount =
          postState.posts.where((post) => post.userId == widget.uid).length;
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;
  //ConstrainedScaffold
          return Scaffold(
            appBar: AppBar(
              actions: [
                if (isOwnProfile)
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
                  ),
              ],
              centerTitle: true,
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 25),
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
                  ProfileStats(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FollowersPage(followers: user.followers, following: user.following)));
                    },
                    followerCount: user.followers.length,
                    followingCount: user.following.length,
                    postCount: postCount,
                  ),
                  if (!isOwnProfile)
                    FollowButton(
                      onPressed: followButtonPressed,
                      isFollowing: user.followers.contains(currentUser!.uid),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Text(
                          "Bio",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  BioBox(
                    text: user.bio,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 25,bottom: 14),
                    child: Row(
                      children: [
                        Text(
                          "Posts",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, state) {
                      if (state is PostLoaded) {
                        final userPosts = state.posts
                            .where((post) => post.userId == widget.uid)
                            .toList();

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userPosts.length,
                          itemBuilder: (context, index) {
                            final post = userPosts[index];
                            return PostTile(
                              post: post,
                              onDeletePressed: () {
                                context.read<PostCubit>().deletePost(post.id);
                              },
                            );
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
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          return const ConstrainedScaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const ConstrainedScaffold(
            body: Center(
              child: Text("No profile found.."),
            ),
          );
        }
      },
    );
  }
}
