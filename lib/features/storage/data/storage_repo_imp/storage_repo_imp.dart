import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/storage_repo/storage_repo.dart';

class StorageRepoImp implements StorageRepo {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<String?> UploadPostImageMobile(String path, String fileName) {
    final file = File(path);
    return _uploadFile(file.readAsBytesSync(), fileName, "post_images");
  }

  @override
  Future<String?> UploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFile(fileBytes, fileName, "post_images");
  }

  @override
  Future<String?> UploadProfileImageMobile(String path, String fileName) {
    final file = File(path);
    return _uploadFile(file.readAsBytesSync(), fileName, "profile_images");
  }

  @override
  Future<String?> UploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFile(fileBytes, fileName, "profile_images");
  }

  Future<String?> _uploadFile(Uint8List fileBytes, String fileName, String folder) async {
    try {
      final String filePath = '$folder/$fileName';

      final response = await supabase.storage
          .from('proimages') // Your bucket name
          .uploadBinary(
        filePath,
        fileBytes,
        fileOptions: const FileOptions(contentType: 'image/*', upsert: true),
      );

      if (response.isEmpty) return null;

      // For public buckets (default case)
      final publicUrl = supabase.storage.from('proimages').getPublicUrl(filePath);
      return publicUrl;

      // 🔐 If using a private bucket, replace above line with:
      // final signedUrl = await supabase.storage.from('proimages').createSignedUrl(filePath, 3600);
      // return signedUrl;

    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
