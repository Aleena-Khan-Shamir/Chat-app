import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/common/routes/app_routes.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}
