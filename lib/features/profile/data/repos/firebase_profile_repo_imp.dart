import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/features/profile/domain/profile_user.dart';
import 'package:instagram/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          final followers = List<String>.from(data['followers'] ?? []);
          final following = List<String>.from(data['following'] ?? []);

          return ProfileUser(
              uid: uid,
              email: data["email"],
              name: data["name"],
              bio: data["bio"] ?? " ",
              profileImageUrl: data["profileImageUrl"]?.toString() ?? "",
              followers: followers,
              following: following);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser profileUser) async {
    try {
      await firebaseFirestore.collection("users").doc(profileUser.uid).update({
        'bio': profileUser.bio,
        "profileImageUrl": profileUser.profileImageUrl
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc = await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc = await firebaseFirestore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing = List<String>.from(currentUserData['following'] ?? []);

           if (currentFollowing.contains(targetUid)) {
             await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });

            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });

            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    } catch (e) {
      print("Toggle follow failed: $e");

    }
  }
}
