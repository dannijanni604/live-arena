import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/views/authentication/signup.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2), () {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          Get.off(() => SignupScreen());
        } else {
          AuthController.to.onChangeAuthtication(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        "assets/images/arenalogo.png",
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 1.7,
      ),
    ));
  }
}
