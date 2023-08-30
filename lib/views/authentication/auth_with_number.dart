import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/views/home/home.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

enum Status { onPhoneNumberScreen, onOtpVerifyScreen }

class LoginWithNumberScreen extends StatefulWidget {
  const LoginWithNumberScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithNumberScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginWithNumberScreen> {
  @override
  TextEditingController phoneController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  CountryCode? code;

  String verifiId = "";
  Status currentState = Status.onPhoneNumberScreen;

  Widget build(BuildContext context) {
    return Scaffold(
      body: currentState == Status.onPhoneNumberScreen
          ? verifyNumberWidget(context, _formKey)
          : verifyOtpWidget(context),
    );
  }

  verifyNumberWidget(BuildContext context, GlobalKey<FormState> formKey) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: context.height * 0.25,
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Center(
            child: Text(
              "Register",
              style: TextStyle(
                color: Colors.green.shade800,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CountryCodePicker(
                initialSelection: 'DE',
                showCountryOnly: true,
                alignLeft: false,
                padding: const EdgeInsets.all(8),
                onChanged: (value) {
                  code = value;
                },
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const Spacer(),
        RoundedButton(
          text: "Next",
          child: const Icon(Icons.arrow_forward_ios_outlined),
          color: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              EasyLoading.show(status: "Wait...!");
              try {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+92${phoneController.text}',
                  verificationCompleted:
                      (PhoneAuthCredential credential) async {
                    await auth.signInWithCredential(credential);
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    printInfo(info: '+92${phoneController.text.trimLeft()}');
                    if (e.code == 'invalid-phone-number') {
                      EasyLoading.dismiss();
                      kErrorSnakBar("invalid-phone-number");
                    }
                  },
                  codeSent: (verificationId, resendToken) async {
                    verifiId = verificationId;
                    EasyLoading.dismiss();
                    log("message");
                    currentState = Status.onOtpVerifyScreen;
                    log("message2");
                    setState(() {});
                  },
                  timeout: const Duration(seconds: 120),
                  codeAutoRetrievalTimeout: (String verificationId) {
                    verifiId = verificationId;
                  },
                );
              } on FirebaseAuthException catch (e) {
                kErrorSnakBar(e.toString());
              }
            } else {
              kErrorSnakBar("Enter Phone Number");
            }
          },
        ),
      ],
    );
  }

  verifyOtpWidget(BuildContext context) {
    // AppController? controller = Get.put(AppController());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Text("Verify Otp Send At",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.deepOrange, fontSize: 30)),
          const SizedBox(height: 20),
          Text(FirebaseAuth.instance.currentUser!.phoneNumber!,
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 50),
          Center(
            child: OTPTextField(
                controller: otpController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 45,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 15,
                style: const TextStyle(fontSize: 17),
                onChanged: (pin) {
                  print("Changed: " + pin);
                },
                onCompleted: (pin) {
                  print("Completed: " + pin);
                }),
          ),
          const Spacer(),
          RoundedButton(
            text: "Verify",
            child: const Icon(Icons.arrow_forward_ios_outlined),
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
            onPressed: () {
              if (otpController.toString().isNotEmpty) {
                EasyLoading.show(status: "Wait ...!");
                try {
                  AuthCredential phoneAuthCred = PhoneAuthProvider.credential(
                    verificationId: verifiId,
                    smsCode: otpController.toString(),
                  );
                  auth.signInWithCredential(phoneAuthCred);

                  EasyLoading.dismiss();
                  Get.to(() => HomeScreen());
                  // Get.to(() => const StackIndexScreen());
                } on FirebaseAuthException catch (e) {
                  kErrorSnakBar(e.toString());
                }
              } else {
                kErrorSnakBar("Enter Otp Did You Recive");
              }
            },
          ),
        ],
      ),
    );
  }
}
