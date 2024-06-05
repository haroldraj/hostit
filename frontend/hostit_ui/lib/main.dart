import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:hostit_ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GRecaptchaV3.ready("6Lee8vApAAAAAHfMFk5RyULEzIYWwcy17axfc2zR");
  runApp(const HostitApp());
}
