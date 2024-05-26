import 'package:flutter/material.dart';

Widget divider = const Row(
  children: [
    Expanded(
      child: Divider(
        color: Colors.grey,
      ),
    ),
    SizedBox(width: 10),
    Text("or"),
    SizedBox(width: 10),
    Expanded(
      child: Divider(
        color: Colors.grey,
      ),
    ),
  ],
);
