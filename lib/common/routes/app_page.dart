import 'package:get/get.dart';
import 'package:we_chat/common/middleware/login_middleware.dart';
import 'package:we_chat/pages/auth/index.dart';
import 'package:we_chat/pages/profile/index.dart';

import '../../pages/chat/index.dart';
import '../../pages/home/index.dart';
import 'app_routes.dart';

class AppPage {
  static const initial = Routes.login;
  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBindings(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: Routes.home,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      binding: ProfileBindings(),
    ),
     GetPage(
      name: Routes.chat,
      page: () => ChatPage(),
      binding: ChatBindings(),
    ),
  ];
}
