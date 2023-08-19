import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/auth_controller.dart';

class CreateAccountController extends GetxController {
  RxList<String> selectedSports = RxList([]);
  RxList<String> selectedLanguages = RxList([]);

  String get selectedSportsMessage =>
      'Sports (${selectedSports.length} selected)';

  String get selectedLanguagesMessage =>
      'Languages (${selectedLanguages.length} selected)';

  Future createProfile(Map<String, dynamic> data, File image) async {
    try {
      EasyLoading.show(status: 'Creating Profile');
      String id = FirebaseAuth.instance.currentUser!.uid;
      String? avatar = await uploadFile(image);
      await dbUser.doc(id).set({
        'id': id,
        'avatar': avatar,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'sports': selectedSports,
        'languages': selectedLanguages,
        'following': [],
        'followers': [],
        'rating': 0.0,
        'type': 'user',
        'name': data['name'],
        'about': data['about'],
        'username': data['username'],
        'search_terms': getSearchTerms(data['name']),
        'search_username_terms': getSearchTerms(data['username']),
        'hosted_arena': 0,
        'joined_arena': 0
      });
      AuthController.to.onChangeAuthtication(true);
    } catch (e) {
      kErrorSnakBar('$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Find UserId
  RxBool isFindingId = false.obs;
  RxBool isUserNameExists = false.obs;
  Timer? timeHandle;

  Future findId(String id) async {
    if (timeHandle != null) {
      timeHandle?.cancel();
    }
    timeHandle = Timer(Duration(seconds: 1), () async {
      isFindingId(true);
      isUserNameExists(false);
      QuerySnapshot<Map> doc =
          await dbUser.where('username', isEqualTo: id).get();
      if (doc.docs.length > 0) {
        isUserNameExists(true);
      } else {
        isUserNameExists(false);
      }
      isFindingId(false);
    });
  }

  Rx<File> fileImage = Rx<File>(File(''));
  Future<File?> picFileImage(
    ImageSource source, {
    int quality = 50,
    double height = 200,
    double width = 500,
  }) async {
    XFile? image = await ImagePicker().pickImage(
      source: source,
      imageQuality: quality,
      maxHeight: height,
      maxWidth: width,
    );
    if (image!.path.isNotEmpty) {
      return File(image.path);
    } else {
      return null;
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      String _name = DateTime.now().microsecondsSinceEpoch.toString() +
          "." +
          file.path.split('.').last;
      Reference ref =
          FirebaseStorage.instance.ref().child('images').child(_name);
      // Reference ref = FirebaseStorage.instance.ref().child(_name);
      UploadTask task = ref.putFile(File(file.path));
      await task.whenComplete(() => null);
      return await ref.getDownloadURL();
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
    return null;
  }
}
