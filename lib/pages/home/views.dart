import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:we_chat/common/services/firestore/firestore_service.dart';
import 'package:we_chat/pages/home/index.dart';
import 'package:we_chat/pages/home/widget/user_card.dart';
import 'package:we_chat/common/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../common/utils/toast.dart';
import '../auth/model.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          // when search and click on back it shows the current back screen
          if (controller.isSearching.value) {
            controller.changeValue();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Obx(() => controller.isSearching.value
                  ? TextField(
                      controller: controller.searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Name'),
                      onChanged: (value) {
                        controller.updateSearch(value);
                      },
                    )
                  : const Text(' Chats')),
              actions: [
                Obx(
                  () => TextButton(
                      onPressed: () {
                        controller.changeValue();
                      },
                      child: controller.isSearching.value
                          ? const Icon(Icons.clear_outlined)
                          : const Icon(Icons.search)),
                ),
                TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.profile,
                          arguments: FirestoreService.userData);
                    },
                    child: const Icon(Icons.person)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                String email = '';
                Get.dialog(Center(
                  child: Material(
                    child: Container(
                      width: size.width * 0.6,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 97, 96, 96),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 10),
                                Text('Add User')
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  maxLines: null,
                                  onChanged: (value) => email = value,
                                  decoration: InputDecoration(
                                      hintText: 'Email Id',
                                      contentPadding: EdgeInsets.zero,
                                      prefixIcon: const Icon(Icons.email,
                                          color: Colors.blue),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)))),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel')),
                                  const SizedBox(width: 5),
                                  TextButton(
                                      onPressed: () async {
                                        Get.back();
                                        if (email.isNotEmpty) {
                                          await FirestoreService.addChatUser(
                                                  email)
                                              .then((value) => Toaster()
                                                  .errorToast(
                                                      'User doesnot exists'));
                                        }
                                      },
                                      child: const Text('Add')),
                                ])
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
            body: GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return StreamBuilder(
                      stream: FirestoreService.getUsersIds(),
                      // get ids fro only known users
                      builder: (context, snapshot) {
                        
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                                child: CircularProgressIndicator());

                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            return StreamBuilder(
                                stream: FirestoreService.getAllUsers(snapshot
                                    .data!.docs
                                    .map((e) => e.id)
                                    .toList()),
                                // get only those users,who's id is provided
                                builder: (_, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final data = snapshot.data!.docs;
                                  final userData = data
                                      .map((e) =>
                                          UserData.fromFirestore(e.data()))
                                      .toList();
                                  final filterData = userData.where((user) =>
                                      user.name.toLowerCase().contains(
                                          controller.searchController.text
                                              .toLowerCase()));

                                  if (controller
                                      .searchController.text.isEmpty) {
                                    log(userData.length.toString());
                                    return ListView.builder(
                                      itemCount: userData.length,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      itemBuilder: (_, index) => UserCardWidget(
                                          userData: userData[index]),
                                    );
                                  } else if (filterData.isNotEmpty) {
                                    final filterList = filterData.toList();
                                    return ListView.builder(
                                      itemCount: filterList.length,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      itemBuilder: (_, index) => UserCardWidget(
                                          userData: filterList[index]),
                                    );
                                  }
                                  // Display a message when searching but no results found
                                  return const Center(
                                    child: Text('No result found'),
                                  );
                                });
                        }
                      });
                })),
      ),
    );
  }
}
