import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/helpers.dart';

Widget customCircularProgressIndicator(String action) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
            //color: CustomColor.orangeColor,
            ),
        Spacing.horizontal,
        Text(
          action,
          style: const TextStyle(color: Colors.black),
        )
      ],
    );
