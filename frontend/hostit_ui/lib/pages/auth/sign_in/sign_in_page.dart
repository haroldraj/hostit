// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/user_model.dart';
import 'package:hostit_ui/pages/auth/sign_in/components/divider.dart';
import 'package:hostit_ui/pages/auth/sign_in/components/logo_section.dart';
import 'package:hostit_ui/pages/auth/sign_in/components/privacy_section.dart';
import 'package:hostit_ui/pages/auth/sign_in/components/sign_up_section.dart';
import 'package:hostit_ui/pages/auth/sign_in/components/title_section.dart';
import 'package:hostit_ui/pages/auth/sign_up/sign_up_page.dart';
import 'package:hostit_ui/pages/main/main_menu_page.dart';
import 'package:hostit_ui/service/auth_service.dart';
import 'package:hostit_ui/widgets/custom_box_dialog.dart';
import 'package:hostit_ui/widgets/custom_text_form_field.dart';
import 'package:hostit_ui/widgets/password_form_field.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final fomrKey = GlobalKey<FormState>();

    Future<void> onLogInPressed() async {
      try {
        if (fomrKey.currentState!.validate()) {
          debugPrint("Loging in");
          User user = User(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          final errorMessage = await AuthService().logIn(user);
          if (errorMessage.isEmpty) {
            Future.delayed(
              const Duration(seconds: 0),
              () {
                goTo(context, const MainMenu(), isReplaced: true);
              },
            );
          } else {
            Future.delayed(
              const Duration(seconds: 0),
              () {
                ShowDialog.error(context, errorMessage);
              },
            );
          }
        }
      } catch (error) {
        debugPrint("Error $error");
      }
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(child: Container()),
              Card(
                color: CustomColors.cardBgColor,
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  height: 900,
                  width: 700,
                  child: Column(
                    children: [
                      logoSection,
                      titleSection(),
                      const SizedBox(height: 100),
                      Form(
                        key: fomrKey,
                        child: Column(children: [
                          textFormField(
                            "Username",
                            "Please enter your username",
                            emailController,
                            //isAnEmail: true,
                          ),
                          PasswordFormField(
                            labelText: "Password",
                            textToFill: "Please enter your password",
                            fieldController: passwordController,
                          ),
                        ]),
                      ),
                      Spacing.vertical,
                      Spacing.vertical,
                      OutlinedButton(
                        onPressed: () {
                          onLogInPressed();
                        },
                        child: const SizedBox(
                          width: double.maxFinite,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Sign In ",
                              style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Spacing.vertical,
                      signupSection(() {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const SignUpPage(),
                        );
                      }),
                      const SizedBox(height: 10),
                      divider,
                      const SizedBox(height: 10),
                      //const GoogleButton(),
                      //const MicrosoftButton(),
                      const SizedBox(height: 25),
                      privacySection,
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
