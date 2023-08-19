import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/models/app_user.dart';

class ReportUserView extends StatefulWidget {
  const ReportUserView({Key? key, required this.user}) : super(key: key);
  final AppUser user;

  @override
  _ReportUserViewState createState() => _ReportUserViewState();
}

class _ReportUserViewState extends State<ReportUserView> {
  final _formKey = GlobalKey<FormBuilderState>();

  double rating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'reason',
                  decoration: appInputDecoration(
                    'Report Reason',
                    FontAwesomeIcons.infoCircle,
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundedButton(
                      color: AppTheme.primaryColor,
                      onPressed: () async {
                        if (_formKey.currentState!.saveAndValidate()) {
                          try {
                            EasyLoading.show(status: 'Submitting');
                            await FirebaseFirestore.instance
                                .runTransaction((tra) async {
                              tra.update(dbUser.doc(widget.user.id),
                                  {'reported': FieldValue.increment(1)});
                              tra.set(dbUserReports.doc(), {
                                'reported_user': widget.user.id,
                                'report_by': AuthController.to.appUser.value.id,
                                'created_by': FieldValue.serverTimestamp(),
                                'reason':
                                    _formKey.currentState!.value['reason'],
                              });
                            });
                            Get.back();
                            kSuccessSnakBar('User Reported Succesfully');
                          } catch (e) {
                            kErrorSnakBar('$e');
                          } finally {
                            EasyLoading.dismiss();
                          }
                        }
                      },
                      child: const Text('Submit Report'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
