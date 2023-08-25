import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/functions.dart';
import 'package:live_arena/controllers/audio_controller.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/controllers/live_arena_controller.dart';
import 'package:live_arena/models/arena.dart';
import 'package:live_arena/views/home/arena/live_arena_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'arena_status_btn.dart';
import 'text_styles.dart';

class ArenaTile extends StatelessWidget {
  ArenaTile({Key? key, required this.arena}) : super(key: key);

  final Arena arena;

  final liveArenaCtrl = Get.put(LiveArenaController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: arena.user!.avatar != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(arena.image ?? ""),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage("assets/images/sports.png"),
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArenaStausButton(
                  titleColor: Colors.black,
                  icon: Icons.circle,
                  iconColor: arena.live! ? Colors.black : Colors.black,
                  color: Colors.white.withOpacity(0.7),
                  title: "LIVE",
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Text(
                    'Started At ::${arena.startAt!.substring(10, 16).toString()}',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.primaryColor,
                border: Border.all(
                  width: 1,
                  color: AppTheme.primaryColor,
                ),
                image: arena.user!.avatar != null
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(
                            arena.user!.avatar ?? "assets/images/sports.png"),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage("assets/images/sports.png")),
              ),
            ),
            title: Text("${arena.title}", style: txt18b),
            subtitle: Text(
              arena.description!,
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                await Permission.camera.request();
                await Permission.microphone.request();
                ClientRoleType role = ClientRoleType.clientRoleAudience;
                String? authId = AuthController.to.appUser.value.id;
                if (arena.user!.id == authId) {
                  printInfo(info: 'same author of the arena');
                  role = ClientRoleType.clientRoleBroadcaster;
                } else {
                  if (arena.broadcasters!.contains(authId)) {
                    ClientRoleType? _selected = await Get.bottomSheet(
                      selectRoleBottomSheet(),
                      backgroundColor: Colors.white,
                    );
                    if (_selected == null) {
                      role = ClientRoleType.clientRoleAudience;
                    } else {
                      role = _selected;
                    }
                  }
                }
                log(arena.image.toString());
                log(arena.user!.avatar.toString());
                Get.to(() => LiveArenaView(
                      rtcEngile: liveArenaCtrl.engine,
                      arena: arena,
                      role: role,
                    ));
              },
              icon: const Icon(
                Icons.play_circle_fill,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
