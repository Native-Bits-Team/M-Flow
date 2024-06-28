import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/components/info_block.dart';
import 'package:m_flow/dependencies/md2pdf.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Users->All
  final usersColl = FirebaseFirestore.instance.collection("Users");

  // Edit the username & bio
  Future<void> editField(String field) async{
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
          onChanged: (value){
            newValue = value;
          }),
          actions: [
            // cancel
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('cancel',
              style: TextStyle(color: Colors.white),),
            ),


            // save
            TextButton(
              onPressed: () => Navigator.of(context).pop(newValue), 
              child: Text('save',
              style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );

      // update the firestore database, if only there is a new value...
      if (newValue.trim().length > 0) {
        await usersColl.doc(currentUser.email).update({field: newValue});
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''),
      backgroundColor: Colors.lightBlue.shade100,
      ),
      backgroundColor: Colors.lightBlue[50],

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
        .collection("Users").doc(currentUser.email)
        .snapshots(),
        builder: (context, snapshot) {
          // fetch user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Center(
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
                        currentUser.email!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700],
                        fontSize: 25, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 10,),

                    // user details
                    
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 25,),
                    //   child: Text(
                    //     'My Details',
                    //     style: TextStyle(color: Colors.grey[600]),
                    //   ),
                    // ),
                          
                    // user name
                    InfoBlock(
                      text: userData['username'], 
                      sectionName: 'username',
                      onPressed: ()=> editField('username'),
                    ),
                
                    // bio
                    InfoBlock(
                      text: userData['bio'], 
                      sectionName: 'bio',
                      onPressed: ()=> editField('bio'),
                    ),

                    //-> **(go to lib/components/info_block.dart)**
                           
                  ],
                ),
              ),
            ); //
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}