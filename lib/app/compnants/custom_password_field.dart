import 'package:flutter/material.dart';

import '../../constant/app_color.dart';

class CustomPassowrdField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyType;

  final String? Function(String?)? valid;

  const CustomPassowrdField(
      {super.key,
      required this.hint,
      required this.controller,
      required this.keyType,
      this.valid});

  @override
  State<CustomPassowrdField> createState() => _CustomPassowrdFieldState();
}

class _CustomPassowrdFieldState extends State<CustomPassowrdField> {
  bool _isObscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.valid,
      controller: widget.controller,
      keyboardType: widget.keyType,
      obscureText: _isObscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _isObscureText ? Icons.visibility : Icons.visibility_off,
            color: iconsColor,
          ),
          onPressed: () {
            setState(() {
              _isObscureText = !_isObscureText;
            });
          },
        ),
        filled: true,
        fillColor: appBackgroundColor!,
        hintText: widget.hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
    );
  }
}
