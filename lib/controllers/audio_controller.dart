import 'package:agora_rtc_engine/rtc_engine.dart';
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
  final String agorAppId = 'd6bad162b93145d0b2bdcf01ff8d2566';
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
    _initAgoraRtcEngine();
    super.onReady();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(agorAppId));
    await _engine!.enableVideo();
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    _engine!.setEventHandler(_rtcEventHandler());
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 854, height: 480);
    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!.startPreview();
    // await _engine!.startPreview();
  }

  RtcEngineEventHandler _rtcEventHandler() {
    return RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      printInfo(info: 'joinChannelSuccess $channel $uid $elapsed');
    }, leaveChannel: (RtcStats state) {
      printInfo(info: 'leaveChannel ${state.duration}');
    }, userOffline: (uid, reason) {
      printError(info: 'UserOffile $uid $reason');
      _joindUIds.remove(uid);
    }, userJoined: (uid, elapsed) {
      printError(info: 'UserJoined $uid $elapsed');
      _joindUIds.add(uid);
    });
  }

  Future<bool> joinCahnnel(String channel, ClientRole role) async {
    try {
      String data = await AgoraApi().getToken(
        channel,
        role == ClientRole.Broadcaster ? 1 : 0,
      );
      await _engine!.joinChannel(data, channel, null, 0, null);
      await _engine!.setClientRole(role);
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
    _engine?.destroy();
    super.onClose();
  }
}
