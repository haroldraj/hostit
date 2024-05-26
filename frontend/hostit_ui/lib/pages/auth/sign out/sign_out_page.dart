
import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/pages/auth/sign_in/sign_in_page.dart';
import 'package:hostit_ui/service/auth_service.dart';

class SignOutPage {
  static void confirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          "Confirmation",
          style: TextStyle(color: CustomColors.redColor),
        ),
        content: const Text("Do you really want to Log out ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService().logout();
              goTo(context, const SignInPage(), isReplaced: true);
            },
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }
}
