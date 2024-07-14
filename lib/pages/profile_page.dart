import 'package:flutter/material.dart';
import 'package:m_flow/components/info_block.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Local user data
  String username = "User's Name";
  String bio = "User's bio";

  // Edit the username & bio
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Edit ' + field,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // save
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    // Update local data if there is a new value
    if (newValue.trim().isNotEmpty) {
      setState(() {
        if (field == 'username') {
          username = newValue;
        } else if (field == 'bio') {
          bio = newValue;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color.fromARGB(255, 5, 24, 32),
      ),
      backgroundColor: Color.fromARGB(255, 7, 39, 53),
      body: Center(
        child: SizedBox(
          width: 600,
          child: ListView(
            children: [
              const SizedBox(height: 50,),
              
              // profile picture
              const Icon(
                Icons.person,
                size: 80,
              ),
              
              const SizedBox(height: 10,),

              // user email
              SizedBox(
                width: 100,
                child: Text(
                  "user@example.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10,),

              // user details
              InfoBlock(
                text: username,
                sectionName: 'username',
                onPressed: () => editField('username'),
              ),

              // bio
              InfoBlock(
                text: bio,
                sectionName: 'bio',
                onPressed: () => editField('bio'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
