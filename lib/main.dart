import 'package:flutter/material.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/form_page.dart';
import 'package:m_flow/pages/settings.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// TODO: change resolution
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FormPage(initText: ""),
      // Theme for our entire app can be set from here...
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
      ),
    );
  }
}
