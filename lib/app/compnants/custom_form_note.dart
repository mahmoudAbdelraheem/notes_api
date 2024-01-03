import 'package:flutter/material.dart';
import 'package:notes_api/constant/app_color.dart';

// ignore: must_be_immutable
class CustomFormNote extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyType;
  final bool isPassword;
  final String? Function(String?)? valid;
  int? minLine;
  int? maxLine;
  String? hint;
  CustomFormNote({
    super.key,
    required this.controller,
    required this.keyType,
    required this.isPassword,
    required this.valid,
    this.minLine,
    this.maxLine,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: TextFormField(
        minLines: minLine,
        maxLines: maxLine,
        validator: valid,
        controller: controller,
        keyboardType: keyType,
        obscureText: isPassword,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          filled: true,
          fillColor: appBackgroundColor,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
