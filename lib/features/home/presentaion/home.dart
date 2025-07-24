 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/posts/presentaion/pages/postTile.dart';

 import '../../posts/presentaion/cubits/posts_cubit/post_cubit.dart';
import '../../posts/presentaion/pages/UploadPostPage.dart';
import 'components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UploadPostPage()));
              },
              icon: Icon(Icons.add))
        ],
        centerTitle: true,
        title: Text("HOME"),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // loading..
          if (state is PostILoading && state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is PostLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No posts available"),
              );
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];
                return  PostTile(post: post, onDeletePressed:()=>deletePost(post.id));
              },
            );
          } else if (state is PostError) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          } else {
            return SizedBox();
          }
          // error
          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
