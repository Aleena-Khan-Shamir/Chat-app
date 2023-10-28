import 'package:get/get.dart';
import 'package:we_chat/pages/profile/index.dart';

class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
