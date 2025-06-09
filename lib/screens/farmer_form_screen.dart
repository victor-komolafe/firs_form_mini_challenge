import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/widgets/dropdown_form_widget.dart';
import 'package:firs_mini_project/widgets/pressable_button.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FarmerFormScreen extends StatefulWidget {
  const FarmerFormScreen({super.key});

  @override
  State<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

int currentStep = 0;
late String name;
late String age;
late String gender;
late String phoneNumber;
late String nin;
late String lga;
late String wardResidence;

Genders? selectedGender = Genders.male;
LGA? selectedLGA = LGA.amac;
WardResidence? selectedWard = WardResidence.abj;

final _formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _FarmerFormScreenState extends State<FarmerFormScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _ninController = TextEditingController();
  final _addressController = TextEditingController();
  final _regDateController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneNoController.dispose();
    _ninController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool _validator() {
    if (_formKeys[currentStep].currentState?.validate() == true) {
      _formKeys[currentStep].currentState?.save();

      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) =>
      //         const UserFormDetails(_formKeys[currentStep].currentState)));
      setState(() {});
      // debugPrint('Form is valid');
      return true;
      // debugPrint('Form is saved');
    } else {
      debugPrint('Form is not valid');
      return false;
    }
    // final form = _formKey.currentState;
    // if (form?.validate() == false) {
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Register a new Farmer',
            style: ConstantFonts.inter,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Stepper(
            // connectorColor: Wid
            // connectorColor:
            //     WidgetStateProperty.all(ConstantColors.primaryColor),
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  currentStep == 0
                      ? const Expanded(child: SizedBox())
                      : Expanded(
                          child: PressableButton(
                            text: 'Previous',
                            onPressed: details.onStepCancel,
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: PressableButton(
                    text: currentStep == getSteps().length - 1
                        ? 'Submit'
                        : 'Next',
                    onPressed: details.onStepContinue,
                  )),
                ],
              );
            },
            onStepContinue: () {
              // _validator();
              final isLastStep = currentStep == getSteps().length - 1;

              if (isLastStep) {
                debugPrint('Last Step');
                if (_validator() == false) {
                  debugPrint("Couldn't Submit form error in validation");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields'),
                    ),
                  );
                  return;
                } else {
                  _formKeys[currentStep].currentState?.save();
                  debugPrint('Form is valid and saved');
                  debugPrint('Name: $name');
                  debugPrint('Age: $age');
                  debugPrint('Gender: $gender');
                  debugPrint('Phone: $phoneNumber');
                  debugPrint('NIN: $nin');
                  debugPrint('LGA: $selectedLGA');
                  debugPrint('Ward: $selectedWard');
                }
              }

              if (currentStep < getSteps().length - 1) {
                setState(() {
                  // if (_formKeys[currentStep].currentState!.validate() ==
                  //     false)
                  if (_validator() == false) {
                    return;
                  } else {
                    _formKeys[currentStep].currentState?.save();
                    currentStep += 1;
                  }
                  //   //TODO: FIX ERROR LOGIC
                  // } else {
                  //   currentStep += 1;
                  // }
                });
              }
            },
            onStepTapped: (value) {
              if (_validator() == false) {
                return;
              } else {
                // _validator();

                setState(() {
                  _formKeys[currentStep].currentState?.save();
                  currentStep = value;
                });
              }
            },
            onStepCancel: () {
              setState(() {
                if (currentStep > 0) {
                  currentStep -= 1;
                }
                null;
              });
            },
          ),
        ));
  }

  Widget FormScreen1() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
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
                controller: _ageController,
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
          controller: _phoneNoController,
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
          controller: _ninController,
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
      ],
    );
  }

  Widget FormScreen2() {
    return Column(
      children: [
        CustomTextField(
          controller: _addressController,
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
            lga = lgaValues!.name;
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
            wardResidence = wardValues!.name;
          },
          itemLabelBuilder: (item) => item.name,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _regDateController,
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

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[0], child: FormScreen1()),
            // content: FormScreen1(),
            isActive: currentStep >= 0),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[1], child: FormScreen2()),
            // content: FormScreen2(),
            isActive: currentStep >= 1),
        Step(
            state: currentStep >= 2 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(
              key: _formKeys[2],
              child: Column(
                children: [
                  CustomTextField(
                    controller: _dobController,
                    formTitleText: 'DOB',
                    hintText: 'Enter your DOB',
                    validator: (text) =>
                        text!.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _ageController,
                    formTitleText: 'Age',
                    hintText: 'Enter your Age',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (text) =>
                        text!.isEmpty ? 'Age cannot be empty' : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            isActive: currentStep >= 2),
      ];
}
