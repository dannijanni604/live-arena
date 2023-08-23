import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/create_account_controller.dart';
import 'package:live_arena/models/app_user.dart';
import 'package:live_arena/views/authentication/signup.dart';
import 'package:live_arena/views/authentication/verification_code.dart';
import 'package:live_arena/views/home/home.dart';
import 'package:live_arena/views/profile/profile_screen.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  CreateAccountController create = Get.put(CreateAccountController());

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<AppUser> appUser = AppUser().obs;

  String get selectedLanguagesMessage =>
      "${appUser.value.languages!.length} Languages selected";
  String get selectedSportsMessage =>
      "${appUser.value.sports!.length} Sports selected";

  Rx<File> image = Rx<File>(File(''));

  @override
  void onInit() {
    ever(image, (File s) => updateAvatar(s));
    super.onInit();
  }

  onChangeAuthtication(bool status) async {
    try {
      print(status);
      if (!status) {
        Get.offAll(() => SignupScreen());
      } else {
        User _user = _auth.currentUser!;
        if (_user.uid.isNotEmpty) {
          // user(_user);
          DocumentSnapshot<Map<String, dynamic>> d =
              await dbUser.doc(_user.uid).get();
          if (d.exists) {
            appUser(AppUser.fromJson(d.data()!));
            appUser.bindStream(streamFirestoreUser(d.reference));

            Get.offAll(() => const HomeScreen());
            String? token = await FirebaseMessaging.instance.getToken();
            await dbUser.doc(_user.uid).update(
              {'fcm_token': token},
            );
            // LocalNotificationService().init();
            // FirebaseMessaging.onMessage.listen((event) {
            //   // FCMService().processNotification(event.data);
            //   LocalNotificationService().showNotification(
            //     event.notification.title,
            //     event.notification.body,
            //     jsonEncode(event.data),
            //   );
            // });
            // FirebaseMessaging.onMessageOpenedApp.listen((event) {
            //   FCMService().processNotification(event.data);
            // });
          } else {
            Get.to(() => const ProfileScreen());
          }
        }
      }
    } catch (e) {
      kErrorSnakBar('$e');
      // signout();
    }
  }

  Stream<AppUser> streamFirestoreUser(
      DocumentReference<Map<String, dynamic>> ref) {
    return ref
        .snapshots()
        .map((snapshot) => AppUser.fromJson(snapshot.data()!));
  }

  // Future foregetPassword(String email) async {
  //   try {
  //     EasyLoading.show(status: 'Processing');
  //     await _auth.sendPasswordResetEmail(email: email);
  //     Get.back();
  //     kSuccessSnakBar('Reset password email sent');
  //   } catch (e) {
  //     kErrorSnakBar('$e');
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  RxString phone = ''.obs;
  RxString dialingCode = '+49'.obs;
  RxString countryTwoLetterName = 'DE'.obs;
  RxString countryName = 'Germany'.obs;
  RxString _verificationId = ''.obs;

  Future<void> sendVerificationCode(String phoneNum) async {
    phone(dialingCode.value + phoneNum);
    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOTPSent = (String? verId, int? forceCodeResend) {
      _verificationId(verId);
      EasyLoading.dismiss();
      Get.to(() => SmsVerificationScreen(nubmer: phone.value));
    };
    // EasyLoading.show(status: 'Sending SMS');
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: phone.value,
    //   verificationCompleted: (PhoneAuthCredential credential) {
    //     _auth.signInWithCredential(credential);
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     if (e.code == 'invalid-phone-number') {
    //       kErrorSnakBar("invalid-phone-number");
    //     }
    //     kErrorSnakBar("Verificaton Fail" + e.toString());
    //   },
    //   codeSent: (String verificationId, int? resendToken) {
    //     _verificationId(verificationId);
    //     EasyLoading.dismiss();
    //     Get.to(() => SmsVerificationScreen(nubmer: phone.value));
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {
    //     _verificationId(verificationId);
    //   },
    //   timeout: const Duration(seconds: 120),
    // );

    await _auth.verifyPhoneNumber(
      phoneNumber: phone.value,
      codeAutoRetrievalTimeout: (String verId) {
        _verificationId(verId);
      },
      codeSent: smsOTPSent,
      timeout: const Duration(
        seconds: 120,
      ),
      verificationCompleted: (AuthCredential phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
        onChangeAuthtication(true);
      },
      verificationFailed: (FirebaseAuthException exception) {
        kErrorSnakBar('Verification Faild: Try Again');
        print('${exception.message}');
        EasyLoading.dismiss();
      },
    );
  }

  Future<void> verifyMobileOTP(String otp, BuildContext context) async {
    try {
      EasyLoading.show(status: 'Verifying');
      final AuthCredential? credential = PhoneAuthProvider.credential(
        verificationId: _verificationId.value,
        smsCode: otp,
      );
      if (credential != null) {
        await _auth.signInWithCredential(credential);
        onChangeAuthtication(true);
      } else {
        kErrorSnakBar('Somthing not working');
      }
    } catch (e) {
      kErrorSnakBar('Error on verifiy : $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future signout() async {
    await _auth.signOut();
    onChangeAuthtication(false);
  }

  Future updateFireStoreUser(Map<String, dynamic> data) async {
    try {
      await dbUser.doc(appUser.value.id).update(
        {
          'updated_at': FieldValue.serverTimestamp(),
          ...data,
        },
      );
      kSuccessSnakBar('Profile updated successfully');
    } catch (e) {
      kErrorSnakBar('$e');
    }
  }

  Future updateAvatar(File file) async {
    try {
      EasyLoading.show(status: 'uploading');
      String? _image = await create.uploadFile(file);
      await dbUser.doc(appUser.value.id).update({'avatar': _image});
    } catch (e) {
      kErrorSnakBar('$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future updateImage() async {
    try {
      EasyLoading.show(status: 'Uploading Image');
      String? _image = await create.uploadFile(image.value);
      await dbUser.doc(appUser.value.id).update({
        'avatar': _image,
      });
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
