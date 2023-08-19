import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_arena/controllers/clips_controller.dart';
import 'package:video_player/video_player.dart';

class VideoCliptab extends StatefulWidget {
  const VideoCliptab({Key? key}) : super(key: key);

  @override
  State<VideoCliptab> createState() => _VideoCliptabState();
}

class _VideoCliptabState extends State<VideoCliptab> {
  ClipController controller = Get.put(ClipController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sports Videos Collection"),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: controller.videoUrl
            .map((url) => VideoPlayersList(videos: url))
            .toList(),
      ),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: () async {
            controller.indicator(true);
            await controller.getAndUploadVideo();
            controller.indicator(false);
          },
          child: controller.indicator.value
              ? const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.upload_outlined,
                ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

// ListView.builder(
//           itemCount: controller.videoUrl.length,
//           itemBuilder: (context, index) {
//             if (controller.videoUrl.isNotEmpty) {
//               return VideoPlayersList(
//                 videos: controller.videoUrl[index],
//               );
//             }
//             return const Center(
//               child: Text("No Videos"),
//             );
//           })
class VideoPlayersList extends StatefulWidget {
  const VideoPlayersList({
    Key? key,
    required this.videos,
  }) : super(key: key);

  final String videos;

  @override
  State<VideoPlayersList> createState() => _VideoPlayersListState();
}

class _VideoPlayersListState extends State<VideoPlayersList> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videos);
    videoPlayerController.initialize().then((value) {
      chewieController = ChewieController(
        allowMuting: true,
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        isLive: false,
        autoPlay: false,
        looping: false,
      );
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoaded
            ? Chewie(
                controller: chewieController,
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
