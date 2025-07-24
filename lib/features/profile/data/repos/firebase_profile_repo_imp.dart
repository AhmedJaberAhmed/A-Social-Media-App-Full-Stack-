import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/features/profile/domain/profile_user.dart';
import 'package:instagram/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          return ProfileUser(
            uid: uid,
            email: data["email"],
            name: data["name"],
            bio: data["bio"]??" ",
            profileImageUrl: data["profileImageUrl"]?.toString() ?? "",
          );
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }


  @override
  Future<void> updateProfile(ProfileUser profileUser) async{
    try{
      await firebaseFirestore.collection("users").doc(profileUser.uid).update({
        'bio':profileUser.bio,
        "profileImageUrl":profileUser.profileImageUrl

      });

    }catch(e){
      throw Exception(e);
    }
  }
} 