import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyType;
  final bool isPassword;
  final String? Function(String?)? valid;

  const CustomTextForm({
    super.key,
    required this.hint,
    required this.controller,
    required this.keyType,
    required this.isPassword,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: TextFormField(
        validator: valid,
        controller: controller,
        keyboardType: keyType,
        obscureText: isPassword,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.yellow[200],
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 0.5),
          ),
        ),
      ),
    );
  }
}
