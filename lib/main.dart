import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core for initializing Firebase services.
import 'package:m_flow/auth/check_auth.dart'; // Import CheckAuth widget for handling authentication status.
import 'package:m_flow/firebase_options.dart'; // Import Firebase options (assuming it contains specific configuration).

// import 'package:m_flow/pages/dashboard.dart';
// import 'package:m_flow/auth/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter widgets are initialized.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase with platform-specific options.
  );
  runApp(const MyApp()); // Start the Flutter application with MyApp as the root widget.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckAuth(), // Set CheckAuth widget as the home screen of the app -> **(go to lib/auth/check_auth.dart)**
      // home: DashBoard(),
    );
  }
}