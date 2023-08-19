import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/data.dart';

class LanguagesSelectionView extends StatelessWidget {
  LanguagesSelectionView({
    Key? key,
    required this.selected,
  }) : super(key: key);

  final List<String> selected;
  final formkey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages'),
      ),
      body: FormBuilder(
        key: formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                FormBuilderFilterChip(
                  name: 'languages',
                  spacing: 10,
                  initialValue: selected,
                  validator: (value) => value!.length < 1
                      ? 'Pelase select at least one language'
                      : null,
                  options: LanguagesData()
                      .languages
                      .map(
                        (e) => FormBuilderChipOption(
                          value: e,
                          child: Text(
                            '$e',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              text: 'Select',
              color: AppTheme.primaryColor,
              onPressed: () {
                if (formkey.currentState!.saveAndValidate()) {
                  Get.back(result: formkey.currentState!.value['languages']);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
