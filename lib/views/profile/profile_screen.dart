import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/create_account_controller.dart';
import 'package:live_arena/views/profile/components/laguages_selection_view.dart';
import 'package:live_arena/views/profile/components/sports_selection_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormkey = GlobalKey<FormBuilderState>();
  final controlelr = Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: context.height * 0.25,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  color: AppTheme.primaryColor,
                ),
                child: Obx(() {
                  return Center(
                    child: SizedBox(
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
                              child: controlelr.fileImage.value.path.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                    )
                                  : Image.file(
                                      controlelr.fileImage.value,
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
                                  File? image =
                                      await controlelr.picFileImage(source);
                                  controlelr.fileImage(image);
                                }
                              },
                              child: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text("Profile Information", style: txt20b),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FormBuilder(
                  key: _profileFormkey,
                  child: Column(
                    children: [
                      Obx(
                        () => Column(
                          children: [
                            FormBuilderTextField(
                              name: 'username',
                              decoration: appInputDecoration(
                                'Username',
                                FontAwesomeIcons.idBadge,
                              ).copyWith(
                                suffixIcon: controlelr.isUserNameExists.isTrue
                                    ? const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      )
                                    : const Icon(Icons.check),
                              ),
                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context),
                              //   FormBuilderValidators.minLength(context, 3),
                              // ]),
                              onChanged: (d) => controlelr.findId(d!),
                            ),
                            controlelr.isFindingId.isTrue
                                ? const LinearProgressIndicator()
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      Obx(
                        () => FormBuilderTextField(
                          name: 'sports',
                          decoration: appInputDecoration(
                            '${controlelr.selectedSportsMessage}',
                            FontAwesomeIcons.futbol,
                          ),
                          readOnly: true,
                          onTap: () async {
                            // print(controlelr.selectedSports.toString());
                            List? data = await Get.to(
                              () => SportsSelectionView(
                                selected: controlelr.selectedSports,
                              ),
                            );
                            if (data != null) {
                              controlelr.selectedSports(data.cast<String>());
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => FormBuilderTextField(
                          name: 'languages',
                          decoration: appInputDecoration(
                            '${controlelr.selectedLanguagesMessage}',
                            FontAwesomeIcons.language,
                          ),
                          readOnly: true,
                          onTap: () async {
                            print(controlelr.selectedLanguages.toString());
                            List? data = await Get.to(
                              () => LanguagesSelectionView(
                                  selected: controlelr.selectedLanguages),
                            );
                            if (data != null) {
                              controlelr.selectedLanguages(data.cast<String>());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              onPressed: () {
                if (_profileFormkey.currentState!.saveAndValidate()) {
                  if (controlelr.fileImage.value.path.isEmpty) {
                    kErrorSnakBar('Please select profile image');
                    return;
                  } else if (controlelr.isUserNameExists.isTrue) {
                    kErrorSnakBar('Please change username');
                    return;
                  }
                  controlelr.createProfile(
                    _profileFormkey.currentState!.value,
                    controlelr.fileImage.value,
                  );
                }
              },
              color: AppTheme.primaryColor,
              text: "Create Profile",
            ),
          ],
        ),
      ),
    );
  }
}
