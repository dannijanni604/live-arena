import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/arena_tile.dart';
import 'package:live_arena/views/users_view/user_profile_view.dart';
import 'package:live_arena/controllers/search_controller.dart';

class FindScreen extends StatelessWidget {
  // FindScreen({Key? key}) : super(key: key);
  final controller = Get.put(SearchAppController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.only(top: 5),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search',
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
              ),
              onChanged: (s) => controller.search(s.toLowerCase()),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            tabs: [
              Tab(
                // icon: Icon(FontAwesomeIcons.users),
                text: 'Users',
              ),
              Tab(
                // icon: Icon(FontAwesomeIcons.circle),
                text: 'Areans',
              ),
              Tab(
                // icon: Icon(FontAwesomeIcons.tv),
                text: 'TV',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            controller.obx(
              (state) {
                if (controller.users.length > 0) {
                  return ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                          controller.users[index].avatar!,
                        ),
                      ),
                      title: Text(controller.users[index].name!),
                      subtitle: Text(controller.users[index].username!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star),
                          Text(controller.users[index].rating!.toString())
                        ],
                      ),
                      onTap: () => Get.to(
                        () => UserProfileView(user: controller.users[index]),
                      ),
                    ),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: controller.users.length,
                  );
                }
                return const Center(
                  child: Text('No Users'),
                );
              },
              onEmpty: const Center(
                child: Text('Search by typing'),
              ),
            ),
            controller.obx(
              (state) {
                if (controller.arenas.length > 0) {
                  return ListView.separated(
                    itemBuilder: (context, index) => ArenaTile(
                      arena: controller.arenas[index],
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: controller.arenas.length,
                  );
                }

                return const Center(
                  child: Text('No Arenas'),
                );
              },
              onEmpty: const Center(
                child: Text('Search by typing'),
              ),
            ),
            Container(
              child: const Center(
                child: Text("Users Show Here"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
