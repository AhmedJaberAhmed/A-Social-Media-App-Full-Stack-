import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Uploadpage extends StatefulWidget {
  const Uploadpage({super.key});

  @override
  State<Uploadpage> createState() => _UploadpageState();
}

class _UploadpageState extends State<Uploadpage> {
  File? _imageFile;

// pick image
  Future pickImage() async {
    // picker
    final ImagePicker picker = ImagePicker();

    // pick from gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // update image preview
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // upload
  Future uploadImage() async {
    if (_imageFile == null) return;

    // generate a unique file path
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'uploads/$fileName';

    // upload the image to supabase storage
    await Supabase.instance.client.storage
    // to this bucket
        .from('proimages')
        .upload(path, _imageFile!)
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image upload successful!")),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Page"),
      ),
      body: Center(
        child: Column(
          children: [
            // image preview
            _imageFile != null
                ? Image.file(_imageFile!)
                : const Text("No image selected.."),

            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade500, // primary
                foregroundColor: Colors.white, // text color
                elevation: 4,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Pick Image",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20,)
            ,  // pick image button
            ElevatedButton(
              onPressed:uploadImage,
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );

  }
}
