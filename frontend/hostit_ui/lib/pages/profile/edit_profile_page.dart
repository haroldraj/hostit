import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/user_model.dart';
import 'package:hostit_ui/pages/profile/enable_2fa_page.dart';
import 'package:hostit_ui/service/user_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    User user = UserService().getUserDetails();

    void close() {
      Navigator.pop(context);
    }

    return AlertDialog(
      title: const Center(
        child: Text(
          "Profile details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            close();
          },
          child: const Text(
            "Close",
            style: TextStyle(fontSize: 20)
          ),
        ),
      ],
      //backgroundColor: Colors.white,
      content: SizedBox(
        width: 500,
        height: 150,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Username: ", style: TextStyle(fontSize: 20)),
                  Text(user.name!, style: const TextStyle(fontSize: 20))
                ],
              ),
              Spacing.vertical,
              Row(
                children: [
                  const Text("Email: ", style: TextStyle(fontSize: 20)),
                  Text(user.email!, style: const TextStyle(fontSize: 20))
                ],
              ),
              Spacing.vertical,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  user.twoFactorEnabled!
                      ? const Text("2FA is enabled",
                          style: TextStyle(fontSize: 20))
                      : const Text("2FA is not enabled",
                          style: TextStyle(fontSize: 20)),
                  !user.twoFactorEnabled!
                      ? TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Enable2FAPage(),
                            );
                          },
                          child: const Text(
                            'Enable 2FA',
                            style: TextStyle(fontSize: 20)
                          ))
                      : TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Disable 2FA',
                            style: TextStyle(fontSize: 20)
                          )),
                ],
              ),
              Spacing.vertical,
              Spacing.vertical,
            ],
          ),
        ),
      ),
    );
  }
}
