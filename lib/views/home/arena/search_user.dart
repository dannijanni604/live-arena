import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/create_arena_controller.dart';
import 'package:live_arena/models/app_user.dart';

class SearchUserViwe extends StatelessWidget {
  SearchUserViwe({Key? key}) : super(key: key);

  final controller = Get.find<CreateAreanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  TextFormField(
                    decoration: appInputDecoration(
                      'Search',
                      FontAwesomeIcons.search,
                    ),
                    onChanged: (t) => controller.searchBroadcaster(t),
                  ),
                  Obx(
                    () => controller.isSearching.isTrue
                        ? LinearProgressIndicator()
                        : SizedBox.shrink(),
                  )
                ],
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(12),
              child: Obx(
                () => controller.selectedBroadcasters.length == 0
                    ? Center(
                        child: Text('Selected Co-Hosts'),
                      )
                    : Row(
                        children: controller.selectedBroadcasters
                            .map((element) => Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            maxRadius: 25,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              element.avatar!,
                                            ),
                                          ),
                                          Text(
                                            '@' + element.username!,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.selectedBroadcasters
                                              .remove(element);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
              ),
            ),
            Expanded(
              child: Obx(
                () => controller.searchBroadcasterUsers.length == 0
                    ? const Center(
                        child: Text('Search Co-Hosts using username'),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              controller.searchBroadcasterUsers[index].avatar!,
                            ),
                          ),
                          title: Text(
                              controller.searchBroadcasterUsers[index].name!),
                          subtitle: Text('@' +
                              controller
                                  .searchBroadcasterUsers[index].username!),
                          onTap: () {
                            AppUser user =
                                controller.searchBroadcasterUsers[index];
                            int _index = controller.selectedBroadcasters
                                .indexWhere((e) => e.id == user.id);
                            if (_index < 0 &&
                                controller.selectedBroadcasters.length < 4) {
                              controller.selectedBroadcasters.add(
                                  controller.searchBroadcasterUsers[index]);
                            }
                          },
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: controller.searchBroadcasterUsers.length,
                      ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              color: AppTheme.primaryColor,
              onPressed: () => Get.back(),
              text: 'Select',
            )
          ],
        ),
      ),
    );
  }
}
