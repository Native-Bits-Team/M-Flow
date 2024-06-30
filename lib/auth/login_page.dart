// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/components/my_button.dart'; // Custom button widget.
import 'package:m_flow/components/my_textfield.dart'; // Custom textfield widget.
import 'package:m_flow/components/logo.dart'; // Custom logo widget.
import 'package:m_flow/pages/dashboard.dart'; 

class LoginPage extends StatefulWidget {
  final Function()? onTap; // Callback function to switch to registration page.

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers 
  final emailController = TextEditingController(); // Controller for email textfield.
  final passwordController = TextEditingController(); // Controller for password textfield.

  // sign user in
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // try to sing-in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
      );
      // Check if the widget is still mounted before dismissing the dialog
      if (mounted) {
        Navigator.pop(context); 
      }

    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions.

      // Check if the widget is still mounted before dismissing the dialog
      if (mounted) {
        Navigator.pop(context); 
      }

      // print(e.code);
      
      // Display appropriate error message based on the error code.
      if (e.code == 'invalid-email') {
        invalidCredentialMsg('Invalid Email!'); // Show invalid email error message.
      } 
      
      else if (e.code == 'unknown-error') {
        invalidCredentialMsg('Invalid Credentials!'); // Show unknown error message.
      }
    }

  }

  // invalid credentials message
  void invalidCredentialMsg(String message) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 193, 227, 244),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
            side: BorderSide(color: Colors.white, width: 2.0),
          ),
          title: Center(
            child: Text(message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
          ),
        );
      }
    );
  }

  // Anonymous sign in method
  void joinAsGuest() async {
    // show loading circle
    showDialog(
      context: context,
      // barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    try {
      await FirebaseAuth.instance.signInAnonymously();

      // Dismiss the loading indicator after successful sign-in
      if (mounted) {
        Navigator.pop(context);
      }

      // Navigate to dashboard
      Navigator.push(context, MaterialPageRoute(builder: (context) => const DashBoard()));

    } on FirebaseAuthException catch (e) {

      // Dismiss the loading indicator after an error
      Navigator.pop(context);

      print('error: $e');
      invalidCredentialMsg('Failed to sign in anonymously!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Positioned the Floating Action Button (FAB) at the top right corner
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          width: 110,
          height: 50, 
          child: FloatingActionButton.extended(
            onPressed: joinAsGuest,

            backgroundColor: Colors.blue.shade200, // Background color of FAB
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners for the FAB
            ),
            label: Text('Join as a Guest'), // Text label for the FAB
          ),
        ),
      ),

      // OnPressed implementation requires Above...

      backgroundColor: Colors.blue[100],
      // safearea: makes the UI avoid any h/w distractions...
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,), // Spacer.
              
                  // logo
                  const Icon(Icons.verified_user, size: 100,),
              
                  const SizedBox(height: 30,), // Spacer.
              
                  // welcome back, you've been missed!
                  Text(
                    'Hey there! Welcome back...',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
              
                  const SizedBox(height: 30,), // Spacer.
              
                  // email textfield
                  MyTextfield(
                    controller: emailController, 
                    hintText: 'Email', 
                    obscureText: false
                  ),
              
                  const SizedBox(height: 25,), // Spacer.
              
                  // password textfield
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
              
                  //-> **(go to lib/components/my_textfield.dart)**
                              
                  const SizedBox(height: 19,), // Spacer.
              
                  // forgot password?
                  Text('forgot password?',
                  style: TextStyle(color: Colors.grey[600]),
                  ),
              
                  const SizedBox(height: 20,), // Spacer.
              
                  // sign in button
                  MyButton(
                    text: 'sign in',
                    onTap: signUserIn, // Call signUserIn function on tap.
                  ),
                  //-> **(go to lib/components/my_button.dart)**
              
                  const SizedBox(height: 10,), // Spacer.
              
                  // or continue with
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
              
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),),
                      ),
              
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      )
                    ],
                  ),
              
                  const SizedBox(height: 20,),
              
                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      LogoTile(imagePath: 'lib/images/google.png'),
                    ],
                  ),
              
                  const SizedBox(height: 20,),
              
                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?',
                      style: TextStyle(color: Colors.grey[700]),),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap, // Call onTap callback to switch to registration page.
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                                    
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}