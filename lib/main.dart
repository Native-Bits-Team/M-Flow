import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/form_page.dart';
import 'package:m_flow/pages/information.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    initDatabaseAndThemes();
    Map<String, dynamic> theme = getTheme();
        //Color firstColor = theme["firstColor"];

    //TextStyle textStyle = const TextStyle();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashBoard(),
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      iconTheme: const IconThemeData(color: Colors.white70),
      iconButtonTheme: const IconButtonThemeData(style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white60))),
      cardTheme: CardTheme(color: Color(HexColor(theme["backgroundColor"]).value)),
      scaffoldBackgroundColor: Color(HexColor(theme["pageBackgroundColor"]).value),

      textButtonTheme: const TextButtonThemeData(style : ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
        iconColor: WidgetStatePropertyAll(Colors.blue),
        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // Invalid Constant Error
        overlayColor: WidgetStatePropertyAll(Colors.blueAccent),
        side: WidgetStatePropertyAll(BorderSide(color: Colors.blueAccent, width: 2.0))
        )
        
        ),
      )
    );
  }
}
