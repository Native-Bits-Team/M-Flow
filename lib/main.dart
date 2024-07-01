import 'package:flutter/material.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/form_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormPage(initText: ""),

      // Theme for our entire app can be set from here...
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
      ),
    );
  }
}
