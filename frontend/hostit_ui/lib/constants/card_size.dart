import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/screen_size.dart';
import 'package:hostit_ui/responsive.dart';

class CardSize {
  static double width(BuildContext context) => !Responsive.isMobile(context)
      ? ScreenSize.width(context) / 3.5
      : ScreenSize.width(context) / 1.1;
  static double height = 270;
  static double headerHeight = 50;
}
