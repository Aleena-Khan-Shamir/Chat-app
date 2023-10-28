import 'package:get/get.dart';
import 'package:we_chat/pages/home/index.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
