import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/services/firestore/firestore_service.dart';
import '../../../common/utils/my_date.dart';
import '../model.dart';

// for showing message details
class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return FirestoreService.user.uid == message.fromId
        ? yellowContainer(context)
        : brownContainer(context);
  }

  // sender or another user msg
  Widget brownContainer(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // update last read msg if sender and reciever are different
    if (message.read.isEmpty) {
      FirestoreService.updateMessageReadStatus(message);
      log('message read updated');
    }
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: message.type == Type.text
                ? EdgeInsets.symmetric(
                    horizontal: size.width * .04, vertical: size.width * .015)
                : EdgeInsets.symmetric(
                    horizontal: size.width * .02,
                    vertical: size.width * .01,
                  ),
            margin: message.type == Type.text
                ? EdgeInsets.symmetric(vertical: size.height * .01)
                : EdgeInsets.symmetric(vertical: size.height * .01),
            decoration: BoxDecoration(
                color: Colors.brown.shade400,
                borderRadius: message.type == Type.text
                    ? const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                message.type == Type.text
                    ? Text(
                        message.msg,
                        style: const TextStyle(color: Colors.black87),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: message.msg,
                          fit: BoxFit.cover,
                          height: 250,
                          width: 210,
                          placeholder: (_, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (_, url, error) =>
                              const Icon(Icons.image),
                        ),
                      ),
                Text(
                  MyDateUtils.getTimeFormate(
                      context: context, time: message.sent),
                  style: const TextStyle(color: Colors.black87, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// our message
  Widget yellowContainer(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // for message read
        if (message.read.isNotEmpty)
          Icon(
            Icons.done_all,
            size: 15,
            color: Colors.blue.shade500,
          ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: message.type == Type.text
                ? EdgeInsets.symmetric(
                    horizontal: size.width * .04, vertical: size.width * .015)
                : EdgeInsets.symmetric(
                    horizontal: size.width * .02,
                    vertical: size.width * .01,
                  ),
            margin: message.type == Type.text
                ? EdgeInsets.symmetric(vertical: size.height * .01)
                : EdgeInsets.symmetric(vertical: size.height * .01),
            decoration: BoxDecoration(
                color: Colors.orangeAccent.shade100,
                borderRadius: message.type == Type.text
                    ? const BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                message.type == Type.text
                    ? Text(
                        message.msg,
                        style: const TextStyle(color: Colors.black87),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: message.msg,
                          fit: BoxFit.cover,
                          height: 250,
                          width: 210,
                          placeholder: (_, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (_, url, error) =>
                              const Icon(Icons.image),
                        ),
                      ),
                Text(
                  MyDateUtils.getTimeFormate(
                      context: context, time: message.sent),
                  style: const TextStyle(color: Colors.black87, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
