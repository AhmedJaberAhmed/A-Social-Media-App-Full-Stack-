import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:instagram/features/storage/domain/storage_repo/storage_repo.dart';
import 'package:meta/meta.dart';

import '../../../domain/profile_user.dart';
import '../../../domain/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  Future<void> fetchProfileUser(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User Not Found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());

    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      String? imageDownloadUrl;

      // ✅ Generate a unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${uid}_$timestamp.jpg';

      // ✅ Upload the new profile image (if provided)
      if (imageMobilePath != null) {
        imageDownloadUrl = await storageRepo.UploadProfileImageMobile(
            imageMobilePath, fileName);
      } else if (imageWebBytes != null) {
        imageDownloadUrl =
            await storageRepo.UploadProfileImageWeb(imageWebBytes, fileName);
      }

      // ❌ Check if image upload failed (if image was provided)
      if ((imageMobilePath != null || imageWebBytes != null) &&
          imageDownloadUrl == null) {
        emit(ProfileError("Failed to upload image"));
        return;
      }

      // ✅ Build updated user profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio,
        newProfileImageUrl: imageDownloadUrl,
      );

      // ✅ Save to repository
      await profileRepo.updateProfile(updatedProfile);

      // ✅ Emit updated profile
      await fetchProfileUser(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }

  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
     } catch (e) {
      emit(ProfileError("Error toggiling follow: $e"));
    }
  }
}
