import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/posts/domain/entities/post_entity.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentaion/components/my_textField.dart';
import '../../../authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
import '../cubits/posts_cubit/post_cubit.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  AppUser? currentUser;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });
      if (kIsWeb) {
        webImage = imagePickedFile!.bytes;
      }
    }
  }

  void uploadImage() {
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Both Image and caption are required")));

      return;
    }
    final newPost = Post(
        id: DateTime.now().microsecond.toString(),
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: textController.text,
        imageUrl: " ",
        timestamp: DateTime.now(),
        likes: [],
      comments: []
    );

    final postCubit = context.read<PostCubit>();

    if (kIsWeb) {
      postCubit.craetePost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      postCubit.craetePost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostILoading || state is PostUploading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return buildUploadPage();
      },
      listener: (context, state) {
        if(state is PostLoaded){
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(  onPressed: uploadImage , icon:Icon(Icons.upload))
      ],
        title: Text("Create a Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            // image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            // image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            // pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ), // MaterialButton

            // caption text box
            MyTextField(
              controller: textController,
              hintText: "Caption",
              obscureText: false,
            ), // MyTextField
          ],
        ), // Column
      ), // Center
    );
  }
}
