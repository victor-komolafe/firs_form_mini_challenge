import 'package:firebase_database/firebase_database.dart';
import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/database/database_service.dart';
import 'package:firs_mini_project/widgets/dropdown_form_widget.dart';
import 'package:firs_mini_project/widgets/pressable_button.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:firs_mini_project/widgets/user_form_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

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
late String address;
late String registrationDate;
late String wardResidence;
// late DateTime? dobPickDate;
String? dob = ''; //var sent to userForm and used in db

Genders? selectedGender = Genders.male;
farmingField? selectedField = farmingField.livestock;

LGA? selectedLGA = LGA.amac;
WardResidence? selectedWard = WardResidence.gwarimpa;

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
  final _fieldController = TextEditingController();

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

  final dateFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        initialDate: DateTime.now(),
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    _dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate!);
    dob = _dobController.text;
  }

  // File? _selectedImage;
  // final ImagePicker _picker = ImagePicker();
// Add this method to your class
  // Future<void> _pickImage() async {
  //   try {
  //     final XFile? pickedFile = await _picker.pickImage(
  //       source: ImageSource.gallery,
  //       maxWidth: 800,
  //       maxHeight: 800,
  //       imageQuality: 80,
  //     );

  //     if (pickedFile != null) {
  //       setState(() {
  //         _selectedImage = File(pickedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error selecting image: $e')),
  //     );
  //   }
  // }

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
            onStepContinue: () async {
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
                  DatabaseService dbService = DatabaseService();
                  // dbService.create(path: 'data 1', data: {'Name': name});
                  await dbService.createFarmer(
                      name: name,
                      age: age,
                      gender: gender,
                      phoneNumber: phoneNumber,
                      nin: nin,
                      lga: selectedLGA!.name,
                      wardResidence: selectedWard!.name,
                      dob: dob!,
                      farmingField: selectedField!.name,
                      address: address,
                      registrationDate: registrationDate);
                  // DataSnapshot? snapshot = await dbService.read(path: 'data 1');
                  // print(snapshot!.value);

                  _formKeys[currentStep].currentState?.save();
                  debugPrint('Form is valid and saved');
                  debugPrint('Name: $name');
                  debugPrint('Age: $age');
                  debugPrint('Gender: $gender');
                  debugPrint('Phone: $phoneNumber');
                  debugPrint('NIN: $nin');
                  debugPrint('LGA: $selectedLGA');
                  debugPrint('Ward: $selectedWard');
                  debugPrint('DOB: $dob');

//  TODO: TO CHANGE UPDATE USERFORMDETAILS LOGIC based on DB data
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => UserFormDetails(
                            lga: lga,
                            wardResidence: wardResidence,
                            age: age,
                            name: name,
                            gender: gender,
                            nin: nin,
                            address: address,
                            registrationDate: registrationDate,
                            phoneNumber: phoneNumber,
                            dob: dob!,
                          )));
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

  Widget formScreen1() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
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
        IntrinsicHeight(
          child: Row(
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
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender';
                  }
                  return null;
                },
                itemLabelBuilder: (item) => item.name,
              ))
            ],
          ),
        ),
        // const SizedBox(height: 20),
        CustomTextField(
          controller: _phoneNoController,
          formTitleText: 'Phone Number',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: '080...',
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

  Widget formScreen2() {
    return Column(
      children: [
        CustomTextField(
          controller: _addressController,
          formTitleText: 'Address',
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: 'Placeholder Text',
          validator: (text) => text!.isEmpty ? 'Address cannot be empty' : null,
          onSaved: (value) {
            address = value ?? '';
          },
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
          validator: (value) {
            if (value == null) {
              return 'Please select an LGA';
            }
            return null;
          },
          itemLabelBuilder: (item) => item.name,
        ),
        // const SizedBox(height: 20),
        MyDropdownFormWidget(
          formTitleText: 'Ward of Residence',
          // value: selectedGender,
          items: WardResidence.values,
          hintText: 'Choose an Option',
          onChanged: (wardValues) {
            selectedWard = wardValues;
            wardResidence = wardValues!.name;
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a ward';
            }
            return null;
          },
          itemLabelBuilder: (item) => item.name,
        ),
        // const SizedBox(height: 20),
        CustomTextField(
          controller: _regDateController,
          inputFormatters: [
            MaskTextInputFormatter(
              mask: '##-##-####',
              filter: {'#': RegExp(r'[0-9]')},
              type: MaskAutoCompletionType.lazy,
            )
          ],
          formTitleText: 'Registration Date',
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          hintText: 'DD-MM-YYYY - the day\'s date',
          validator: (text) =>
              text!.isEmpty ? 'Reg. date cannot be empty' : null,
          onSaved: (value) {
            registrationDate = value ?? '';
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget formScreen3() {
    return Column(
      children: [
        // Stack(
        //   children: [
        //     _image != null
        //         ? CircleAvatar(
        //             radius: 50,
        //             backgroundImage: MemoryImage(_image!),
        //           )
        //         : CircleAvatar(
        //             radius: 50,
        //             child: Icon(
        //               Icons.person,
        //               size: 50,
        //               color: Colors.grey[600],
        //             )),
        //     Positioned(
        //       bottom: -10,
        //       left: 60,
        //       child: IconButton(
        //         onPressed: selectImage,
        //         icon: const Icon(Icons.add_a_photo),
        //       ),
        //     )
        //   ],
        // ),

        // const SizedBox(height: 20),
        TextFormField(
          controller: _dobController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'DOB',
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.calendar_month),
          ),
          onTap: () {
            _selectDate();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date of birth';
            }
            return null;
          },
          onSaved: (value) {
            dob = value ?? '';
          },
        ),

        const SizedBox(height: 20),
        MyDropdownFormWidget(
          formTitleText: 'Farming Field',
          // value: selectedGender,
          items: farmingField.values,
          hintText: 'Area of Specialty',
          onChanged: (value) {
            setState(() {
              selectedField = value;
            });

            // gender = value!.name;
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a farming field';
            }
            return null;
          },
          itemLabelBuilder: (item) => item.name,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[0], child: formScreen1()),
            // content: FormScreen1(),
            isActive: currentStep >= 0),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[1], child: formScreen2()),
            // content: FormScreen2(),
            isActive: currentStep >= 1),
        Step(
            state: currentStep >= 2 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[2], child: formScreen3()),
            isActive: currentStep >= 2),
      ];
}
