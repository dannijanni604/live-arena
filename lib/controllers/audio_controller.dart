import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_arena/api/agora_api.dart';

class AudioController extends GetxController {
  // Scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxInt bottomNavIndex = 0.obs;
  RxBool fullScreenVideoView = false.obs;

  int get getBottomNavIndex => bottomNavIndex.value;
  bool get getFullScreenVideoView => fullScreenVideoView.value;
  final RxList<int> _joindUIds = RxList<int>([]);
  List<int> get joinedUsersIds => _joindUIds;
  // Video Calling Agora
  RtcEngine? _engine;
  // final String agorAppId = 'd6bad162b93145d0b2bdcf01ff8d2566';
  final String agorAppId = 'cbac4a74226f4019a2f38bc58aa07f4e';
  RtcEngine get engine => _engine!;
  RxBool speakerOn = true.obs;

  @override
  void onInit() {
    ever(bottomNavIndex, (int i) {
      if (i == 3) {
        fullScreenVideoView(!getFullScreenVideoView);
      }
    });
    ever(speakerOn, (bool v) {
      _engine!.enableLocalAudio(v);
    });
    super.onInit();
  }

  @override
  void onReady() {
    print("_initAgoraRtcEngine");
    _initAgoraRtcEngine();
    super.onReady();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: agorAppId,
      // channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await _engine!.enableVideo();
    await _engine!
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    _engine!.registerEventHandler(_rtcEventHandler());
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.dimensions = const VideoDimensions(width: 854, height: 480);
    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!.startPreview();
    // await _engine!.startPreview();
  }

  RtcEngineEventHandler _rtcEventHandler() {
    return RtcEngineEventHandler(onJoinChannelSuccess: (
      channel,
      uid,
    ) {
      printInfo(info: 'joinChannelSuccess $channel $uid');
    }, onLeaveChannel: (RtcConnection connection, RtcStats state) {
      printInfo(info: 'leaveChannel ${state.duration}');
      printInfo(info: 'channelId ${connection.channelId}');
    }, onUserOffline: (uid, reason, userofLineReasonType) {
      printError(info: 'UserOffile $uid $reason $userofLineReasonType');
      _joindUIds.remove(uid);
    }, onUserJoined: (connnection, uid, elapsed) {
      printError(info: 'UserJoined $uid $elapsed ');
      _joindUIds.add(uid);
    });
  }

  Future<bool> joinCahnnel(String channel, ClientRoleType role) async {
    try {
      Map<String, dynamic> data = await AgoraApi().getToken(
        channel,
        role == ClientRoleType.clientRoleBroadcaster ? 1 : 0,
      );

      await _engine!.joinChannel(
          token: data['token'],
          channelId: channel,
          uid: data['uid'],
          options: const ChannelMediaOptions());

      // final token = data['token'];
      // print(" My token  $token");
      await _engine!.setClientRole(role: role);
      return true;
    } catch (e) {
      printError(info: "join Channel" + e.toString());
    }
    return false;
  }

  @override
  void onClose() {
    // Wakelock.disable();
    _engine?.leaveChannel();
    // _engine.d .destroy();
    super.onClose();
  }
}
