// import 'package:firs_mini_project/constants.dart';
// import 'package:flutter/material.dart';

// class PasswordTextWidget extends StatefulWidget {
//   final String? hintText;
//   final String formTitleText;
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final Icon? icon;
//   final bool showPassword;
//   final String? Function(String?)? validator;

//   const PasswordTextWidget(
//       {super.key,
//       this.icon,
//       this.showPassword = false,
//       required this.controller,
//       required this.formTitleText,
//       required this.hintText,
//       this.keyboardType = TextInputType.visiblePassword,
//       this.obscureText = false,
//       this.validator});

//   @override
//   State<PasswordTextWidget> createState() => _PasswordTextWidgetState();
// }

// class _PasswordTextWidgetState extends State<PasswordTextWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.formTitleText, style: ConstantFonts.inter),
//         TextFormField(
//             controller: widget.controller,
//             keyboardType: widget.keyboardType,
//             obscureText: showPassword == false ? true : false,
//             validator: (text) {
//               if (text!.isEmpty) {
//                 return 'Email cannot be empty';
//               } else {
//                 final regex = RegExp('[^@]+@[^.]+..+');
//                 if (!regex.hasMatch(text)) {
//                   return 'Enter a valid Password';
//                 }
//                 return null;
//               }
//             },
//             decoration: InputDecoration(
//               suffixIcon: InkWell(
//                   onTap: () {
//                     showPassword = !showPassword;
//                     setState(() {});
//                   },
//                   child: showPassword == false
//                       ? const Icon(
//                           Icons.visibility_off,
//                           color: Colors.black12,
//                         )
//                       : const Icon(
//                           Icons.visibility,
//                           color: Colors.black12,
//                         )),
//               errorBorder: Constants.globalOnErrorBorderStyle,
//               focusedBorder: Constants.globalOnSelectedBorderStyle,
//               focusedErrorBorder: Constants.globalOnErrorBorderStyle,
//               hintText: 'Enter your password',
//               enabledBorder: const OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Colors.black12),
//                   borderRadius: Constants.globalBorderRadius),
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//             ))
//       ],
//     );
//   }
// }






// //  TextFormField(
// //                       controller: _emailController,
// //                       keyboardType: TextInputType.emailAddress,
// //                       obscureText: showPassword == false ? true : false,
// //                       decoration: InputDecoration(
// //                         suffixIcon: InkWell(
// //                             onTap: () {
// //                               showPassword = !showPassword;
// //                               setState(() {});
// //                             },
// //                             child: showPassword == false
// //                                 ? const Icon(
// //                                     Icons.visibility_off,
// //                                     color: Colors.black12,
// //                                   )
// //                                 : const Icon(
// //                                     Icons.visibility,
// //                                     color: Colors.black12,
// //                                   )),
// //                         errorBorder: Constants.globalOnErrorBorderStyle,
// //                         focusedBorder: Constants.globalOnSelectedBorderStyle,
// //                         focusedErrorBorder: Constants.globalOnErrorBorderStyle,
// //                         hintText: 'Enter your password',
// //                         enabledBorder: const OutlineInputBorder(
// //                             borderSide:
// //                                 BorderSide(width: 1, color: Colors.black12),
// //                             borderRadius: Constants.globalBorderRadius),
// //                         contentPadding: const EdgeInsets.symmetric(
// //                             vertical: 20, horizontal: 20),

// //                         // label: Text('Your Email'),
// //                       ),
// //                       validator: (text) {
// //                         if (text!.isEmpty) {
// //                           return 'Email cannot be empty';
// //                         } else {
// //                           final regex = RegExp('[^@]+@[^.]+..+');
// //                           if (!regex.hasMatch(text)) {
// //                             return 'Enter a valid Password';
// //                           }
// //                           return null;
// //                         }
// //                       },
// //                     ),