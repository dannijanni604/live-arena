import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/models/app_user.dart';
import 'package:live_arena/models/arena.dart';

class SearchAppController extends GetxController with StateMixin {
  RxList<Arena> arenas = RxList<Arena>([]);
  RxList<AppUser> users = RxList<AppUser>([]);

  RxList<Arena> arenass = RxList<Arena>([]);
  RxList<AppUser> userss = RxList<AppUser>([]);
  @override
  onReady() {
    super.onReady();
    change(users, status: RxStatus.empty());
  }

  Timer? timeHandle;
  Future search(String text) async {
    try {
      if (timeHandle != null) {
        timeHandle?.cancel();
      }
      timeHandle = Timer(const Duration(seconds: 1), () async {
        arenas.clear();
        users.clear();
        change(users, status: RxStatus.loading());
        QuerySnapshot<Map<String, dynamic>> doc = await dbUser
            .where('search_username_terms', arrayContains: text)
            .get();
        if (doc.docs.isNotEmpty) {
          for (var element in doc.docs) {
            users.add(AppUser.fromJson(element.data()));
          }
        }
        QuerySnapshot<Map<String, dynamic>> _arenCocs =
            await dbArena.where('search_terms', arrayContains: text).get();
        if (_arenCocs.docs.isNotEmpty) {
          _arenCocs.docs.forEach((element) {
            arenas.add(Arena.fromJson(element));
          });
        }
        change(users, status: RxStatus.success());
      });
    } catch (e) {
      change(users, status: RxStatus.error(e.toString()));
    }
  }
}
