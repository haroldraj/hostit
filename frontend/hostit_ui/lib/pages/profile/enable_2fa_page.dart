// ignore_for_file: use_build_context_synchronously, avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/custom_box_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

class Enable2FAPage extends StatefulWidget {
  const Enable2FAPage({super.key});

  @override
  State<Enable2FAPage> createState() => _Enable2FAPageState();
}

class _Enable2FAPageState extends State<Enable2FAPage> {
  String? _qrCodeImage;
  String url = '${UrlConfig.baseAuthUrl}/enable-2fa';
  String username = UserService().getUsername();
  final TextEditingController codeEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> onVerifyCodePressed() async {
    try {
      final response = await http.post(
        Uri.parse('${UrlConfig.baseAuthUrl}/verify-2fa'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': UserService().getUsername(),
          'code': codeEditingController.text,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("verified");
        final jsonResponse = json.decode(response.body);
        String authToken = jsonResponse['token'];
        html.window.localStorage['authToken'] = authToken;
        Future.delayed(
          const Duration(seconds: 0),
          () {
            ShowDialog.info(context, "2FA has been activated");
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
        
      } else {
        // Handle 2FA verification
      }
    } catch (error) {
      debugPrint("Error $error");
    }
  }

  Future<void> enable2FA() async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _qrCodeImage = response.body;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    enable2FA();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 400,
        height: 400,
        child: _qrCodeImage == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(base64Decode(_qrCodeImage!)),
                  const SizedBox(height: 20),
                  const Text(
                    'Scan this QR code with your 2FA app',
                    style: TextStyle(fontSize: 17),
                  ),
                  Spacing.vertical,
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: codeEditingController,
                      decoration: const InputDecoration(
                        hintText: "XXXXXX",
                        labelText: "Enter the code from the authenticator app",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the code from the authenticator app";
                        }
                        return null;
                      },
                    ),
                  ),
                  Spacing.vertical,
                  TextButton(
                    onPressed: () {
                      onVerifyCodePressed();
                    },
                    child: const Text(
                      "Verify",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
