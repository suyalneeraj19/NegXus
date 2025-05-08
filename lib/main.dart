import 'package:NegXus/Pages/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 Required for GetMaterialApp

import 'package:NegXus/Config/Theme.dart';
import 'package:NegXus/Pages/Welcome/WelcomePage.dart';
import 'Config/PagePath.dart';

void main() {
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
      getPages: getPath, // 👈 This connects your defined routes
      home: HomePage(),
    );
  }
}
