import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m_flow/components/tiles.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/dashboard.dart';

class ProfileDrawer extends StatelessWidget {
  final void Function()? onSettingsTap;
  //final void Function()? onIceTap;
  final void Function()? onDashTap;
  //final void Function()? onGitTap;

  ProfileDrawer({
    super.key,
    required this.onSettingsTap,
   // required this.onIceTap,
    required this.onDashTap,
   // required this.onGitTap,
  });

  @override
  Widget build(BuildContext context) {

    List<Widget> mostRecents = [];
    List<List<String>> result = getMostRecentOpens();
    int index = 0;
    for (var value in result[1]) {
      if (File(value).existsSync()){
        mostRecents.add(TilesIndexed(result[1][index],context,icon: Icons.edit_document,text: result[0][index], onTap: (){},));
      }
      index+=1;
    }    
    List<Widget> children = [
const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              Tiles(
                icon: Icons.home, 
                text: 'Dashboard',
                onTap: onDashTap, // we'll be at Home anyway, so just pop!
              ),
              Tiles(
                icon: Icons.settings, 
                text: 'Settings', 
                onTap: onSettingsTap,
              ),
              const SizedBox(height: 5,),
              const Text("Most Recent")
    ];

    children.addAll(mostRecents);
    return Drawer(
     // backgroundColor: const Color.fromARGB(255, 5, 24, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer head
          Column(
            children: children
          ),
        ],
      ),
    );
  }
}


class TilesIndexed extends Tiles{ // TODO: maybe there is a better solution
  TilesIndexed(this.path, BuildContext this.context, {required super.icon, required super.text, required super.onTap});
  final String path;
  final BuildContext context;

  @override
  // TODO: implement onTap
  void Function()? get onTap => () {
   // loadFormPage(context, path,);
};
}