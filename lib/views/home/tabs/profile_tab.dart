import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/controllers/create_account_controller.dart';
import 'package:live_arena/views/profile/components/laguages_selection_view.dart';
import 'package:live_arena/views/profile/components/sports_selection_view.dart';
import 'package:live_arena/views/users_view/users_list_view.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({Key? key}) : super(key: key);

  final controller = Get.find<AuthController>();
  final bcontroller = Get.find<CreateAccountController>();
  static final _profileFormkey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Obx(() {
                    return SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: controller.image.value.path.isEmpty
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          controller.appUser.value.avatar ?? "",
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      controller.image.value,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async {
                                ImageSource? source = await Get.bottomSheet(
                                  imagePickerBottomSheet(),
                                  backgroundColor: Colors.white,
                                );
                                if (source != null) {
                                  File? _image =
                                      await bcontroller.picFileImage(source);
                                  if (_image != null) {
                                    controller.image(_image);
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Signout',
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              AuthController.to.signout();
                            },
                            icon: Icon(Icons.exit_to_app, color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white),
                          SizedBox(width: 5),
                          Obx(
                            () => Text(
                              controller.appUser.value.rating!.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text("Profile Information", style: txt20b),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FormBuilder(
                key: _profileFormkey,
                initialValue: controller.appUser.value.toJson(),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: appInputDecoration(
                        'Name',
                        FontAwesomeIcons.signature,
                      ),
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(context),
                      //   FormBuilderValidators.minLength(context, 3),
                      // ]),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'about',
                      decoration: appInputDecoration(
                        'About',
                        FontAwesomeIcons.info,
                      ),
                      maxLines: null,
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(context),
                      //   FormBuilderValidators.minLength(context, 10),
                      // ]),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => FormBuilderTextField(
                        name: 'sprts',
                        decoration: appInputDecoration(
                          '${controller.selectedSportsMessage}',
                          FontAwesomeIcons.futbol,
                        ),
                        readOnly: true,
                        onTap: () async {
                          List<String>? data = await Get.to(
                            () => SportsSelectionView(
                              selected: controller.appUser.value.sports!,
                            ),
                          );
                          if (data != null) {
                            controller.updateFireStoreUser({'sports': data});
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => FormBuilderTextField(
                        name: 'lngs',
                        decoration: appInputDecoration(
                          '${controller.selectedLanguagesMessage}',
                          FontAwesomeIcons.language,
                        ),
                        readOnly: true,
                        onTap: () async {
                          List<String>? data = await Get.to(
                            () => LanguagesSelectionView(
                              selected: controller.appUser.value.languages!,
                            ),
                          );
                          if (data != null) {
                            controller.updateFireStoreUser({'languages': data});
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            CountryCodePicker(
                              initialSelection:
                                  controller.appUser.value.countryCode,
                              showCountryOnly: true,
                              alignLeft: false,
                              padding: const EdgeInsets.all(8),
                              textStyle: TextStyle(fontSize: 20),
                              hideMainText: true,
                              onChanged: (value) async {
                                await controller.updateFireStoreUser({
                                  'country_code': value.code,
                                  'country_name': value.name,
                                });
                              },
                            ),
                            SizedBox(width: 10),
                            Text(
                              controller.appUser.value.countryName!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => FormBuilderTextField(
                        name: 'jarena',
                        decoration: appInputDecoration(
                          'Joind Arenas (${controller.appUser.value.joinedArena})',
                          FontAwesomeIcons.futbol,
                        ),
                        readOnly: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => FormBuilderTextField(
                        name: 'tareans',
                        decoration: appInputDecoration(
                          'Hosted Arenas (${controller.appUser.value.hostedArena})',
                          FontAwesomeIcons.futbol,
                        ),
                        readOnly: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => FormBuilderTextField(
                        name: 'folwrs',
                        decoration: appInputDecoration(
                          'Followers (${controller.appUser.value.followers!.length})',
                          FontAwesomeIcons.users,
                        ),
                        readOnly: true,
                        onTap: () {
                          if (controller.appUser.value.followers!.length > 0) {
                            Get.to(
                              () => UsersListView(
                                ids: controller.appUser.value.followers!,
                                title: 'Followers',
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => FormBuilderTextField(
                        name: 'flwing',
                        decoration: appInputDecoration(
                          'Following (${controller.appUser.value.following!.length})',
                          FontAwesomeIcons.users,
                        ),
                        readOnly: true,
                        onTap: () {
                          if (controller.appUser.value.following!.length > 0) {
                            Get.to(
                              () => UsersListView(
                                ids: controller.appUser.value.following!,
                                title: 'Followings',
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundedButton(
                          onPressed: () {
                            if (_profileFormkey.currentState!
                                .saveAndValidate()) {
                              Map<String, dynamic> data =
                                  _profileFormkey.currentState!.value;
                              controller.updateFireStoreUser({
                                'name': data['name'],
                                'about': data['about'],
                              });
                            }
                          },
                          text: 'Save',
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
