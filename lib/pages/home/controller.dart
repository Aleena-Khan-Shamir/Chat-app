import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/common/services/firestore/firestore_service.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final TextEditingController searchController = TextEditingController();
  RxBool isSearching = false.obs;
  RxString searchText = ''.obs;
  changeValue() {
    isSearching.value = !isSearching.value;
    update();
  }

  updateSearch(String value) {
    searchText.value = value;
    update();
  }

  void setStatus(bool status) {
    if (FirestoreService.auth.currentUser != null) {
      FirestoreService.updataActiveStatus(status);
    }
  }

  // Future getData() async {
  //   await FirestoreService.selfInfo();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus(true);
      log('online');
    } else {
      setStatus(false);
      log('offline');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    setStatus(false);
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    FirestoreService.getFirebaseMessagingToken();
    if (FirestoreService.auth.currentUser != null) {
      WidgetsBinding.instance.addObserver(this);
      setStatus(true);
    }
  }
}
