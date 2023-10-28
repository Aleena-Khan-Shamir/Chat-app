import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_chat/pages/auth/model.dart';
import 'package:get/get.dart';
import 'package:we_chat/pages/chat/widget/view_profile.dart';
import '../../../common/routes/app_routes.dart';

import '../../../common/services/firestore/firestore_service.dart';
import '../../../common/utils/my_date.dart';
import '../../chat/model.dart';

class UserCardWidget extends StatelessWidget {
  final UserData userData;
  UserCardWidget({super.key, required this.userData});
  Message? message;
// FBD85D
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: FirestoreService.getLastMessages(userData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;

            if (data.isNotEmpty) {
              final list = data.map((e) => Message.fromJson(e.data())).toList();
              message = list[0]; // Get the first (last) message

              return ListTile(
                onTap: () => Get.toNamed(Routes.chat, arguments: userData),
                leading: GestureDetector(
                  onTap: () {
                    userInfoDailog(size);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CircleAvatar(
                      child: CachedNetworkImage(
                        imageUrl: userData.photoUrl,
                        placeholder: (context, url) =>
                            const Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                title: Text(userData.name),
                subtitle: Text(
                  message != null
                      ? message!.type == Type.image
                          ? 'Photo'
                          : message!.msg
                      : userData
                          .about, // Use the null-aware operator to provide a default value
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                trailing: message == null
                    ? null
                    // the yellow circle container can only show reciever,sender recive time
                    : (message!.read.isEmpty &&
                            message!.fromId != FirestoreService.user.uid)
                        ? Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent.shade100,
                            ),
                          )
                        : Text(MyDateUtils.getLastMsgTime(
                            context: context, time: message!.sent)),
              );
            }
          }
        }

        // Return a placeholder or empty widget if there is no data
        return ListTile(
          onTap: () => Get.toNamed(Routes.chat, arguments: userData),
          leading: GestureDetector(
            onTap: () {
              userInfoDailog(size);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CircleAvatar(
                child: CachedNetworkImage(
                  imageUrl: userData.photoUrl,
                  placeholder: (context, url) =>
                      const Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                ),
              ),
            ),
          ),
          title: Text(userData.name),
          subtitle: Text(
            message != null
                ? message!.type == Type.image
                    ? 'Photo'
                    : message!.msg
                : userData
                    .about, // Use the null-aware operator to provide a default value
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade500),
          ),
          trailing: message == null
              ? null
              // the yellow circle container can only show reciever,sender recive time
              : (message!.read.isEmpty &&
                      message!.fromId != FirestoreService.user.uid)
                  ? Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orangeAccent.shade100,
                      ),
                    )
                  : Text(MyDateUtils.getLastMsgTime(
                      context: context, time: message!.sent)),
        );
      },
    );
  }

  void userInfoDailog(Size size) {
    Get.dialog(Center(
      child: Material(
        child: Container(
          width: size.width * 0.6,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 97, 96, 96),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userData.name),
                    GestureDetector(
                      onTap: () {
                        Get.to(ViewProfile(user: userData));
                      },
                      child: const Icon(
                        Icons.info,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 70,
                backgroundImage: CachedNetworkImageProvider(userData.photoUrl),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ));
  }
}
