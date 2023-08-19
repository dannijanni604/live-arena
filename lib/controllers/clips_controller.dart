import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ClipController extends GetxController {
  @override
  void onInit() {
    getvideosUrl();
    super.onInit();
  }

  List<dynamic> videoUrl = [];
  RxBool indicator = RxBool(false);
  XFile? file = XFile('');

  getvideosUrl() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('videos').get();
    videoUrl = snapshot.docs.map((doc) => doc.get('video_url')).toList();
    log(videoUrl.toString());
  }

  Future getAndUploadVideo() async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString());
      final String today = ('$month-$date');
      file = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("video")
          .child(today)
          .child(storageId);
      UploadTask uploadTask = ref.putFile(File(file!.path));
      await uploadTask.whenComplete(() => null);
      String downloadUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('videos').doc().set(
        {
          "video_url": downloadUrl,
          "upload_at": FieldValue.serverTimestamp(),
        },
      );
    } catch (error) {
      throw (error.toString());
    }
  }
}
