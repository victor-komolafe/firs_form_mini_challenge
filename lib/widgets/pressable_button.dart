import 'package:firs_mini_project/constants.dart';
import 'package:flutter/material.dart';

class PressableButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  const PressableButton(
      {this.icon,
      required this.text,
      required this.onPressed,
      this.color,
      this.textColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            margin: EdgeInsets.zero,
            // padding: EdgeInsets.zero,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: color ?? Colors.blue,
                borderRadius: Constants.globalBorderRadius),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: ConstantFonts.inter
                      .copyWith(color: textColor ?? Colors.white),
                ),
              ],
            )));
  }
}

// InkWell(
//                       onTap: _validate,
//                       child: Container(
//                           alignment: Alignment.center,
//                           padding: const EdgeInsets.symmetric(vertical: 18),
//                           width: double.infinity,
//                           decoration: const BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: Constants.globalBorderRadius),
//                           child: Text(
//                             'Continue',
//                             style: ConstantFonts.inter
//                                 .copyWith(color: Colors.white),
//                           )),