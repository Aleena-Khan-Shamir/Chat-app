import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/common/services/firestore/firestore_service.dart';
import 'package:we_chat/pages/chat/controller.dart';
import 'package:we_chat/pages/chat/model.dart';

import '../../auth/model.dart';

class ChatInputWidget extends GetView<ChatController> {
  const ChatInputWidget({
    required this.chatUser,
    super.key,
  });
  final UserData chatUser;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.brown.shade500,
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      hintText: 'Type something...',
                      border: InputBorder.none),
                )),
                const SizedBox(width: 5),
                InkWell(
                    onTap: () {
                      // picking multiple images from gallery
                      controller.multipleImage(chatUser);
                    },
                    child: const Icon(
                      Icons.image_outlined,
                      size: 22,
                    )),
                const SizedBox(width: 8),
                InkWell(
                    onTap: () {
                      controller.image(chatUser, ImageSource.camera);
                    },
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 22,
                    )),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        MaterialButton(
          color: Colors.brown.shade500,
          onPressed: () {
            if (controller.textController.text.isNotEmpty) {
              if (controller.list.isEmpty) {
                FirestoreService.sendFirstMessages(
                    chatUser, controller.textController.text, Type.text);
              } else {
                FirestoreService.sendMessages(
                    chatUser, controller.textController.text, Type.text);
              }
              controller.textController.text = '';
            }
          },
          minWidth: 0,
          padding:
              const EdgeInsets.only(right: 10, left: 15, top: 10, bottom: 10),
          shape: const CircleBorder(),
          child: Icon(
            Icons.send,
            color: Colors.orangeAccent.shade100,
          ),
        ),
      ],
    );
  }
}
