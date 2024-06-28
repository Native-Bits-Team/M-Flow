import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  Function()? onTap;
  final String text;

  MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        padding: const EdgeInsets.all(1.0),
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8)
          ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,),
          ),
        ),
      ),
    );
  }
}