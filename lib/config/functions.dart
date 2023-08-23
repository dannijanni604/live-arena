import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/models/app_user.dart';

Future followUnfollow(String? authId, String? userId) async {
  FirebaseFirestore.instance.runTransaction((trans) async {
    // Author
    DocumentReference<Map<String, dynamic>> authDocRef = dbUser.doc(authId);
    DocumentSnapshot<Map<String, dynamic>> authDoc =
        await trans.get(authDocRef);
    AppUser authUser = AppUser.fromJson(authDoc.data()!);

    // User
    DocumentReference<Map<String, dynamic>> userDocRef = dbUser.doc(userId);
    if (authUser.following!.contains(userId)) {
      trans.update(authDocRef, {
        'following': FieldValue.arrayRemove([userId])
      });
      trans.update(userDocRef, {
        'followers': FieldValue.arrayRemove([authId])
      });
    } else {
      trans.update(authDocRef, {
        'following': FieldValue.arrayUnion([userId])
      });
      trans.update(userDocRef, {
        'followers': FieldValue.arrayUnion([authId])
      });
    }
  });
}

Widget selectRoleBottomSheet() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    height: 150,
    child: Column(
      children: [
        Text(
          "Select Role",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                Get.back(result: ClientRoleType.clientRoleAudience);
              },
              icon: Icon(FontAwesomeIcons.broadcastTower),
              label: Text("Reporter"),
            ),
            TextButton.icon(
              onPressed: () {
                Get.back(result: ClientRoleType.clientRoleAudience);
              },
              icon: Icon(FontAwesomeIcons.headphones),
              label: Text("Listner"),
            ),
          ],
        ),
      ],
    ),
  );
}
