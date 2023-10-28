import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/pages/chat/index.dart';
import 'package:get/get.dart';
import 'package:we_chat/pages/chat/model.dart';
import 'package:we_chat/pages/chat/widget/chat_input.dart';
import 'package:we_chat/pages/chat/widget/msg_card.dart';
import 'package:we_chat/pages/chat/widget/view_profile.dart';
import '../../common/services/firestore/firestore_service.dart';
import '../../common/utils/my_date.dart';
import '../auth/model.dart';

class ChatPage extends GetView<ChatController> {
  ChatPage({super.key});

  final UserData userData = Get.arguments;
// FBD85D
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(userData),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: FirestoreService.getMessages(userData),
                    builder: (_, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data!.docs;
                          controller.list = data
                              .map((e) => Message.fromJson(e.data()))
                              .toList();
                          print(controller.list.length);

                          if (controller.list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: controller.list.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                itemBuilder: (_, index) => MessageCard(
                                    message: controller.list[index]));
                          }

                          return const Center(
                            child: Text('Say Hi! 👋'),
                          );
                      }
                    })),

            // progess indicator for showing uploading

            Obx(() {
              if (controller.isUploading.value) {
                return const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ));
              }
              return const SizedBox();
            }),

            // for text input field
            ChatInputWidget(chatUser: userData),
          ],
        ),
      ),
    );
  }

  AppBar appBar(UserData userData) {
    return AppBar(
        elevation: 0.3,
        title: InkWell(
          onTap: () {
            Get.to(ViewProfile(
              user: userData,
            ));
          },
          child: StreamBuilder(
              stream: FirestoreService.getUserInfo(userData),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;

                  if (data.isNotEmpty) {
                    final list = data
                        .map((e) => UserData.fromFirestore(e.data()))
                        .toList();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                        list.isNotEmpty ? list[0].photoUrl : userData.photoUrl,
                      )),
                      title: Text(
                        list.isNotEmpty ? list[0].name : userData.name,
                      ),
                      subtitle: Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'Online'
                                : MyDateUtils.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : MyDateUtils.getLastActiveTime(
                                context: context,
                                lastActive: userData.lastActive),
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                }
                return const SizedBox();
              }),
        ));
  }
}
