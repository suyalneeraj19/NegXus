import 'package:NegXus/Pages/Auth/AuthPage.dart';
import 'package:NegXus/Pages/HomePage/HomePage.dart';
import 'package:NegXus/Pages/ProfilePage/ProfilePage.dart';
import 'package:NegXus/Pages/SplashPage/SplashPage.dart';
import 'package:NegXus/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 Required for GetMaterialApp

import 'package:NegXus/Config/Theme.dart';
import 'package:NegXus/Pages/Welcome/WelcomePage.dart';
import 'Config/PagePath.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

// Create a Cloudinary instance and set your cloud name.
var cloudinary = Cloudinary.fromStringUrl("cloudinary://119574217634865:cGiIGQLtJiG8ycyVfLzr3thuYzk@dxvnxycz6");

void main() async {
  cloudinary.config.urlConfig.secure = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      getPages: getPath,
      home: WelcomePage(),
    );
  }
}
