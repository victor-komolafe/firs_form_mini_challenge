import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/widgets/dropdown_form_widget.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:firs_mini_project/widgets/user_form_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Form1Screen extends StatefulWidget {
  // late String name;
  // late String age;
  // late String gender;
  // late String phoneNumber;
  // late String nin;
  const Form1Screen({
    super.key,
  });

  @override
  State<Form1Screen> createState() => _Form1ScreenState();
}

// enum Genders { male, female }
late String name;
late String age;
late String gender;
late String phoneNumber;
late String nin;

final userFormDetails = UserFormDetails(
  name: name,
  age: age,
  gender: gender,
  phoneNumber: phoneNumber,
  nin: nin,
);

class _Form1ScreenState extends State<Form1Screen> {
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
          formTitleText: 'Name',
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: 'Enter your Name',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
          validator: (text) => text!.isEmpty ? 'Name cannot be empty' : null,
          onSaved: (value) {
            name = value!;
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: TextEditingController(),
                formTitleText: 'Age',
                titleTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                hintText: 'Placeholder Text',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (text) =>
                    text!.isEmpty ? 'Age cannot be empty' : null,
                onSaved: (value) {
                  age = value!;
                },
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
                child: MyDropdownFormWidget(
              formTitleText: 'Gender',
              // value: selectedGender,
              items: Genders.values,
              hintText: 'Choose an Option',
              onChanged: (value) {
                selectedGender = value;
                gender = value!.name;
              },
              itemLabelBuilder: (item) => item.name,
            ))
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: TextEditingController(),
          formTitleText: 'Phone Number',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: 'Enter your Phone Number',
          validator: (text) =>
              text!.isEmpty ? 'Phone number can\'t be empty' : null,
          onSaved: (value) {
            phoneNumber = value!;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: TextEditingController(),
          formTitleText: 'NIN',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: 'Enter your National Identification Number',
          validator: (text) => text!.isEmpty ? 'NIN cannot be empty' : null,
          onSaved: (value) {
            nin = value!;
          },
        ),
        const SizedBox(height: 20),
        // CustomTextField(
        //   controller: TextEditingController(),
        //   formTitleText: 'Address',
        //   titleTextStyle: const TextStyle(
        //       fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        //   hintText: 'Placeholder Text',
        //   validator: (text) => text!.isEmpty ? 'Address cannot be empty' : null,
        // ),
        // const SizedBox(height: 20),
        // MyDropdownFormWidget(
        //   formTitleText: 'LGA',
        //   // value: selectedGender,
        //   items: LGA.values,
        //   hintText: 'Choose an Option',
        //   onChanged: (lgaValues) {
        //     selectedLGA = lgaValues;
        //   },
        //   itemLabelBuilder: (item) => item.name,
        // ),
        // const SizedBox(height: 20),
        // const SizedBox(height: 20),
        // MyDropdownFormWidget(
        //   formTitleText: 'Ward of Residence',
        //   // value: selectedGender,
        //   items: WardResidence.values,
        //   hintText: 'Choose an Option',
        //   onChanged: (wardValues) {
        //     selectedWard = wardValues;
        //   },
        //   itemLabelBuilder: (item) => item.name,
        // ),
        // const SizedBox(height: 20),
        // CustomTextField(
        //   controller: TextEditingController(),
        //   formTitleText: 'Registration Date',
        //   titleTextStyle: const TextStyle(
        //       fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        //   hintText: 'DD-MM-YYYY - the day\'s date',
        //   validator: (text) =>
        //       text!.isEmpty ? 'Reg. date cannot be empty' : null,
        // ),
        // const SizedBox(height: 20),
      ],
    );
  }
}
