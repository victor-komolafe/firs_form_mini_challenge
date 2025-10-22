import 'package:firebase_database/firebase_database.dart';
import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/database/database_service.dart';
import 'package:firs_mini_project/widgets/dropdown_form_widget.dart';
import 'package:firs_mini_project/widgets/image_picker_widget.dart';
import 'package:firs_mini_project/widgets/pressable_button.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:firs_mini_project/widgets/user_form_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';

class FarmerFormScreen extends StatefulWidget {
  final Map<String, dynamic>? existingData;
  const FarmerFormScreen({
    super.key,
    this.existingData,
  });

  @override
  State<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends State<FarmerFormScreen> {
  int curentStep = 0;
  late String name;
  late String age;
  late String gender;
  late String phoneNumber;
  late String nin;
  late String lga;
  late String address;
  String registrationDate = '';
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

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _ninController = TextEditingController();
  final _addressController = TextEditingController();
  final _regDateController = TextEditingController();
  final _dobController = TextEditingController();
  final _fieldController = TextEditingController();

  void _safeFomrDataTemporarily() {
    //TODO: Set up Shared preference for later usage
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Pre-populate form if editing existing data
    if (widget.existingData != null) {
      _populateExistingData();
    } else {
      _resetFormFields();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneNoController.dispose();
    _ninController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _ninController.dispose();
    _regDateController.dispose();
    _fieldController.dispose();

    super.dispose();
  }

  //resets form upon clear
  void _resetFormFields() {
    _nameController.clear();
    _ageController.clear();
    _phoneNoController.clear();
    _ninController.clear();
    _addressController.clear();
    _dobController.clear();
    _regDateController.clear();

    name = '';
    age = '';
    gender = '';
    phoneNumber = '';
    nin = '';
    lga = '';
    address = '';
    registrationDate = '';
    dob = '';
    wardResidence = '';
    _selectedImage = null;

    selectedGender = null; // or a default
    selectedLGA = null;
    selectedWard = null;
    selectedField = null;

    for (final key in _formKeys) {
      key.currentState?.reset();
    }

    setState(() {});
  }

  // Pre-populate form if editing existing data

  void _populateExistingData() {
    final data = widget.existingData!;

    // Populate text controllers
    _nameController.text = data['name'] ?? '';
    _ageController.text = data['age'] ?? '';
    _phoneNoController.text = data['phoneNumber'] ?? '';
    _ninController.text = data['nin'] ?? '';
    _addressController.text = data['address'] ?? '';
    _regDateController.text = data['registration date'] ?? '';
    _dobController.text = data['dob'] ?? '';

    // Set global variables
    name = data['name'] ?? '';
    age = data['age'] ?? '';
    gender = data['gender'] ?? '';
    phoneNumber = data['phoneNumber'] ?? '';
    nin = data['nin'] ?? '';
    lga = data['lga'] ?? '';
    address = data['address'] ?? '';
    dob = data['dob'] ?? '';
    wardResidence = data['wardResidence'] ?? '';
    registrationDate = data['registrationDate'] ?? '';

    _fieldController.text = data['farmingField'] ?? '';
    // _regDateController.text = data['registrationDate'] ?? '';

    // Set dropdown selections
    selectedGender = _getGenderFromString(data['gender']);
    selectedLGA = _getLGAFromString(data['lga']);
    selectedWard = _getWardFromString(data['wardResidence']);
    selectedField = _getFarmingFieldFromString(data['farmingField']);

    // Set image if exists
    if (data['profileImagePath'] != null &&
        data['profileImagePath'].isNotEmpty) {
      _selectedImage = File(data['profileImagePath']);
    }

    setState(() {}); // Refresh UI
  }

  // Helper methods to convert strings back to enum values
  Genders? _getGenderFromString(String? genderStr) {
    if (genderStr == null) return null;
    return Genders.values.firstWhere(
      (g) => g.name == genderStr,
      orElse: () => Genders.values.first,
    );
  }

  LGA? _getLGAFromString(String? lgaStr) {
    if (lgaStr == null) return null;
    return LGA.values.firstWhere(
      (l) => l.name == lgaStr,
      orElse: () => LGA.values.first,
    );
  }

  WardResidence? _getWardFromString(String? wardStr) {
    if (wardStr == null) return null;
    return WardResidence.values.firstWhere(
      (w) => w.name == wardStr,
      orElse: () => WardResidence.values.first,
    );
  }

  farmingField? _getFarmingFieldFromString(String? fieldStr) {
    if (fieldStr == null) return null;
    return farmingField.values.firstWhere(
      (f) => f.name == fieldStr,
      orElse: () => farmingField.values.first,
    );
  }

  bool _validator() {
    if (curentStep == 2 && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image')),
      );
      return false;
    }

    if (_formKeys[curentStep].currentState?.validate() == true) {
      _formKeys[curentStep].currentState?.save();

      setState(() {});
      return true;
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

  // late String? imageUrl;
  File? _selectedImage;
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
            'Register a  Farmer',
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
            currentStep: curentStep,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  curentStep == 0
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
                    text:
                        curentStep == getSteps().length - 1 ? 'Submit' : 'Next',
                    onPressed: details.onStepContinue,
                  )),
                ],
              );
            },
            onStepContinue: () async {
              // _validator();
              final isLastStep = curentStep == getSteps().length - 1;

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
                  // ensure current form saved before submission
                  _formKeys[curentStep].currentState?.save();
                  final parentContext = context;

                  // local async function that does DB work and DOES NOT use any BuildContext
                  Future<String?> _performSubmit() async {
                    DatabaseService dbService = DatabaseService();
                    String? imagePath;

                    if (_selectedImage != null) {
                      imagePath = _selectedImage!.path;
                      debugPrint('Image path to save: $imagePath');
                    }

                    bool isEditing = widget.existingData != null;

                    if (isEditing) {
                      await dbService.updateFarmerDetails(
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
                        registrationDate: registrationDate,
                        profileImagePath: imagePath,
                      );
                      debugPrint('Farmer details updated');
                    } else {
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
                        registrationDate: registrationDate,
                        profileImagePath: imagePath,
                      );
                      debugPrint('Farmer details created');
                    }

                    return imagePath;
                  }

                  // show a dialog that uses FutureBuilder so no BuildContext is awaited across async gaps
                  showDialog(
                    context: parentContext,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      return FutureBuilder<String?>(
                        future: _performSubmit(),
                        builder: (ctx, snapshot) {
                          // still loading
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          // finished: schedule UI actions after build frame to avoid calling Navigator during build
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // ensure widget still mounted before any navigation or Scaffold usage
                            if (!mounted) return;

                            // close the loading dialog
                            Navigator.of(dialogContext).pop();

                            if (snapshot.hasError) {
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error saving data: ${snapshot.error}')),
                              );
                              debugPrint(
                                  'Error saving farmer data: ${snapshot.error}');
                              return;
                            }

                            // success -> navigate to UserFormDetails
                            final imagePath = snapshot.data;
                            Navigator.of(parentContext).push(
                              MaterialPageRoute(
                                builder: (_) => UserFormDetails(
                                  lga: lga,
                                  wardResidence: wardResidence,
                                  age: age,
                                  name: name,
                                  gender: gender,
                                  nin: nin,
                                  farmingField: selectedField!.name,
                                  address: address,
                                  registrationDate: registrationDate,
                                  phoneNumber: phoneNumber,
                                  dob: dob!,
                                  profileImageUrl: imagePath,
                                ),
                              ),
                            );
                          });

                          // return an empty widget because navigation and dialog close happen in post frame callback
                          return const SizedBox.shrink();
                        },
                      );
                    },
                  );
                }
              }

              //     if (isLastStep) {
              //   debugPrint('Last Step');
              //   if (_validator() == false) {
              //     debugPrint("Couldn't Submit form error in validation");
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text('Please fill all required fields'),
              //       ),
              //     );
              //     return;
              //   } else {
              //     // Builder(builder: builder, sna);
              //     //TODO change to builder And also recheck logic of already saved user
              //     showDialog(
              //       context: context,
              //       barrierDismissible: false,
              //       builder: (context) => const Center(
              //         child: CircularProgressIndicator(),
              //       ),
              //     );

              //     try {
              //       DatabaseService dbService = DatabaseService();
              //       String? imagePath;

              //       // Upload image if selected

              //       // if (_selectedImage != null) {
              //       //   debugPrint('Uploading image...');
              //       //   imageUrl =
              //       //       await dbService.uploadProfileImage(_selectedImage!);
              //       //   debugPrint('Image upload result: $imageUrl');

              //       //   if (imageUrl == null) {
              //       //     throw Exception('Failed to upload image');
              //       //   }
              //       // }

              //       if (_selectedImage != null) {
              //         imagePath =
              //             _selectedImage!.path; // Just use the local path
              //         debugPrint('Image path to save: $imagePath');
              //       }
              //       // Check if this is an edit or new creation
              //       bool isEditing = widget.existingData != null;

              //       if (isEditing) {
              //         // Update existing farmer data
              //         await dbService.updateFarmerDetails(
              //           name: name,
              //           age: age,
              //           gender: gender,
              //           phoneNumber: phoneNumber,
              //           nin: nin,
              //           lga: selectedLGA!.name,
              //           wardResidence: selectedWard!.name,
              //           dob: dob!,
              //           farmingField: selectedField!.name,
              //           address: address,
              //           registrationDate: registrationDate,
              //           profileImagePath: imagePath,
              //         );
              //         debugPrint('Farmer details updated');
              //       } else {
              //         // Create new farmer data
              //         await dbService.createFarmer(
              //           name: name,
              //           age: age,
              //           gender: gender,
              //           phoneNumber: phoneNumber,
              //           nin: nin,
              //           lga: selectedLGA!.name,
              //           wardResidence: selectedWard!.name,
              //           dob: dob!,
              //           farmingField: selectedField!.name,
              //           address: address,
              //           registrationDate: registrationDate,
              //           profileImagePath: imagePath,
              //         );
              //         debugPrint('Farmer details created');
              //       }

              //       Navigator.pop(context); // Close loading dialog

              //       // // Save farmer data with image URL
              //       // await dbService.createFarmer(
              //       //     name: name,
              //       //     age: age,
              //       //     gender: gender,
              //       //     phoneNumber: phoneNumber,
              //       //     nin: nin,
              //       //     lga: selectedLGA!.name,
              //       //     wardResidence: selectedWard!.name,
              //       //     dob: dob!,
              //       //     farmingField: selectedField!.name,
              //       //     address: address,
              //       //     registrationDate: registrationDate,
              //       //     profileImagePath: imagePath // Pass the image URL
              //       //     );

              //       // // Close loading dialog
              //       // Navigator.pop(context);

              //       _formKeys[curentStep].currentState?.save();
              //       debugPrint('Form is valid and saved');
              //       debugPrint('Image URL: $imagePath');

              //       // Navigate to UserFormDetails with image URL
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (BuildContext context) => UserFormDetails(
              //                 lga: lga,
              //                 wardResidence: wardResidence,
              //                 age: age,
              //                 name: name,
              //                 gender: gender,
              //                 nin: nin,
              //                 farmingField: selectedField!.name,
              //                 address: address,
              //                 registrationDate: registrationDate,
              //                 phoneNumber: phoneNumber,
              //                 dob: dob!,
              //                 profileImageUrl:
              //                     imagePath, // Pass image URL to UserFormDetails
              //               )));
              //     } catch (e) {
              //       // Close loading dialog
              //       Navigator.pop(context);

              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text('Error saving data: $e')),
              //       );
              //       debugPrint('Error saving farmer data: $e');
              //     }
              //   }
              // }

              if (curentStep < getSteps().length - 1) {
                setState(() {
                  // if (_formKeys[currentStep].currentState!.validate() ==
                  //     false)
                  if (_validator() == false) {
                    return;
                  } else {
                    _formKeys[curentStep].currentState?.save();
                    curentStep += 1;
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
                  _formKeys[curentStep].currentState?.save();
                  curentStep = value;
                });
              }
            },
            onStepCancel: () {
              setState(() {
                if (curentStep > 0) {
                  curentStep -= 1;
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
                value: (widget.existingData != null) ? selectedGender : null,
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
          value: (widget.existingData != null) ? selectedLGA : null,
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
          value: (widget.existingData != null) ? selectedWard : null,
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
            print('This is the reg date: $registrationDate');
            registrationDate = value ?? '';
            print('This is the reg date: $registrationDate');
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget formScreen3() {
    return Column(
      children: [
        ImagePickerWidget(
            initialImage: _selectedImage,
            onImageSelected: (File? image) {
              setState(() {
                _selectedImage = image;
              });
              debugPrint('Image Selected: ${image?.path}');
            }),
        if (_selectedImage == null && curentStep == 2)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Please select a profile image',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 20),
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
          value: (widget.existingData != null) ? selectedField : null,
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
            state: curentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[0], child: formScreen1()),
            // content: FormScreen1(),
            isActive: curentStep >= 0),
        Step(
            state: curentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[1], child: formScreen2()),
            // content: FormScreen2(),
            isActive: curentStep >= 1),
        Step(
            state: curentStep >= 2 ? StepState.complete : StepState.indexed,
            title: const Text(''),
            content: Form(key: _formKeys[2], child: formScreen3()),
            isActive: curentStep >= 2),
      ];
}
