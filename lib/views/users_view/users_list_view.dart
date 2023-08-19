import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/models/app_user.dart';
import 'package:live_arena/views/users_view/user_profile_view.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({Key? key, required this.ids, required this.title})
      : super(key: key);
  final List<String> ids;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<QuerySnapshot<AppUser>>(
        future: dbUser
            .where('id', whereIn: ids)
            .withConverter<AppUser>(
              fromFirestore: (snapshot, options) =>
                  AppUser.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            )
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    snapshot.data!.docs[index].data().avatar!),
              ),
              title: Text(snapshot.data!.docs[index].data().name!),
              subtitle: Text(snapshot.data!.docs[index].data().username!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star),
                  Text(snapshot.data!.docs[index].data().rating!.toString())
                ],
              ),
              onTap: () => Get.to(
                () => UserProfileView(user: snapshot.data!.docs[index].data()),
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
