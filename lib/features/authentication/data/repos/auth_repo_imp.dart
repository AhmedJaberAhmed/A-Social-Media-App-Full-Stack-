import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/features/authentication/domain/entities/app_user.dart';
import '../../domain/repos/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = auth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    DocumentSnapshot userDoc = await firebaseFirestore
        .collection("users")
        .doc(firebaseUser.uid)
        .get();
   if(!userDoc.exists){
     return null;
   }
    return AppUser(
      uid: firebaseUser.uid,
      name: userDoc['name'],
      email: firebaseUser.email!,
    );
  }

  @override
  Future<AppUser?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      return AppUser(
        uid: userCredential.user!.uid,
        name:  userDoc['name'],
        email: email,
      );
    } catch (e) {
      throw Exception("Login Failed: ${e.toString()}");
    }
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppUser appUser = AppUser(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );
      await firebaseFirestore
          .collection("users")
          .doc(appUser.uid)
          .set(appUser.toJson());
      return appUser;
    } catch (e) {
      throw Exception("Registration Failed: ${e.toString()}");
    }
  }
}
