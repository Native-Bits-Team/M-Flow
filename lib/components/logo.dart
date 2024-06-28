import 'package:flutter/material.dart';


class LogoTile extends StatelessWidget {
  final String imagePath;

  const LogoTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12)
      ),
      
      child: Image.asset(imagePath, height: 40,),
    );
  }
}