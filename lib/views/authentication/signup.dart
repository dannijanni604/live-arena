import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/views/authentication/verification_code.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final controller = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  String? verifiId;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CountryCodePicker(
                            initialSelection: 'DE',
                            showCountryOnly: false,
                            alignLeft: false,
                            padding: const EdgeInsets.all(8),
                            textStyle: const TextStyle(fontSize: 20),
                            onChanged: (value) {
                              controller.dialingCode(value.dialCode);
                              controller.countryTwoLetterName(value.code);
                              controller.countryName(value.name);
                            },
                          ),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: TextFormField(
                                controller: _phoneNumberController,
                                autocorrect: false,
                                autofocus: false,
                                decoration: const InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                  border: InputBorder.none,
                                  errorStyle: TextStyle(height: 0, fontSize: 0),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter phone number';
                                  } else if (value.length < 7) {
                                    return 'Please enter valid phone number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (v) {},
                ),
                const Expanded(
                  child: Text(
                    'By entering your number, you\'re agreeing to out Terms or Services and Privacy Policy. Thanks!',
                    style: TextStyle(color: Colors.grey, height: 1.2),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundedButton(
                  onPressed: () async {
                    // FirebaseFirestore.instance.collection("Nabi").doc().set({
                    //   'Nabi': 'Nabi Is King',
                    // });
                    if (_formKey.currentState!.validate()) {
                      controller
                          .sendVerificationCode(_phoneNumberController.text);
                    } else {
                      kErrorSnakBar("Enter Number");
                    }
                    // EasyLoading.show(status: "Wait...!");
                    // try {
                    //   await FirebaseAuth.instance.verifyPhoneNumber(
                    //     phoneNumber:
                    //         '+92${_phoneNumberController.text.toString().trim()}',
                    //     verificationCompleted:
                    //         (PhoneAuthCredential credential) async {
                    //       await _auth.signInWithCredential(credential);
                    //     },
                    //     verificationFailed: (FirebaseAuthException e) {
                    //       if (e.code == 'invalid-phone-number') {
                    //         EasyLoading.dismiss();
                    //         kErrorSnakBar("invalid-phone-number");
                    //       }
                    //     },
                    //     codeSent: (verificationId, resendToken) async {
                    //       verifiId = verificationId;
                    //       EasyLoading.dismiss();
                    //       Get.to(() => SmsVerificationScreen(
                    //             nubmer: _phoneNumberController.text,
                    //             auth: _auth,
                    //             verifiId: verifiId,
                    //           ));

                    //       // currentState = Status.onOtpVerifyScreen; //
                    //       setState(() {});
                    //     },
                    //     timeout: const Duration(seconds: 120),
                    //     codeAutoRetrievalTimeout: (String verificationId) {
                    //       verifiId = verificationId;
                    //       Get.to(() => SmsVerificationScreen(
                    //           nubmer: _phoneNumberController.text));
                    //     },
                    //   );
                    // } on FirebaseAuthException catch (e) {
                    //   kErrorSnakBar(e.toString());
                    // }
                  },
                  text: "Next",
                  child: const Icon(Icons.arrow_forward_ios_outlined),
                  color: AppTheme.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
