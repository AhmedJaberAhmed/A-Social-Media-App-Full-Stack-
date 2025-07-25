import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/authentication/presentaion/components/my_textField.dart';
import 'package:instagram/features/profile/presentaion/cubite/profile_cubit/profile_cubit.dart';

import '../../../../responsive/canstariant_scaffold.dart';
import '../../domain/profile_user.dart';

class EditProfilepage extends StatefulWidget {
  final ProfileUser profileUser;

  const EditProfilepage({super.key, required this.profileUser});

  @override
  State<EditProfilepage> createState() => _EditProfilepageState();
}

class _EditProfilepageState extends State<EditProfilepage> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;

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

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    final String uid = widget.profileUser.uid;
    final String? newBio = bioTextEditingController.text.isNotEmpty
        ? bioTextEditingController.text
        : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    } else {
      Navigator.pop(context);
    }
  }

  final bioTextEditingController = TextEditingController();

  @override
  void dispose() {
    bioTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      if (state is ProfileLoading) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), Text("Uploading...")],
            ),
          ),
        );
      } else {
        return BuildEditPage();
      }
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget BuildEditPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: updateProfile, icon: Icon(Icons.upload))
        ],
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text("Edit Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                    File(imagePickedFile!.path!),
                    fit: BoxFit.cover,
                  )
                      : (kIsWeb && webImage != null)
                      ? Image.memory(
                    webImage!,
                    fit: BoxFit.cover,
                  )
                      : CachedNetworkImage(
                    imageUrl:
                    '${widget.profileUser.profileImageUrl}?v=${DateTime.now().millisecondsSinceEpoch}',
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MaterialButton(
                  onPressed: pickImage,
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 2,
                  child: Text(
                    "Pick Image",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Bio",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: bioTextEditingController,
                hintText: widget.profileUser.bio,
                obscureText: false,
              ),
              const SizedBox(height: 40), // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }

}
