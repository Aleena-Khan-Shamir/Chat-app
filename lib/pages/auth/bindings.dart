import 'package:get/get.dart';
import 'package:we_chat/pages/auth/index.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
