import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/config/data.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/controllers/create_account_controller.dart';
import 'package:live_arena/models/app_user.dart';
import 'package:live_arena/models/arena.dart';

class CreateAreanController extends GetxController {
  CreateAccountController controller = Get.put(CreateAccountController());
  RxString selectedSports = RxString(SportsData().allSports.first);
  RxList<String> selectedLanguages = RxList([]);

  RxList<AppUser> selectedBroadcasters = RxList<AppUser>([]);

  List<AppUser> get getSelectedBraodcasters =>
      selectedBroadcasters.reversed.toList();

  String get selectedLanguagesMessage =>
      'Languages (${selectedLanguages.length} selected)';

  Future createArena(Map<String, dynamic> data, File image) async {
    try {
      printInfo(info: "arena Go to Created");
      EasyLoading.show(status: 'Creating Arena');
      String? imageUrl = await controller.uploadFile(image);
      Arena arena = Arena(
        title: data['title'],
        description: data['description'],
        arean: data['arena'],
        broadcasters: selectedBroadcasters.map((e) => e.id!).toList(),
        broadcastersAvatar: selectedBroadcasters.map((e) => e.avatar!).toList(),
        broadcasterRef:
            selectedBroadcasters.map((e) => dbUser.doc(e.id)).toList(),
        languages: selectedLanguages,
        live: false,
        sport: selectedSports.value,
        user: AuthController.to.appUser.value,
        image: imageUrl,
        startAt: data['start_time'].toString(),
        searchTerms: getSearchTerms(data['title']),
      );
      printInfo(info: "Arena Set To Db");
      await dbArena.doc().set(arena.toJson());
      printInfo(info: "Update Storage");
      await AuthController.to.updateFireStoreUser(
        {'hosted_arena': FieldValue.increment(1)},
      );
      printInfo(info: "Update Storage Sucess");
      Get.back();
      kSuccessSnakBar('Arena Created');
    } catch (e) {
      kErrorSnakBar('$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Find UserId
  RxBool isSearching = false.obs;
  Timer? timeHandle;

  RxList<AppUser> searchBroadcasterUsers = RxList([]);

  Future searchBroadcaster(String text) async {
    if (timeHandle != null) {
      timeHandle?.cancel();
    }
    timeHandle = Timer(Duration(seconds: 1), () async {
      isSearching(true);
      searchBroadcasterUsers.clear();
      QuerySnapshot<Map<String, dynamic>> doc = await dbUser
          .where('search_username_terms', arrayContains: text)
          .get();
      if (doc.docs.length > 0) {
        doc.docs.forEach((element) {
          searchBroadcasterUsers.add(AppUser.fromJson(element.data()));
        });
      }
      isSearching(false);
    });
  }
}
