import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/auth/login_or_register.dart';
import 'package:m_flow/auth/login_page.dart';
import 'package:m_flow/pages/dashboard.dart';

class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides a basic structure for the page.
    return Scaffold(
      // StreamBuilder listens for changes in authentication state.
      body: StreamBuilder<User?>(
        // constantly listening to auth state changes...
        stream: FirebaseAuth.instance.authStateChanges(),  // Stream for Firebase Authentication state changes.
        builder: (context, snapshot) {
          // Builder function to build UI based on authentication state snapshot.

          // user already logged
          if (snapshot.hasData){
            return DashBoard();  //-> **(go to lib/pages/dashboard.dart)**
          }

          // user is not logged
          else {
            return LoginOrRegister();  //-> **(go to lib/auth/login_or_register.dart)**
          }
        },
      ),
    );
  }
}