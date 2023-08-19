import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/constants.dart';
import 'package:live_arena/views/home/arena/find_screen.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        decoration: appInputDecoration(
          'Search',
          FontAwesomeIcons.search,
        ),
        readOnly: true,
        onTap: () => Get.to(() => FindScreen()),
      ),
    );
  }
}
