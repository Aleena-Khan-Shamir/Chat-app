import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/common/routes/app_routes.dart';
import 'package:we_chat/common/services/auth/firebase_authentication.dart';
import 'package:we_chat/common/services/firestore/firestore_service.dart';

import '../../common/services/db/local/shared_prefrences.dart';

class LoginController extends GetxController {
  RxBool isLogged = false.obs;
  Future<void> googlAuthentication() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    isLogged.value = true;
    await FirebaseAuthenticationService().signInWithGoogle();
// to store user profile data in firestore
    String displayName = googleUser!.displayName ?? googleUser.email;
    String email = googleUser.email;
    String id = FirebaseAuth.instance.currentUser!.uid;
    String photoUrl = googleUser.photoUrl ?? "";

    // to store data in local storage
    await LocalStorage.saveUserInfo(
      uid: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
    );
    await FirestoreService.addUsers().then((value) {
      log('user data  added');

      Get.offAndToNamed(Routes.home);
      isLogged.value = false;
    });
  }
}
