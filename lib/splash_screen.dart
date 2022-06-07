import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Get.offAllNamed(Routes.registration);
    });
    return Scaffold(
      body: SizedBox(
        height: Get.size.height,
        width: Get.size.width,
      ),
      // body: Image.asset(
      //   ImageAssets.splashScreen,
      //   height: Get.size.height,
      //   width: Get.size.width,
      //   fit: BoxFit.contain,
      // ),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
        ));
      }
    });
    super.initState();
  }
}
