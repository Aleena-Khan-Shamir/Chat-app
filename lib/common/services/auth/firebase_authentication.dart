import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/common/routes/app_routes.dart';

import '../db/local/shared_prefrences.dart';

class FirebaseAuthenticationService extends GetxService {
  static final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    try {
      final auth = await googleUser!.authentication;
      // Create new credentials
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      //  Once signed in, return the UserCredential
      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseException catch (e) {
      // getErrorSnackbar(title: 'Internet connection');
      log('googleSignIn: $e');
    }
  }

// #############################
// sign out
  Future<void> signOut() async {
    await LocalStorage.removeUserInfo();

    // await FirestoreService.updataActiveStatus(false);
    await firebaseAuth.signOut().then((value) {
      // this line of code for relogin
      // FirestoreService.auth = FirebaseAuth.instance;
      Get.offAndToNamed(Routes.login);
    });
  }

  // ##############################
  // listen for auth changes
  static void listenForAuthChanges() {
    firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        log('user signed in!');
      } else {
        log('user signed out');
      }
    });
  }
}
