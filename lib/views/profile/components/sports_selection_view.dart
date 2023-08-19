import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/config/data.dart';

class SportsSelectionView extends StatelessWidget {
  SportsSelectionView({
    Key? key,
    required this.selected,
    this.maxOne = false,
  }) : super(key: key);

  final List<String> selected;
  final bool maxOne;
  final formkey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports'),
      ),
      body: FormBuilder(
        key: formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: maxOne
                ? FormBuilderChoiceChip(
                    name: 'sports',
                    spacing: 10,
                    initialValue: selected.length > 0 ? selected.first : '',
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    options: SportsData()
                        .allSports
                        .map(
                          (e) => FormBuilderChipOption(
                            value: e,
                            child: Text(
                              '$e',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : FormBuilderFilterChip(
                    name: 'sports',
                    spacing: 10,
                    validator: (value) {
                      if (value!.length < 1)
                        return 'Pelase select at least 1 sport';
                      if (value.length > 10)
                        return 'Pelase select maximum 10 sports';
                      return null;
                    },
                    initialValue: selected,
                    options: SportsData()
                        .allSports
                        .map(
                          (e) => FormBuilderChipOption(
                            value: e,
                            child: Text(
                              '$e',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        )
                        .toList(),
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
                  Get.back(result: formkey.currentState!.value['sports']);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
