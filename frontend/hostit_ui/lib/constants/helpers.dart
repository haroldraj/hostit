import 'package:flutter/material.dart';

void goTo(BuildContext context, Widget page, {bool isReplaced = false}) {
  isReplaced
      ? Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => page))
      : Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => page));
}

void goBackTo(BuildContext context) {
  Navigator.pop(context);
}

const defaultPadding = 16.0;

class Spacing {
  static const SizedBox vertical = SizedBox(height: 15);
  static const SizedBox horizontal = SizedBox(width: 15);
}
