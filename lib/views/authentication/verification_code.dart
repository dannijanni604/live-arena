import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/views/home/home.dart';
import 'package:otp_text_field/otp_field.dart';

class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen({
    Key? key,
    this.nubmer,
    this.auth,
    this.verifiId,
  }) : super(key: key);
  final String? nubmer;
  final FirebaseAuth? auth;
  final String? verifiId;

  @override
  _SmsVerificationScreenState createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  final controller = Get.find<AuthController>();
  OtpFieldController otpController = OtpFieldController();

  late Timer timer;
  int seconds = 120;
  bool isResendEnable = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), countDownTimer);
  }

  countDownTimer(Timer t) {
    seconds--;
    if (seconds <= 0) {
      timer.cancel();
      isResendEnable = true;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.verified_user,
                  size: 150,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Verification",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                Text(
                  "Enter 6 digit code that received on\n${widget.nubmer}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // OTPTextField(
                //     controller: otpController,
                //     length: 6,
                //     width: MediaQuery.of(context).size.width,
                //     textFieldAlignment: MainAxisAlignment.spaceAround,
                //     fieldWidth: 45,
                //     fieldStyle: FieldStyle.box,
                //     outlineBorderRadius: 15,
                //     style: const TextStyle(fontSize: 17),
                //     onChanged: (pin) {
                //       print("Changed: " + pin);
                //     },
                //     onCompleted: (pin) {
                //       print("Completed: " + pin);
                //     }),
                VerificationCode(
                  keyboardType: TextInputType.number,
                  length: 6,
                  onCompleted: (String value) {
                    controller.verifyMobileOTP(value, context);
                  },
                  onEditing: (bool value) {},
                  clearAll: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'clear all',
                      style: TextStyle(
                        fontSize: 14.0,
                        decoration: TextDecoration.underline,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't receive code $seconds",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    TextButton(
                      onPressed: isResendEnable
                          ? () {
                              Get.back();
                            }
                          : null,
                      child: const Text("Resend"),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                RoundedButton(
                  minimumWidth: 210,
                  minimumHeight: 48,
                  onPressed: () {
                    if (otpController.toString().isNotEmpty) {
                      EasyLoading.show(status: "Wait ...!");
                      try {
                        AuthCredential phoneAuthCred =
                            PhoneAuthProvider.credential(
                          verificationId: widget.verifiId!,
                          smsCode: otpController.toString(),
                        );
                        widget.auth!.signInWithCredential(phoneAuthCred);
                        EasyLoading.dismiss();
                        // Get.to(() => ProfileScreen());
                        // Get.to(() => const StackIndexScreen());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      } on FirebaseAuthException catch (e) {
                        kErrorSnakBar(e.toString());
                      }
                    } else {
                      kErrorSnakBar("Enter Otp Did You Recive");
                    }
                  },
                  color: AppTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                  child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
