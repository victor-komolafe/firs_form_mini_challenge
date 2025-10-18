import 'package:firs_mini_project/constants.dart';
import 'package:flutter/material.dart';

class MyDropdownFormWidget<T> extends StatelessWidget {
  const MyDropdownFormWidget({
    super.key,
    required this.formTitleText,
    this.titleTextStyle,
    this.value,
    this.validator,
    this.autovalidateMode,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.itemLabelBuilder,
  });

  final String formTitleText;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? titleTextStyle;
  final T? value;
  final List<T> items;
  final String? Function(T?)? validator; // Add validator
  final String hintText; // Hint text for the dropdown
  final ValueChanged<T?> onChanged; // Callback for when the value changes
  final String Function(T)? itemLabelBuilder; // Function to build item labels

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formTitleText, style: titleTextStyle ?? ConstantFonts.inter),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            errorBorder: Constants.globalOnErrorBorderStyle,
            focusedBorder: Constants.globalOnSelectedBorderStyle,
            focusedErrorBorder: Constants.globalOnErrorBorderStyle,
            enabledBorder: Constants.globalFormBorderStyle,
            hintText: hintText,
            helperText: ' ',
            border: Constants.globalOnSelectedBorderStyle,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabelBuilder!(item)), // Use the label builder
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: (autovalidateMode != null)
              ? autovalidateMode
              : AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}

// DropdownButtonFormField<Genders>(
//                   value: selectedGender,
//                   decoration:
//                       const InputDecoration(hintText: 'Choose an Option'),
//                   items: Genders.values.map((e) {
//                     return DropdownMenuItem<Genders>(
//                       value: e,
//                       child: Text(e.name),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     selectedGender = value!;
//                   }),