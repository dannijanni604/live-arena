import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/create_account_controller.dart';
import 'package:live_arena/controllers/create_arena_controller.dart';
import 'package:live_arena/views/home/arena/search_user.dart';
import 'package:live_arena/views/profile/components/laguages_selection_view.dart';
import 'package:live_arena/views/profile/components/sports_selection_view.dart';

class CreateArenaScreen extends StatefulWidget {
  const CreateArenaScreen({Key? key}) : super(key: key);

  @override
  _CreateArenaScreenState createState() => _CreateArenaScreenState();
}

class _CreateArenaScreenState extends State<CreateArenaScreen> {
  final _arenaformKey = GlobalKey<FormBuilderState>();

  final controller = Get.put(CreateAreanController());
  final accController = Get.put(CreateAccountController());
  Rx<File>? image = Rx<File>(File(''));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10.5,
                child: Container(
                  decoration: const BoxDecoration(color: AppTheme.primaryColor),
                  child: Obx(() {
                    return Center(
                        child: Stack(
                      children: [
                        image!.value.path.isNotEmpty
                            ? Positioned(
                                child: Image.file(
                                  image!.value,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Image.asset("assets/images/sports.png"),
                        Positioned(
                          // bottom: 10,
                          right: 10,
                          child: IconButton(
                            onPressed: () async {
                              ImageSource? source = await Get.bottomSheet(
                                imagePickerBottomSheet(),
                                backgroundColor: Colors.white,
                              );
                              if (source != null) {
                                File? _image = await accController.picFileImage(
                                  source,
                                  quality: 100,
                                  width: 1080,
                                  height: 720,
                                );
                                if (_image != null) {
                                  setState(() {
                                    image!(_image);
                                  });
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    )

                        // Image.file(
                        //     image!,
                        //     fit: BoxFit.cover,
                        //   ),
                        );
                  }),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: FormBuilder(
                  key: _arenaformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBuilderTextField(
                        name: 'title',
                        decoration: appInputDecoration(
                          'Title',
                          FontAwesomeIcons.signature,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'description',
                        decoration: appInputDecoration(
                          'Description',
                          FontAwesomeIcons.info,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderDateTimePicker(
                        name: 'start_time',
                        decoration: appInputDecoration(
                          'Start Time',
                          FontAwesomeIcons.clock,
                        ),
                        firstDate: DateTime.tryParse(
                            FieldValue.serverTimestamp().toString()),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => FormBuilderTextField(
                          name: 'languages',
                          decoration: appInputDecoration(
                            controller.selectedLanguagesMessage,
                            FontAwesomeIcons.language,
                          ),
                          readOnly: true,
                          onTap: () async {
                            List? selected = await Get.to(
                              () => LanguagesSelectionView(
                                selected: controller.selectedLanguages,
                              ),
                            );
                            if (selected != null && selected.length > 0) {
                              controller
                                  .selectedLanguages(selected.cast<String>());
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => FormBuilderTextField(
                          name: 'sport',
                          decoration: appInputDecoration(
                            controller.selectedSports.value,
                            FontAwesomeIcons.futbol,
                          ),
                          readOnly: true,
                          onTap: () async {
                            String? selected = await Get.to(
                              () => SportsSelectionView(
                                selected: [controller.selectedSports.value],
                                maxOne: true,
                              ),
                            );
                            if (selected != null) {
                              controller.selectedSports(selected);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'arena',
                        decoration: appInputDecoration(
                          'Arena',
                          FontAwesomeIcons.circleNotch,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SearchUserViwe());
                        },
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Obx(
                              () => controller.selectedBroadcasters.length == 0
                                  ? const Text('Add Co-hosts')
                                  : Stack(
                                      children: controller
                                          .selectedBroadcasters.reversed
                                          .map(
                                            (e) => Container(
                                              margin: EdgeInsets.only(
                                                  left: (25.0 *
                                                      controller
                                                          .selectedBroadcasters
                                                          .indexOf(e))),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  e.avatar!,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                            ),
                          ),
                        ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              onPressed: () {
                if (image!.value.path.isEmpty) {
                  kErrorSnakBar('Please select arena image');
                  return;
                }
                if (_arenaformKey.currentState!.saveAndValidate()) {
                  printInfo(info: "arena Go to create");
                  controller.createArena(
                    _arenaformKey.currentState!.value,
                    image!.value,
                  );
                  Get.back();
                }
              },
              color: AppTheme.primaryColor,
              text: "Start Arena",
            ),
          ],
        ),
      ),
    );
  }
}
