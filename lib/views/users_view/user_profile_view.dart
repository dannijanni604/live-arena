import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/config/functions.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/models/app_user.dart';
import 'package:live_arena/views/users_view/rate_user.dart';
import 'package:live_arena/views/users_view/report_user.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({Key? key, required this.user}) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: context.height * 0.15,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: AppTheme.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: user.avatar!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String authId =
                                    AuthController.to.appUser.value.id!;
                                QuerySnapshot _doc = await dbReviews
                                    .where('review_by', isEqualTo: authId)
                                    .where('reviewed_user', isEqualTo: user.id)
                                    .get();
                                if (_doc.docs.isEmpty) {
                                  Get.to(() => RateUserVew(user: user));
                                } else {
                                  kErrorSnakBar(
                                      'You have already submitted review');
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.white, size: 25),
                                  const SizedBox(width: 5),
                                  Text(
                                    user.rating!.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                            Obx(
                              () => OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  await followUnfollow(
                                    AuthController.to.appUser.value.id,
                                    user.id,
                                  );
                                },
                                child: Text(
                                  AuthController.to.appUser.value.following!
                                          .contains(user.id)
                                      ? 'Unfollow'
                                      : 'Follow',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text("Profile Information", style: txt20b),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FormBuilder(
                    initialValue: user.toJson(),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: appInputDecoration(
                            'Name',
                            FontAwesomeIcons.signature,
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'about',
                          decoration: appInputDecoration(
                            'About',
                            FontAwesomeIcons.info,
                          ),
                          maxLines: null,
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'sprts',
                          decoration: appInputDecoration(
                            user.sports.toString(),
                            FontAwesomeIcons.futbol,
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'lngs',
                          decoration: appInputDecoration(
                            user.languages.toString(),
                            FontAwesomeIcons.language,
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'country_name',
                          decoration: appInputDecoration(
                            'Country',
                            FontAwesomeIcons.flag,
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'joined',
                          decoration: appInputDecoration(
                            'Joind Arenas (${user.joinedArena})',
                            FontAwesomeIcons.futbol,
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'hosted',
                          decoration: appInputDecoration(
                            'Hosted Arenas (${user.hostedArena})',
                            FontAwesomeIcons.futbol,
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        RoundedButton(
                          onPressed: () async {
                            String authId = AuthController.to.appUser.value.id!;
                            QuerySnapshot _doc = await dbUserReports
                                .where('report_by', isEqualTo: authId)
                                .where('reported_user', isEqualTo: user.id)
                                .get();
                            if (_doc.docs.isEmpty) {
                              Get.to(() => ReportUserView(user: user));
                            } else {
                              kErrorSnakBar(
                                'You have already report this user',
                              );
                            }
                          },
                          text: 'Report User',
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
