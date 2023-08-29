import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/arena_status_btn.dart';
import 'package:live_arena/components/arena_tile.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/models/arena.dart';
import 'package:live_arena/models/arena_category_model.dart';
import 'package:live_arena/models/recomended_arena.dart';
import 'package:live_arena/views/explore_recomended_arena.dart';
import 'package:live_arena/views/home/tabs/arena_tab.dart';
import 'package:live_arena/views/home/tabs/search_tab.dart';
import 'package:live_arena/views/home/tabs/video_tab.dart';
import 'package:live_arena/views/listener/listener_screen.dart';

import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.snackbar('Information', 'Double tap to exit form app');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: IndexedStack(
            index: _bottomNavIndex,
            children: [
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi, ${AuthController.to.appUser.value.name}",
                                  style: txt20b.copyWith(
                                      color: Colors.green.shade900),
                                ),
                                Text(
                                  "@${AuthController.to.appUser.value.username}",
                                  style:
                                      TextStyle(color: Colors.green.shade900),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              maxRadius: 25,
                              backgroundImage: CachedNetworkImageProvider(
                                AuthController.to.appUser.value.avatar ?? "",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Live Arenas", style: txt20b),
                          ),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot<Arena>>(
                              stream: dbArena
                                  .withConverter<Arena>(
                                    fromFirestore: (snapshot, options) =>
                                        Arena.fromJson(snapshot),
                                    toFirestore: (value, options) =>
                                        value.toJson(),
                                  )
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                    child: Text('NO LIVE EVENT'),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ListView.separated(
                                    itemBuilder: (context, index) => ArenaTile(
                                      arena: snapshot.data!.docs[index].data(),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemCount: snapshot.data!.docs.length,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SearchTab(),
              const ArenaTab(),
              ProfileTab(),
              const VideoCliptab(),
            ],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const [
            FontAwesomeIcons.house,
            FontAwesomeIcons.magnifyingGlass,
            FontAwesomeIcons.circleNotch,
            FontAwesomeIcons.user,
            FontAwesomeIcons.circlePlay,
          ],
          gapLocation: GapLocation.none,
          activeIndex: _bottomNavIndex,
          notchSmoothness: NotchSmoothness.defaultEdge,
          onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
      ),
    );
  }

  int _bottomNavIndex = 0;

  Widget buildArenaCategory() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          ...ArenaCategory.arenaCategoryList
              .map(
                (catgory) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ArenaListenerScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: catgory.color.withOpacity(0.2),
                    ),
                    child: Text(
                      catgory.arenaTitle,
                      style: TextStyle(
                        color: catgory.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

Widget buildRecomendedArene(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    child: Row(
      children: [
        ...RecomendedArena.recomendedArenaList
            .map(
              (arena) => InkWell(
                onTap: () => Get.to(() => ExploreRecomendedArena(arena: arena)),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(5),
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 1),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 2,
                          spreadRadius: 2,
                        )
                      ]),
                  child: Row(
                    children: [
                      Container(
                        height: double.infinity,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              arena.imag,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            arena.streamTitle,
                            style: txt20b,
                          ),
                          Text(
                            "# " + arena.sportName,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ArenaStausButton(
                                titleColor: Colors.white,
                                icon: Icons.visibility,
                                iconColor: Colors.purple,
                                color: Colors.black.withOpacity(0.4),
                                title: arena.arenaViewer,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                arena.language,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ],
    ),
  );
}
