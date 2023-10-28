import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/common/utils/my_date.dart';
import 'package:we_chat/pages/auth/model.dart';

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key, required this.user});
  final UserData user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
                radius: 70,
                backgroundImage: CachedNetworkImageProvider(
                  user.photoUrl,
                )),
            const SizedBox(height: 20),
            Text(user.email),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'About: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(user.about)
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Joined on: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(MyDateUtils.getLastMsgTime(
                    context: context, time: user.lastActive))
              ],
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}
