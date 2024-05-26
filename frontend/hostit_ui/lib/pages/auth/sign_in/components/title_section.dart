import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_text_style.dart';

Widget titleSection({String title = "Welcome back"}) {
  return Row(
    children: [
      Expanded(
        child: Center(
          child: Text(
            title,
            style: CustomTextStyle.titleStyle,
          ),
        ),
      )
    ],
  );
}
