

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
import '../../domain/entities/comment.dart';
import '../cubits/posts_cubit/post_cubit.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {

  AppUser? currentUser;
  bool isOwnPost=false;
  @override
  void initState() {
    super.initState();
   getCurrentPost();
  }

  void getCurrentPost(){
    final authCubit=context.read<AuthCubit>();
    currentUser=authCubit.currentUser;
    isOwnPost =(widget.comment.userId==currentUser!.uid);
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
              context.read<PostCubit>().deleteComment(widget.comment.postId,widget.comment.id);

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
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.comment.userName,
            style:
            const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
           Text(widget.comment.text),
Spacer(),
          if (isOwnPost)
            GestureDetector(
              onTap: showOptions,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.more_horiz, size: 20,color: Theme.of(context).colorScheme.primary,),
              ),
            ),


        ],
      ),
    );
  }
}
