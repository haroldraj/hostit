import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget signupSection(void Function() onTapFunction) {
  return Tooltip(
    message: "Create a new account",
    preferBelow: false,
    child: Center(
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              semanticsLabel: "test",
              text: " Sign up",
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onTapFunction();
                },
            ),
          ],
        ),
      ),
    ),
  );
}
