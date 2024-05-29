import 'package:flutter/material.dart';
import 'package:hostit_ui/pages/auth/sign_in/sign_in_page.dart';
import 'package:hostit_ui/pages/main/main_menu_page.dart';
import 'package:hostit_ui/service/auth_service.dart';

class HostitApp extends StatefulWidget {
  const HostitApp({super.key});

  @override
  State<HostitApp> createState() => _HostitAppState();
}

class _HostitAppState extends State<HostitApp> {
  late bool _isTokenValid;

  @override
  void initState() {
    super.initState();
    _isTokenValid = AuthService().isTokenValid();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOSTIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const MainMenu() //_isTokenValid ? const MainMenu() : const SignInPage(),
    );
  }
}


