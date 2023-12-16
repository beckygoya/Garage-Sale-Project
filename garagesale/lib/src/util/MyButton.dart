import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;
  final double width = 225.0;

  const MyButton(
      {Key? key,
        required this.color,
        required this.text,
        required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: SizedBox(
        width: width,
        height: 45.0,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
