import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/views/home/arena/create_arena.dart';
import 'package:live_arena/views/home/arena/find_screen.dart';

CollectionReference<Map<String, dynamic>> dbUser =
    FirebaseFirestore.instance.collection('users');
CollectionReference<Map<String, dynamic>> dbArena =
    FirebaseFirestore.instance.collection('arenas');

CollectionReference<Map<String, dynamic>> dbReviews =
    FirebaseFirestore.instance.collection('reviews');

CollectionReference<Map<String, dynamic>> dbUserReports =
    FirebaseFirestore.instance.collection('user_reported');
kErrorSnakBar(String? message, {String tile = 'Error!'}) {
  Get.snackbar(
    tile,
    "$message",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
  );
}

kSuccessSnakBar(String? message, {String tile = 'Success!'}) {
  Get.snackbar(
    '$tile',
    "$message",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
  );
}

InputDecoration appInputDecoration(String? hint, IconData icon) =>
    InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon),
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      hintText: hint,
    );

List<String> getSearchTerms(String string) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < string.length; i++) {
    temp = temp + string[i];
    caseSearchList.add(temp.toLowerCase());
  }
  return caseSearchList;
}

Widget imagePickerBottomSheet() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    height: 150,
    child: Column(
      children: [
        const Text(
          "Select Image",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
                onPressed: () {
                  Get.back(result: ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera")),
            TextButton.icon(
                onPressed: () {
                  Get.back(result: ImageSource.gallery);
                },
                icon: const Icon(FontAwesomeIcons.image),
                label: const Text("Gallery")),
          ],
        ),
      ],
    ),
  );
}

Widget buildCreateOrSearchArenaBtn(BuildContext context) {
  return Container(
    // color: Colors.purple.withOpacity(0.2),
    padding: const EdgeInsets.all(15),
    child: Row(
      children: [
        Expanded(
          child: RoundedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateArenaScreen()));
            },
            color: Colors.green,
            minimumHeight: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                // Icon(Icons.add),
                Text("Create Arena"),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: RoundedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FindScreen()));
            },
            color: Colors.green,
            minimumHeight: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Text("Find Arena")),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
