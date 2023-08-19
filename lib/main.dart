import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/views/splash/splash_view.dart';
import 'controllers/audio_controller.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: AppTheme.primaryColor,
        appBarTheme: const AppBarTheme(
          color: AppTheme.primaryColor,
        ),
        // bottomAppBarTheme: BottomAppBarTheme(
        //   color: Colors.black12,
        // ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(AudioController());
      }),
      home: const SplashView(),
      builder: EasyLoading.init(),
    );
  }
}

// request.time < timestamp.date(2022, 5, 18);



  // easy_loading: ^0.0.4
