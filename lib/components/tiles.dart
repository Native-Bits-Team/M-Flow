import 'package:flutter/material.dart';

// tiles are used in the profile-drawer...
class Tiles extends StatelessWidget {
  final IconData icon;
  final String text;
  void Function()? onTap;

  Tiles({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: ListTile(
        leading: Icon(
          icon,
          //color: Colors.white,
        ),
        onTap: onTap,
        title: Text(text, maxLines: 1,
        style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}