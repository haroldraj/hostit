import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/user_model.dart';
import 'package:hostit_ui/service/auth_service.dart';
import 'package:hostit_ui/widgets/custom_box_dialog.dart';
import 'package:hostit_ui/widgets/custom_text_form_field.dart';
import 'package:hostit_ui/widgets/password_form_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordConfirmationController =
        TextEditingController();
    final formKey = GlobalKey<FormState>();

    void onSignupPressed() async {
      try {
        if (formKey.currentState!.validate()) {
          if (passwordConfirmationController.text.trim() !=
              passwordController.text.trim()) {
            Future.delayed(
              const Duration(seconds: 0),
              () {
                ShowDialog.error(
                    context, "Please make sure your password match");
              },
            );
          } else {
            debugPrint("Signing Up");
            User user = User(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
            user.name = nameController.text.trim();
            final errorMessage = await AuthService().signUp(user);
            if (errorMessage.isEmpty) {
              Future.delayed(
                const Duration(seconds: 0),
                () {
                  ShowDialog.alertDialog(context,
                      alertTitle: "Success",
                      message: "You can now login to your account",
                      formValidation: true);
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
        }
      } catch (error) {
        debugPrint("Error:$error");
      }
    }

    void close() {
      Navigator.pop(context);
    }

    return AlertDialog(
      title: const Center(
        child: Text(
          "Create your new account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      //backgroundColor: Colors.white,
      content: SizedBox(
        width: 500,
        height: 500,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textFormField(
                "Name",
                nameController,
              ),
              textFormField(
                "Email address",
                emailController,
                isAnEmail: true,
              ),
              PasswordFormField(
                labelText: "Password",
                textToFill: "Please enter your password",
                fieldController: passwordController,
                isToRegister: true,
              ),
              PasswordFormField(
                labelText: "Password confirmation",
                textToFill: "Please enter your password again",
                fieldController: passwordConfirmationController,
                isToRegister: true,
              ),
              Spacing.vertical,
              Spacing.vertical,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      close();
                    },
                    child: const Text(
                      "Cancel ",
                      style: TextStyle(
                        color: CustomColors.redColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacing.horizontal,
                  OutlinedButton(
                    onPressed: () {
                      onSignupPressed();
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: CustomColors.orangeColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
