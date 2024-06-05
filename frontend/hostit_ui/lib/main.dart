import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:hostit_ui/app.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GRecaptchaV3.ready("6Lee8vApAAAAAHfMFk5RyULEzIYWwcy17axfc2zR");
  runApp(const HostitApp());
}
/*
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    bool ready = await GRecaptchaV3.ready(
        "6Lee8vApAAAAAHfMFk5RyULEzIYWwcy17axfc2zR",
        showBadge: true); //--2
    // ignore: avoid_print
    print("Is Recaptcha ready? $ready");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = 'Click the below button to generate token';
  bool badgeVisible = true;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getToken() async {
    String token = await GRecaptchaV3.execute('submit') ?? 'null returned';
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recaptcha V3 Web example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SelectableText('Token: $_token\n'),
              ElevatedButton(
                onPressed: getToken,
                child: const Text('Get new token'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  if (badgeVisible) {
                    GRecaptchaV3.hideBadge();
                  } else {
                    GRecaptchaV3.showBadge();
                  }
                  badgeVisible = !badgeVisible;
                },
                icon: const Icon(Icons.legend_toggle),
                label: const Text("Toggle Badge Visibilty"),
              ),
              TextButton.icon(
                  label: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(
                        text: "https://pub.dev/packages/g_recaptcha_v3"));
                  },
                  icon: const SelectableText(
                      "https://pub.dev/packages/g_recaptcha_v3")),
            ],
          ),
        ),
      ),
    );
  }
}
*/