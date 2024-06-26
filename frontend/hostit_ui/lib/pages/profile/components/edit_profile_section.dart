import 'package:flutter/material.dart';

Widget editProfileSection(void Function() onPressedFunction) {
  return Tooltip(
    message: "Edit profile",
    preferBelow: false,
    child: IconButton(
      onPressed: () {
        onPressedFunction();
      },
      icon: const Icon(Icons.settings),
    ),
  );
}
