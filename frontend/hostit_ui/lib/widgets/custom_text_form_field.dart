import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/regex.dart';

Widget textFormField(String labelText, TextEditingController fieldController,
    {bool isAnEmail = false}) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: TextFormField(
      controller: fieldController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the $labelText";
        }
        if (isAnEmail && !Regex.emailRegex.hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
    ),
  );
}

Widget textFormFieldUnderline(
  String suffixText,
  String textToFill,
  IconData prefixIcon,
  TextEditingController fieldController,
) {
  return TextFormField(
    controller: fieldController,
    decoration: InputDecoration(
      suffixText: suffixText,
      focusColor: CustomColors.orangeColor,
      prefixIcon: Icon(
        prefixIcon,
        color: CustomColors.orangeColor,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: CustomColors.orangeColor),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return textToFill;
      }
      return null;
    },
  );
}
