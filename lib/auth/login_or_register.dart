import 'package:flutter/material.dart';
import 'package:m_flow/auth/login_page.dart';
import 'package:m_flow/auth/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
 // initially show login page

 // Variable to toggle between showing login and register pages.
 bool showLogin = true;

 // Switch b/w login and register
 void Switchbw(){
  setState(() {
    showLogin = !showLogin;  // Toggles the boolean value to switch between login and register.
  });
 }

 
  @override
  Widget build(BuildContext context) {
    // Build method that returns either LoginPage or RegisterPage based on showLogin variable.
    if (showLogin){
      // If showLogin is true, return LoginPage.
      return LoginPage(
        onTap: Switchbw,
      ); // Passes switchBetweenPages method as onTap callback to LoginPage.
    }
    else {
      return RegisterPage(
        onTap: Switchbw, // Passes switchBetweenPages method as onTap callback to RegisterPage.
      );
    }
    //-> **(go to lib/auth/login_page.dart or register_page.dart)**
  }
}