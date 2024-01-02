import 'package:flutter/material.dart';

class CustomBotton extends StatelessWidget {
  final String txt;
  final Color color;
  final Color txtColor;
  final void Function() pressed;
  const CustomBotton(
      {super.key,
      required this.txt,
      required this.color,
      required this.pressed,
      required this.txtColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: color,
        onPressed: pressed,
        child: Text(
          txt,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: txtColor,
          ),
        ),
      ),
    );
  }
}
