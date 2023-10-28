import 'package:get/get.dart';
import 'package:we_chat/pages/chat/index.dart';

class ChatBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}
