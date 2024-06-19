import 'package:flutter/material.dart';
import 'package:hostit_ui/service/user_service.dart';

class WelcomingTextWidget extends StatelessWidget {
  const WelcomingTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Center(
        child: Text(
          'Welcome to Hostit, ${UserService().getUsername()}',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
