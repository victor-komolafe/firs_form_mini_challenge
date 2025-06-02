import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/widgets/dropdown_form_widget.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Form2Screen extends StatefulWidget {
  const Form2Screen({super.key});

  @override
  State<Form2Screen> createState() => _Form2ScreenState();
}

// enum Genders { male, female }

class _Form2ScreenState extends State<Form2Screen> {
  // void _validate() {
  //   final form = _formKey.currentState;
  //   if (form!.validate() == false) {
  //     return;
  //   }
  // }
// List<String> genders = ['male', 'female'];

  Genders? selectedGender = Genders.male;
  LGA? selectedLGA = LGA.amac;
  WardResidence? selectedWard = WardResidence.abj;
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: TextEditingController(),
          formTitleText: 'Address',
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: 'Placeholder Text',
          validator: (text) => text!.isEmpty ? 'Address cannot be empty' : null,
        ),
        const SizedBox(height: 20),
        MyDropdownFormWidget(
          formTitleText: 'LGA',
          // value: selectedGender,
          items: LGA.values,
          hintText: 'Choose an Option',
          onChanged: (lgaValues) {
            selectedLGA = lgaValues;
          },
          itemLabelBuilder: (item) => item.name,
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        MyDropdownFormWidget(
          formTitleText: 'Ward of Residence',
          // value: selectedGender,
          items: WardResidence.values,
          hintText: 'Choose an Option',
          onChanged: (wardValues) {
            selectedWard = wardValues;
          },
          itemLabelBuilder: (item) => item.name,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: TextEditingController(),
          formTitleText: 'Registration Date',
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: 'DD-MM-YYYY - the day\'s date',
          validator: (text) =>
              text!.isEmpty ? 'Reg. date cannot be empty' : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
