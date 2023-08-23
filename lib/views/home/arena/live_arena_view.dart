import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as localView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:live_arena/components/arena_status_btn.dart';
import 'package:live_arena/components/favourites_icon.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/audio_controller.dart';
import 'package:live_arena/controllers/live_arena_controller.dart';
import 'package:live_arena/models/arena.dart';
import 'package:live_arena/views/users_view/users_list_view.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class LiveArenaView extends StatefulWidget {
  const LiveArenaView({Key? key, required this.arena, required this.role})
      : super(key: key);
  final Arena arena;
  final ClientRoleType role;

  @override
  _LiveArenaViewState createState() => _LiveArenaViewState();
}

class _LiveArenaViewState extends State<LiveArenaView> {
  bool volume = true;
  final audioController = Get.find<AudioController>();
  final controller = Get.put(LiveArenaController());

  @override
  void initState() {
    super.initState();
    controller.start(widget.arena.id!, widget.role, widget.arena);
  }

  Widget buildVideo() {
    switch (controller.userIds.length) {
      case 1:
      // return remoteView.SurfaceView(
      //   channelId: widget.arena.id!,
      //   uid: controller.userIds.toList()[0],
      // );
      case 2:
        return Row(
          children: [
            // Expanded(
            // child: remoteView.SurfaceView(
            //   channelId: widget.arena.id!,
            //   uid: controller.userIds.toList()[0],
            // ),
            // ),
            // Expanded(
            //   child: remoteView.SurfaceView(
            //     channelId: widget.arena.id!,
            //     uid: controller.userIds.toList()[1],
            //   ),
            // )
          ],
        );
      case 3:
        return Row(
          children: [
            // Expanded(
            //   child: remoteView.SurfaceView(
            //     channelId: widget.arena.id!,
            //     uid: controller.userIds.toList()[0],
            //   ),
            // ),
            // Expanded(
            //   child: remoteView.SurfaceView(
            //     channelId: widget.arena.id!,
            //     uid: controller.userIds.toList()[1],
            //   ),
            // ),
            // Expanded(
            //   child: remoteView.SurfaceView(
            //     channelId: widget.arena.id!,
            //     uid: controller.userIds.toList()[2],
            //   ),
            // )
          ],
        );
      default:
        return const Center(
          child: Text("Host Status Offline"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: controller.obx(
        (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: double.infinity,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  if (widget.role == ClientRoleType.clientRoleBroadcaster)
                    // const localView.SurfaceView(),
                    if (widget.role == ClientRoleType.clientRoleAudience)
                      buildVideo(),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    // decoration: const BoxDecoration(color: Colors.black38),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const FavouritesIcon(),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Obx(
                            () => Row(
                              children: [
                                ArenaStausButton(
                                  iconColor: Colors.white,
                                  color: controller.arena.value
                                          .broadcastersLive!.isNotEmpty
                                      ? Colors.red
                                      : Colors.grey,
                                  title: "LIVE",
                                  titleColor: Colors.white,
                                  icon: Icons.circle,
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    if (controller
                                        .arena.value.listners!.isNotEmpty) {
                                      Get.to(
                                        () => UsersListView(
                                          ids: controller.arena.value.listners!,
                                          title: 'Listensers',
                                        ),
                                      );
                                    }
                                  },
                                  child: ArenaStausButton(
                                    iconColor: Colors.black,
                                    color: Colors.white.withOpacity(0.5),
                                    title: controller
                                        .arena.value.listners!.length
                                        .toString(),
                                    titleColor: Colors.black,
                                    icon: Icons.visibility,
                                  ),
                                ),
                                const Spacer(),
                                if (widget.role ==
                                    ClientRoleType.clientRoleBroadcaster)
                                  cameraButton(),
                                volumeButton(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // middle section of live arena screen
            MiddleSectionOfLiveArenaScreen(
              widget: widget,
              controller: controller,
            ),
            //commet box section
            Expanded(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: dbArena
                          .doc(widget.arena.id)
                          .collection('messages')
                          .orderBy('created_at', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'Chat',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      snapshot.data!.docs[index].data()['user']
                                              ['avatar'] ??
                                          "",
                                    ),
                                  ),
                                  title: Text(
                                    '${snapshot.data!.docs[index].data()['user']['name']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Bubble(
                                    margin: BubbleEdges.only(bottom: 5),
                                    nip: BubbleNip.leftTop,
                                    color: AppTheme.primaryColor,
                                    child: Text(
                                      '${snapshot.data!.docs[index].data()['message']}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  // trailing: DateTime.tryParse(snapshot
                                  //     .data!.docs[index]
                                  //     .data()['created_at']),
                                ),
                              ),
                            ],
                          ),
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
        onError: (error) => Center(
          child: Text(error.toString()),
        ),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.messageTextController,
                  decoration: appInputDecoration(
                    'Type Here',
                    Icons.message,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.sendMesssage,
                icon: const Icon(Icons.send_sharp),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding volumeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
      child: CircleAvatar(
        backgroundColor: AppTheme.primaryColor,
        child: IconButton(
          onPressed: () {
            controller.speakerOn.toggle();
          },
          icon: Obx(
            () => controller.speakerOn()
                ? const Icon(Icons.volume_up, color: Colors.black)
                : const Icon(Icons.volume_off, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Padding cameraButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
      child: CircleAvatar(
        backgroundColor: AppTheme.primaryColor,
        child: IconButton(
          onPressed: () {
            controller.engine.switchCamera();
          },
          icon: Icon(Icons.camera, color: Colors.black),
        ),
      ),
    );
  }
}

class MiddleSectionOfLiveArenaScreen extends StatelessWidget {
  const MiddleSectionOfLiveArenaScreen({
    Key? key,
    required this.widget,
    required this.controller,
  }) : super(key: key);

  final LiveArenaView widget;

  final LiveArenaController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.arena.title!,
                style: txt20b,
              ),
              RoundedButton(
                onPressed: () {},
                text: "Follow",
                fontSize: 15,
                color: Colors.green,
                isCircle: false,
              ),
            ],
          ),
          // const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
            child: Row(
              children: [
                ...controller.arena.value.broadcastersAvatar!.reversed.map((e) {
                  return GestureDetector(
                    onTap: (() {
                      Get.to(() => UsersListView(
                          ids: controller.arena.value.broadcasters!,
                          title: "BroadCaster"));
                    }),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(e.toString()),
                    ),
                  );
                }),
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () => Get.to(
          //     () => UsersListView(
          //       ids: controller.arena.value.broadcasters!,
          //       title: 'Broadcasters',
          //     ),
          //   ),
          //   child: Row(
          //     children: controller.arena.value.broadcastersAvatar!.reversed
          //         .map((e) => Container(
          //               padding: EdgeInsets.all(10),
          //               height: 100,
          //               width: double.infinity,
          //               margin: EdgeInsets.only(
          //                 left: controller.arena.value.broadcastersAvatar!
          //                         .indexOf(e) *
          //                     25,
          //               ),
          //               child: CircleAvatar(
          //                 backgroundImage: CachedNetworkImageProvider(e),
          //               ),
          //             ))
          //         .toList(),
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     CircleAvatar(
          //       radius: 22,
          //       backgroundColor: Colors.black,
          //       child: CircleAvatar(
          //         backgroundImage: CachedNetworkImageProvider(
          //           widget.arena.user!.avatar!,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 15),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.all(10),
          //       decoration: const BoxDecoration(
          //         color: Colors.black,
          //         shape: BoxShape.circle,
          //       ),
          //       child: const Icon(
          //         Icons.chat_outlined,
          //         size: 20,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
