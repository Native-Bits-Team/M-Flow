import 'package:flutter/material.dart';
import 'package:m_flow/components/tiles.dart';


class ProfileDrawerDashboard extends StatelessWidget {
  final void Function()? onProfileTap;

  const ProfileDrawerDashboard({
    super.key,
    required this.onProfileTap,
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
                icon: Icons.person, 
                text: 'profile',
                onTap: onProfileTap, // we'll be at Home anyway, so just pop!
              ),
            
              


              //-> **(go to lib/components/tiles.dart)**
            ],
          ),
        ],
      ),
    );
  }
}