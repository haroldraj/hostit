import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';

class ShowDialog {
  static void alertDialog(BuildContext context,
      {required String alertTitle,
      required String message,
      bool formValidation = false,
      Color color = CustomColors.primaryColor}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          alertTitle,
          style: TextStyle(color: color),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (formValidation) {
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  static void error(BuildContext context, String errorMessage) {
    alertDialog(context,
        alertTitle: "Error", message: errorMessage, color: Colors.red);
  }

  static void info(BuildContext context, String infoMessage) {
    alertDialog(context,
        alertTitle: "Info", message: infoMessage, color: Colors.blue);
  }
}
