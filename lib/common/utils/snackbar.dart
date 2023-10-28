import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController getErrorSnackbar({required String title}) =>
    Get.showSnackbar(GetSnackBar(
      title: title,
      backgroundColor: Colors.red,
    ));
