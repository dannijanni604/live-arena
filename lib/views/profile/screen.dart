// import 'dart:io';
// import 'package:clubhouse/components/rounded_btn.dart';
// import 'package:clubhouse/components/text_styles.dart';
// import 'package:clubhouse/config/apptheme.dart';
// import 'package:clubhouse/config/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:ui';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _profileFormkey = GlobalKey<FormState>();
//   int userJoinedArena = 0;
//   int userHostedArena = 0;
//   File? _pickedImage;

//   TextEditingController firstName = TextEditingController();
//   TextEditingController lastName = TextEditingController();
//   TextEditingController aboutMe = TextEditingController();
//   TextEditingController countery = TextEditingController();
//   TextEditingController userLanguage = TextEditingController();
//   TextEditingController favSports = TextEditingController();
//   String hintText = "";
//   String labelText = "";
//   IconData? prefixIcon;

//   Widget _buildUserProfileInputFormField({
//     required String hintText,
//     required TextEditingController controller,
//     required String inputErrorText,
//     String? labelText,
//     IconData? prefixIcon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 offset: Offset(0, 1),
//                 color: AppTheme.primaryColor.withOpacity(0.1),
//                 blurRadius: 2,
//                 spreadRadius: 2,
//               ),
//             ]),
//         child: TextFormField(
//           scrollPadding: EdgeInsets.symmetric(vertical: 5),
//           controller: controller,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return '$inputErrorText';
//             }
//             return null;
//           },
//           decoration: InputDecoration(
//             hintStyle: TextStyle(color: Colors.grey),
//             isDense: true,
//             hintText: hintText,
//             labelText: labelText,
//             prefixIcon: Icon(prefixIcon),
//             border: OutlineInputBorder(
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAboutMe() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//       child: TextFormField(
//         maxLines: 3,
//         controller: aboutMe,
//         decoration: InputDecoration(
//           isDense: true,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: context.height * 0.25,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                   color: AppTheme.primaryColor,
//                 ),
//                 child: Center(
//                   child: SizedBox(
//                     width: 60,
//                     height: 60,
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.white),
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: NetworkImage(
//                                 "https://ui-avatars.com/api/?name=x&background=FFFFFF&color=000",
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               showModalBottomSheet(
//                                 context: context,
//                                 builder: (context) => bottomSheet(),
//                               );
//                             },
//                             child: Icon(Icons.add_a_photo),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 20, horizontal: 20),
//                     child: Text("Profile Information", style: txt20b),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Form(
//                   key: _profileFormkey,
//                   child: Column(
//                     children: [
//                       FormBuilderTextField(
//                         name: 'name',
//                         decoration: inputDecoration(
//                           'Name',
//                           FontAwesomeIcons.textHeight,
//                         ),
//                       ),
//                       _buildUserProfileInputFormField(
//                           hintText: "First name",
//                           controller: firstName,
//                           inputErrorText: "Enter first name",
//                           prefixIcon: Icons.person),
//                       _buildUserProfileInputFormField(
//                           hintText: "Last name",
//                           controller: lastName,
//                           inputErrorText: "Enter last name",
//                           prefixIcon: Icons.person),
//                       _buildUserProfileInputFormField(
//                           hintText: "Understanding language",
//                           controller: userLanguage,
//                           inputErrorText: "Enter language",
//                           prefixIcon: Icons.language),
//                       _buildUserProfileInputFormField(
//                           hintText: "Countary name",
//                           controller: countery,
//                           inputErrorText: "Enter Countary name",
//                           prefixIcon: Icons.flag),
//                       _buildUserProfileInputFormField(
//                           hintText: "Favourite Sports",
//                           controller: favSports,
//                           inputErrorText: "Enter your favourite sports.. ",
//                           prefixIcon: Icons.sports_esports),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 20),
//                             child: Text("About", style: txt16b),
//                           ),
//                         ],
//                       ),
//                       _buildAboutMe(),
//                     ],
//                   ),
//                 ),
//               ),
//               ListTile(
//                 onTap: () {},
//                 title: Text("Already Joined Arena", style: txt16b),
//                 trailing: Text("$userJoinedArena", style: txt16b),
//               ),
//               ListTile(
//                 onTap: () {},
//                 title: Text("Already Hosted Arena", style: txt16b),
//                 trailing: Text("$userHostedArena", style: txt16b),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     RoundedButton(
//                       onPressed: () {
//                         if (_profileFormkey.currentState!.validate()) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Processing Data')),
//                           );
//                         }
//                       },
//                       minimumWidth: 210,
//                       minimumHeight: 48,
//                       color: Colors.green,
//                       text: "Create",
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget bottomSheet() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//       height: 150,
//       child: Column(
//         children: [
//           Text(
//             "Select Image",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               TextButton.icon(
//                   onPressed: () {
//                     takePic(ImageSource.camera);
//                   },
//                   icon: Icon(Icons.camera),
//                   label: Text("Camera")),
//               TextButton.icon(
//                   onPressed: () {
//                     takePic(ImageSource.gallery);
//                   },
//                   icon: Icon(FontAwesomeIcons.image),
//                   label: Text("Gallery")),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void takePic(ImageSource source) async {
//     final PickedFile? pickedFile =
//         (await ImagePicker.platform.pickImage(source: source));
//     if (pickedFile != null) {
//       setState(() {
//         _pickedImage = File(pickedFile.path);
//       });
//     }
//   }
// }
