// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  static TextStyle defaultTextColor = const TextStyle(color: Colors.white54);

  static TextStyle titleStyle = GoogleFonts.roboto(
    fontSize: 50,
    fontWeight: FontWeight.w400,
  );

  static TextStyle signInUpStyle({Color textColor = Colors.white}) {
    return GoogleFonts.roboto(
      color: textColor,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
  }
}
