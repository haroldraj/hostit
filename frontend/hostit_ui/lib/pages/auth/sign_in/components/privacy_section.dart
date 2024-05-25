import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget privacySection = RichText(
  text: TextSpan(
    children: [
      const TextSpan(text: "By signing in, you agree to our "),
      TextSpan(
        text: "Terms, ",
        style: const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () {},
      ),
      TextSpan(
        text: "Privacy Policy ",
        recognizer: TapGestureRecognizer()..onTap = () {},
        style: const TextStyle(color: Colors.blue),
      ),
      const TextSpan(text: "and "),
      TextSpan(
        text: "Cookie Use.",
        recognizer: TapGestureRecognizer()..onTap = () {},
        style: const TextStyle(color: Colors.blue),
      ),
    ],
  ),
);
