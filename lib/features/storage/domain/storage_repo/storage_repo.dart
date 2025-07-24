import 'dart:typed_data';

abstract class StorageRepo {
  Future<String?> UploadProfileImageMobile(String path, String fileName);
  Future<String?> UploadProfileImageWeb(Uint8List fileBytes, String fileName);

  Future<String?> UploadPostImageMobile(String path, String fileName);
  Future<String?> UploadPostImageWeb(Uint8List fileBytes, String fileName);

}
