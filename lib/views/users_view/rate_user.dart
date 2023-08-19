import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/controllers/auth_controller.dart';
import 'package:live_arena/models/app_user.dart';

class RateUserVew extends StatefulWidget {
  RateUserVew({Key? key, required this.user}) : super(key: key);
  final AppUser user;

  @override
  _RateUserVewState createState() => _RateUserVewState();
}

class _RateUserVewState extends State<RateUserVew> {
  final _formKey = GlobalKey<FormBuilderState>();

  double rating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AppTheme.primaryColor,
                  ),
                  onRatingUpdate: (r) {
                    rating = (r);
                  },
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'review',
                  decoration: appInputDecoration(
                    'Review',
                    FontAwesomeIcons.infoCircle,
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 20),
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
                              DocumentReference<Map<String, dynamic>> userRef =
                                  dbUser.doc(widget.user.id);
                              double oldRaing = (widget.user.rating == 0
                                  ? 5
                                  : widget.user.rating!);
                              double newRating = (oldRaing + rating) / 2;
                              tra.update(userRef, {'rating': newRating});
                              tra.set(dbReviews.doc(), {
                                'reviewed_user': widget.user.id,
                                'review_by': AuthController.to.appUser.value.id,
                                'created_by': FieldValue.serverTimestamp(),
                                'review':
                                    _formKey.currentState!.value['review'],
                                'rating': rating,
                              });
                            });
                            Get.back();
                            kSuccessSnakBar('Review Submitted Succesfully');
                          } catch (e) {
                            kErrorSnakBar('$e');
                          } finally {
                            EasyLoading.dismiss();
                          }
                        }
                      },
                      child: Text('Submit Review'),
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
