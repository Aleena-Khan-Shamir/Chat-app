import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/common/services/firestore/firestore_service.dart';
import 'package:we_chat/pages/chat/model.dart';

import '../auth/model.dart';

class ChatController extends GetxController {
  // for storing all messages
  List<Message> list = [];
  final textController = TextEditingController();
  RxBool isUploading = false.obs;
  File? photo;
  final picker = ImagePicker();
  Future multipleImage(UserData user) async {
    // picking multiple image
    final List<XFile> images = await picker.pickMultiImage();

    // uploading & sending image one by one
    for (var i in images) {
      log('image path:${i.path}');
      isUploading.value = true;
      try {
        await FirestoreService.sendImageWithChat(user, File(i.path));
      } catch (e) {
        // Handle error here, if needed
        log('multiple image: $e');
      } finally {
        isUploading.value = false;
        update();
      }
    }
  }

  Future image(UserData user, ImageSource image) async {
    final pickedFile = await picker.pickImage(source: image);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      isUploading.value = true;
      await FirestoreService.sendImageWithChat(user, File(photo!.path));
      isUploading.value = false;
      update();
    } else {
      log('No image selected');
    }
  }
}
