import 'package:flutter/material.dart';
import 'package:we_chat/common/services/auth/firebase_authentication.dart';
import 'package:we_chat/common/services/firestore/firestore_service.dart';
import 'package:we_chat/pages/auth/model.dart';
import 'package:get/get.dart';
import 'package:we_chat/pages/profile/index.dart';
import 'package:we_chat/pages/profile/widget/profile_photo.dart';

import '../../common/utils/toast.dart';

class ProfilePage extends GetView<ProfileController> {
  ProfilePage({super.key});

  final UserData userData = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      // for hiding keyboard when user click on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(' Profile'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.orangeAccent.shade100,
          onPressed: () async {
            await FirebaseAuthenticationService().signOut();
          },
          icon: const Icon(Icons.logout, color: Colors.grey),
          label: const Text(
            'Logout',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        body: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Spacer(),
                // for profile photo
                ProfilePhoto(userData: userData, size: size),
                SizedBox(height: size.height * 0.01),
                Text(userData.email),
                SizedBox(height: size.height * 0.05),
                //  for user name
                TextFormField(
                  initialValue: userData.name,
                  // controller: controller.nameController,
                  onSaved: (val) => userData.name = val ?? '',
                  decoration: InputDecoration(
                      hintText: userData.name,
                      label: const Text('Name'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),

                SizedBox(height: size.height * 0.02),
                //  for about
                TextFormField(
                  initialValue: userData.about.toString(),
                  // controller: controller.aboutController,
                  onSaved: (val) => userData.about = val ?? 'Unknown',
                  decoration: InputDecoration(
                      hintText: userData.about,
                      label: const Text('About'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),

                SizedBox(height: size.height * 0.1),
                ElevatedButton.icon(
                    onPressed: () async {
                      if (controller.formKey.currentState!.validate()) {
                        controller.formKey.currentState!.save();
                        controller.uploadPhoto();
                        await FirestoreService.updataUsersData(userData).then(
                            (value) => Toaster().successToast('Updated data'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.5, size.height * 0.06),
                        backgroundColor: Colors.orangeAccent.shade100),
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(color: Colors.grey),
                    )),
                const Spacer(flex: 2)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
