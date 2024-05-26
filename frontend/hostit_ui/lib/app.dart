import 'package:flutter/material.dart';
import 'package:hostit_ui/pages/auth/sign_in/sign_in_page.dart';

class HostitApp extends StatelessWidget {
  const HostitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOSTIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInPage(),
    );
  }
}


