import 'package:flutter/material.dart';
import 'package:we_chat/pages/auth/index.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});
// FBD85D
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   height: 100,
            //   width: 100,
            //   color: Colors.orangeAccent.shade100,
            // ),
            // Container(
            //   height: 100,
            //   width: 100,
            //   color: Colors.brown.shade900,
            // ),
            const Spacer(),
            const Text('Welcome to chat app'),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/icons/icon.png',
                height: 100,
                width: 100,
              ),
            ),
            const Spacer(),
            Obx(
              () => ElevatedButton(
                  onPressed: () => controller.googlAuthentication(),
                  child: controller.isLogged.value
                      ? const CircularProgressIndicator()
                      : const Text(
                          'SignIn with Google',
                          style: TextStyle(color: Colors.white),
                        )),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
