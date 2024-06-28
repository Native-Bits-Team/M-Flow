import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/components/my_button.dart';
import 'package:m_flow/components/my_textfield.dart';
import 'package:m_flow/components/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers 
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user in
  void RegUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // prevents closing dialog by tapping outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // Ensuring that passwords match...
    if (passwordController.text != confirmPasswordController.text) {
      // pop navigator(circular loader)
      Navigator.pop(context);

      // show error to user
      invalidCredentialMsg('Passwords don\'t match!');
      return;
    }

    // try to register
    try {
      
      // create a User
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );

      // Create a document for the user in Firestore under 'Users' collection...
      FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.email).set({
        'username': emailController.text.split('@')[0],
        'bio': 'Empty bio...' // Default bio
      }); 
      // pop the loading circle
      if (context.mounted) Navigator.pop(context);


    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      
      // Handle different error codes and show appropriate messages
      if (e.code == 'invalid-email') {
        invalidCredentialMsg('Invalid Email!');
      } else if (e.code == 'weak-password') {
        invalidCredentialMsg('Password is too weak!');
      } else if (e.code == 'email-already-in-use') {
        invalidCredentialMsg('Email is already in use!');
      } else {
        invalidCredentialMsg('An unknown error occurred!');
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
            child: Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    );
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
            onPressed: () {
              // Action when FAB is pressed
            },
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
              
                  // logo
                  const Icon(Icons.verified_user, size: 100),
              
                  const SizedBox(height: 30),
              
                  // welcome message
                  Text(
                    'Let\'s get your account started...',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
              
                  const SizedBox(height: 30),
              
                  // email textfield
                  MyTextfield(
                    controller: emailController, 
                    hintText: 'Email', 
                    obscureText: false
                  ),
              
                  const SizedBox(height: 25),
              
                  // password textfield
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
              
                  const SizedBox(height: 19),
              
                  // confirm password textfield
                  MyTextfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  //-> **(go to lib/components/my_textfield.dart)**
              
              
                  const SizedBox(height: 20),
              
                  // register button
                  MyButton(
                    text: 'Register',
                    onTap: RegUserIn,
                  ),
                  //-> **(go to lib/components/my_button.dart)**
              
                  const SizedBox(height: 10),
              
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
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
              
                  const SizedBox(height: 20),
              
                  // google sign in button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      LogoTile(imagePath: 'lib/images/google.png'),
                    ],
                  ),
              
                  const SizedBox(height: 20),
              
                  // already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Log-in',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
