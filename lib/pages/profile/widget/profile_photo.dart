import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/model.dart';
import '../index.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required this.userData,
    required this.size,
  });

  final UserData userData;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          return Stack(
            alignment: Alignment.centerRight,
            children: [
              controller.photo != null
                  ?
                  // for local image
                  Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CircleAvatar(
                          radius: 50,
                          child: Image.file(
                            controller.photo!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )

                  // for server image
                  : Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            userData.photoUrl,
                          ),
                        ),
                      ),
                    ),
              Positioned(
                right: size.width * 0.2,
                bottom: 0,
                child: MaterialButton(
                    onPressed: () {
                      Get.bottomSheet(
                        SizedBox(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Pick profile photo',
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    await controller.imageFromGallery();
                                    Get.back();
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.browse_gallery),
                                      SizedBox(width: 20),
                                      Text(
                                        'Gallery',
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () async {
                                    await controller.imageFromCamera();
                                    Get.back();
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.camera),
                                      SizedBox(width: 20),
                                      Text(
                                        'Camera',
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: Colors.grey.shade800,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                    shape: const CircleBorder(),
                    color: Colors.grey,
                    child: const Icon(Icons.camera_alt_rounded)),
              )
            ],
          );
        });
  }
}
