import 'package:NegXus/Config/String.dart';
import 'package:NegXus/Controller/CallController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Pages/SplashPage/SplashPage.dart';
import 'package:NegXus/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 Required for GetMaterialApp

import 'package:NegXus/Config/Theme.dart';
import 'package:NegXus/Pages/Welcome/WelcomePage.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'Config/PagePath.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

ProfileController profileController = Get.put(ProfileController());
final navigatorKey = GlobalKey<NavigatorState>();

// Create a Cloudinary instance and set your cloud name.

var cloudinary = Cloudinary.fromStringUrl("cloudinary://119574217634865:cGiIGQLtJiG8ycyVfLzr3thuYzk@dxvnxycz6");

void main() async {
  cloudinary.config.urlConfig.secure = true;
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // ✅ Register the CallController so it's active throughout the app
  const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initSettings = InitializationSettings(android: androidInitSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  Get.put(CallController());

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // If using plugins, initialize them here as well
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: ZegoCloudConfig.appId, // your App ID
    appSign: ZegoCloudConfig.appSign, // your App Sign
    userID: profileController.currentUser.value.id ?? '', // your current user's ID
    userName: profileController.currentUser.value.name ?? '', // your current user's name
    plugins: [ZegoUIKitSignalingPlugin()],
  );

  await ZegoUIKit().initLog();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NegXus',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      getPages: pagePath,
      home: Splashpage(),
    );
  }
}
