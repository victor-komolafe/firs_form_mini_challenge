// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginSignTextWidget extends StatefulWidget {
  
//   final String text;
//   // final Widget? child;

//   LoginSignTextWidget(
//       {super.key, required this.isSelected, required this.text});

//   @override
//   State<LoginSignTextWidget> createState() => _LoginSignTextWidgetState();
// }

// class _LoginSignTextWidgetState extends State<LoginSignTextWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return 
//       Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                       onPressed: isSelected,
//                       child: Text('Log in',
//                           style: GoogleFonts.poppins(
//                             color: theme.primaryColor,
//                             textStyle: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 decoration: TextDecoration.underline,
//                                 decorationThickness: 2,
//                                 decorationColor: Colors.blue),
//                           ))),
//                   Text('Sign UP',
//                       style: GoogleFonts.poppins(
//                         color: Colors.black12,
//                         textStyle: const TextStyle(
//                           fontSize: 20,
//                           // fontWeight: FontWeight.bold,
//                           // decoration: TextDecoration.underline,
//                           // decorationThickness: 2,
//                           // decorationColor: Colors.blue
//                         ),
//                       ))
//                 ],
//               ),
//     );
//   }
// }




// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     return TextButton(
// //         onPressed: () {
// //           isSelected = true;
         
// //         },
// //         child: Text(widget.text,
// //             style: widget.isSelected
// //                 ? GoogleFonts.poppins(
// //                     color: theme.primaryColor,
// //                     textStyle: const TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.bold,
// //                         decoration: TextDecoration.underline,
// //                         decorationThickness: 2,
// //                         decorationColor: Colors.blue),
// //                   )
// //                 : GoogleFonts.poppins(
// //                     color: Colors.black12,
// //                     textStyle: const TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.normal,
// //                         decoration: TextDecoration.none,
// //                         decorationThickness: 2,
// //                         decorationColor: Colors.blue),
// //                   )));
// //   }
// // }


// // Text('Login',
// //                           style: GoogleFonts.poppins(
// //                             color: theme.primaryColor,
// //                             textStyle: const TextStyle(
// //                                 fontSize: 20,
// //                                 fontWeight: FontWeight.bold,
// //                                 decoration: TextDecoration.underline,
// //                                 decorationThickness: 2,
// //                                 decorationColor: Colors.blue),
// //                           ))),