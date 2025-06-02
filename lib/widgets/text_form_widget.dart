import 'package:firs_mini_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String formTitleText;
  final TextStyle? titleTextStyle;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;

  final Icon? icon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.formTitleText,
    required this.hintText,
    this.titleTextStyle,
    this.onSaved,
    this.inputFormatters,
    this.keyboardType = TextInputType.emailAddress,
    this.obscureText = false,
    this.validator,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formTitleText, style: titleTextStyle ?? ConstantFonts.inter),
        TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            onSaved: onSaved,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              errorBorder: Constants.globalOnErrorBorderStyle,
              focusedBorder: Constants.globalOnSelectedBorderStyle,
              focusedErrorBorder: Constants.globalOnErrorBorderStyle,
              hintText: hintText,
              enabledBorder: Constants.globalFormBorderStyle,
            )),
      ],
    );
  }
}


//  TextFormField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       obscureText: showPassword == false ? true : false,
//                       decoration: InputDecoration(
//                         suffixIcon: InkWell(
//                             onTap: () {
//                               showPassword = !showPassword;
//                               setState(() {});
//                             },
//                             child: showPassword == false
//                                 ? const Icon(
//                                     Icons.visibility_off,
//                                     color: Colors.black12,
//                                   )
//                                 : const Icon(
//                                     Icons.visibility,
//                                     color: Colors.black12,
//                                   )),
//                         errorBorder: Constants.globalOnErrorBorderStyle,
//                         focusedBorder: Constants.globalOnSelectedBorderStyle,
//                         focusedErrorBorder: Constants.globalOnErrorBorderStyle,
//                         hintText: 'Enter your password',
//                         enabledBorder: const OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 1, color: Colors.black12),
//                             borderRadius: Constants.globalBorderRadius),
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 20, horizontal: 20),

//                         // label: Text('Your Email'),
//                       ),
//                       validator: (text) {
//                         if (text!.isEmpty) {
//                           return 'Email cannot be empty';
//                         } else {
//                           final regex = RegExp('[^@]+@[^.]+..+');
//                           if (!regex.hasMatch(text)) {
//                             return 'Enter a valid Password';
//                           }
//                           return null;
//                         }
//                       },
//                     ),