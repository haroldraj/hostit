
import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/regex.dart';

class PasswordFormField extends StatefulWidget {
  final String labelText;
  final String textToFill;
  final TextEditingController fieldController;
  final bool isToRegister;
  const PasswordFormField(
      {super.key,
      required this.labelText,
      required this.textToFill,
      required this.fieldController,
      this.isToRegister = false});

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: widget.fieldController,
        decoration: InputDecoration(
          suffix: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility 
                  : Icons.visibility_off
            ),
            onPressed: () {
              _toggle();
            },
          ),
          border: const OutlineInputBorder(),
          labelText: widget.labelText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.textToFill;
          }
          if (widget.isToRegister && !Regex.passwordRegex.hasMatch(value)) {
            return 'Password must contain at least 8 characters, one number, and one special character.';
          }
          return null;
        },
        obscureText: _obscureText,
      ),
    );
  }
}
