import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_financiero/ui/page/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const Home(),
    );
  }
}
