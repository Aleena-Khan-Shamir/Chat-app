import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:we_chat/common/routes/app_page.dart';
import 'package:we_chat/common/services/db/local/shared_prefrences.dart';
import 'common/services/auth/firebase_authentication.dart';
import 'firebase_options.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  // for light status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandler);

  // create shared preferences object in memory
  LocalStorage.init();

  // add a listener to listen auth changes
  // and update the current state
  FirebaseAuthenticationService.listenForAuthChanges();

  runApp(const MyApp());
}

Future<void> firebaseMessageBackgroundHandler(message) async {
  print(" background message: ${message.notification!.name.toString()}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'We Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: AppPage.initial,
      getPages: AppPage.routes,
    );
  }
}

initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
}
