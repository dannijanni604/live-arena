import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:live_arena/api/agora_api.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/audio_controller.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/models/arena.dart';

class LiveArenaController extends GetxController with StateMixin {
  Rx<Arena> arena = Rx<Arena>(Arena());
  AudioController audioController = Get.find();
  String authId = AuthController.to.appUser.value.id!;
  ClientRoleType _role = ClientRoleType.clientRoleAudience;

  final TextEditingController messageTextController = TextEditingController();

  late RtcEngine engine;
  RxSet<int> userIds = RxSet<int>({});
  String appId = 'cbac4a74226f4019a2f38bc58aa07f4e';

  RxBool speakerOn = true.obs;

  @override
  void onInit() {
    ever(speakerOn, (bool v) {
      if (v) {
        engine.enableAudio();
      } else {
        engine.disableAudio();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    engine = audioController.engine;
    super.onReady();
  }

  Future changeCamera() async {
    await engine.switchCamera();
  }

  Future<bool> startAgora(String channel, ClientRoleType role) async {
    // engine = createAgoraRtcEngine();
    engine.initialize(RtcEngineContext(appId: appId));

    await engine.enableVideo();
    await engine.enableAudio();
    if (role == ClientRoleType.clientRoleBroadcaster) {
      await engine.startPreview();
    }
    await engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await engine.setClientRole(role: role);
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          printError(info: "live: Error $err");
        },
        onJoinChannelSuccess: (channel, uid) {
          printInfo(info: "live: joinChannelSuccess " + userIds.toString());
          change(null, status: RxStatus.success());
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          userIds.add(remoteUid);
          printInfo(info: "live: Joined " + userIds.toString());
          change(null, status: RxStatus.success());
        },
      ),
    );

    Map<String, dynamic> response = await AgoraApi().getToken2(
        channel, role == ClientRoleType.clientRoleBroadcaster ? 0 : 1);
    await engine.joinChannel(
        token: response['token'],
        channelId: channel,
        options: ChannelMediaOptions(),
        uid: response['uid']);
    return true;
  }

  Future start(String channel, ClientRoleType role, Arena _arena) async {
    printError(info: "live: $channel $role ${_arena.id}");
    try {
      DocumentSnapshot<Map<String, dynamic>> d =
          await dbArena.doc(_arena.id).get();
      arena(Arena.fromJson(d));
      _role = role;
      // bool isConnect = await audioController.joinCahnnel(channel, role);
      bool isConnect = await startAgora(channel, role);
      if (isConnect) {
        arena.bindStream(
          d.reference.snapshots().map(
                (event) => Arena.fromJson(event),
              ),
        );
        change(arena, status: RxStatus.success());
        if (role == ClientRoleType.clientRoleAudience) {
          d.reference.update({
            'listeners': FieldValue.arrayUnion([authId])
          });
        } else {
          d.reference.update({
            'broadcasters_live': FieldValue.arrayUnion([authId])
          });
        }
      } else {
        change(arena, status: RxStatus.error('Something wen wrong'));
      }
    } catch (e) {
      log(" throw is" + e.toString());
      change(arena, status: RxStatus.error(e.toString()));
    }
  }

  Future sendMesssage() async {
    try {
      if (messageTextController.text.isEmpty) {
        return;
      }
      await dbArena.doc(arena.value.id).collection('messages').doc().set({
        'message': messageTextController.text,
        'user': AuthController.to.appUser.value.toRelationJson(),
        'created_at': FieldValue.serverTimestamp(),
      });
      messageTextController.text = '';
    } catch (e) {
      kErrorSnakBar('$e');
    }
  }

  @override
  void onClose() async {
    if (_role == ClientRoleType.clientRoleAudience) {
      await dbArena.doc(arena.value.id).update({
        'listeners': FieldValue.arrayRemove([authId])
      });
    } else {
      await dbArena.doc(arena.value.id).update({
        'broadcasters_live': FieldValue.arrayRemove([authId])
      });
    }
    arena.close();
    await audioController.engine.leaveChannel();
    super.onClose();
  }
}
