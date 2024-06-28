import 'package:flutter/material.dart';
import 'package:m_flow/components/tiles.dart';

class ProfileDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onLogoutTap;

  ProfileDrawer({
    super.key,
    required this.onProfileTap,
    required this.onLogoutTap,

  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.lightBlue.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer head
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              
              // Tile -> Lists
              // Home Tile
              Tiles(
                icon: Icons.home, 
                text: 'Home',
                onTap: ()=> Navigator.pop(context), // we'll be at Home anyway, so just pop!
              ),
              
              // PROFILE Tile
              
              Tiles(
                icon: Icons.person, 
                text: 'Profile', 
                onTap: onProfileTap,
              ),

              //-> **(go to lib/components/tiles.dart)**
            ],
          ),

          // Logout Tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Tiles(
              icon: Icons.logout, 
              text: 'logout', 
              onTap: onLogoutTap,
            ),
          ),


        ],
      ),
    );
  }
}

