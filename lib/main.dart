import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/dashboard.dart';

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
      home: const DashBoard(),
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      iconTheme: const IconThemeData(color: Colors.white70),
      inputDecorationTheme: const InputDecorationTheme(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      border: OutlineInputBorder(),
      hintStyle: TextStyle(color: Colors.white38),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue))),

appBarTheme: AppBarTheme(titleTextStyle: const TextStyle(color: Colors.white),centerTitle: true, toolbarHeight: 40, backgroundColor: Color(HexColor(theme["backgroundColor"]).value)),
      iconButtonTheme: const IconButtonThemeData(style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white60))),
      cardTheme: CardTheme(color: Color(HexColor(theme["backgroundColor"]).value)),
      scaffoldBackgroundColor: Color(HexColor(theme["pageBackgroundColor"]).value),
      dialogBackgroundColor: Color(HexColor(theme["pageBackgroundColor"]).value),
      dialogTheme: const DialogTheme(titleTextStyle: TextStyle(color: Colors.white)),// Invalid Constant Error
      textTheme: Typography.englishLike2021, // Got the idea from TextTheme details
      textButtonTheme: const TextButtonThemeData(style : ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),// Invalid Constant Error
        iconColor: WidgetStatePropertyAll(Colors.white60),// Invalid Constant Error
        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // Invalid Constant Error
        side: WidgetStatePropertyAll(BorderSide(color: Colors.blueAccent, width: 2.0)),// Invalid Constant Error
        )
        
        ),
      )
    );
  }
}
