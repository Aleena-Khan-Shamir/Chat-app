import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../common/services/firestore/firestore_service.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  File? photo;
  Future imageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      update();
    } else {
      log('No image selected');
    }
  }

  Future imageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      update();
    } else {
      log('No image selected');
    }
  }

  Future<void> uploadPhoto() async {
    await FirestoreService().uploadPhoto(photo!);
  }

  Future getData() async {
    await FirestoreService.selfInfo();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
