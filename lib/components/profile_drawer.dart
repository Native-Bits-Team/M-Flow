import 'package:flutter/material.dart';
import 'package:m_flow/components/tiles.dart';

class ProfileDrawer extends StatelessWidget {
  final void Function()? onExportTap;
  final void Function()? onIceTap;
  final void Function()? onDashTap;
  final void Function()? onGitTap;

  ProfileDrawer({
    super.key,
    required this.onExportTap,
    required this.onIceTap,
    required this.onDashTap,
    required this.onGitTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 5, 24, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer head
          Column(
            children: [
              const DrawerHeader(
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
                text: 'Dashboard',
                onTap: onDashTap, // we'll be at Home anyway, so just pop!
              ),
            
              // Export Tile
              
              Tiles(
                icon: Icons.save, 
                text: 'Export', 
                onTap: onExportTap,
              ),

              // Export Tile
              
              Tiles(
                icon: Icons.icecream, 
                text: 'Appereances', 
                onTap: onIceTap,
              ),

              // Export Tile
              
              Tiles(
                icon: Icons.remove_circle_outline_sharp, 
                text: 'Github Themes', 
                onTap: onGitTap,
              ),


              //-> **(go to lib/components/tiles.dart)**
            ],
          ),
        ],
      ),
    );
  }
}