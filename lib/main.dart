import 'package:flutter/material.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/form_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    initDatabaseAndThemes();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const FormPage(initText: "",),
      home: DashBoard(),
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      iconTheme: const IconThemeData(color: Colors.white70),
      iconButtonTheme: const IconButtonThemeData(style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white60)))
      )
    );
  }
}
