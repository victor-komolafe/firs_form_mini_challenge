import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Constants {
  static TextStyle get onAppBarSelectedStlye => GoogleFonts.poppins(
      color: Colors.blue,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      decorationColor: Colors.blue);

  static TextStyle get onAppBarUnSelectedStyle => GoogleFonts.poppins(
        color: Colors.black12,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
      );

  static const BorderRadius globalBorderRadius =
      BorderRadius.all(Radius.circular(12));

  static const BorderSide globalBorderSide =
      BorderSide(width: 1, color: Colors.black12);

  static const globalOnSelectedBorderStyle = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Colors.blue),
    borderRadius: globalBorderRadius,
  );

  static const globalOnErrorBorderStyle = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Colors.red),
    borderRadius: globalBorderRadius,
  );

  static const globalFormBorderStyle = OutlineInputBorder(
    borderSide: globalBorderSide,
    borderRadius: globalBorderRadius,
  );

  static const globalContentPadding =
      EdgeInsets.symmetric(vertical: 20, horizontal: 20);
}

class ConstantFonts {
  static TextStyle get inter =>
      GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16);
}

class ConstantColors {
  // static const Color primaryColor = Colors.white;
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.black;
  static const Color errorColor = Colors.red;
}

enum Genders { male, female }

enum LGA { amac, abaji, garki, abia }

enum WardResidence { abj, lagos, abia }
