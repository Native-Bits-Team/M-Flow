import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/form_page.dart';

void main() => runApp(const MyApp());

// IMPORTANT: Turning the MyApp into statefulWidget might/may cause a preformance issues? TODO: confirm or deny this

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


_MyAppState? globalAppHandler;

class _MyAppState extends State<MyApp> {
  late Map<String, dynamic> theme;

  updateGlobalAppTheme(){
    setState(() {
      theme = getTheme();
    });
  }
  @override
  void initState() {
    super.initState();
    initDatabaseAndThemes();
    theme = getTheme();
  }
  

  @override
  Widget build(BuildContext context) {
    //Color firstColor = theme["firstColor"];
    //TextStyle textStyle = const TextStyle();
    globalAppHandler = this;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FormPage(initText: "Test", fileData: {"title": "test"}),
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      //iconTheme: IconThemeData(color: Color(HexColor(theme["backgroundColor"]).value)),
      inputDecorationTheme: const InputDecorationTheme(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      border: OutlineInputBorder(),
      //hintStyle: TextStyle(color: Colors.white38),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue))),

      appBarTheme: AppBarTheme(centerTitle: true, toolbarHeight: 40, backgroundColor: Color(HexColor(theme["backgroundColor"]).value), titleTextStyle: TextStyle(color: Color(HexColor(theme["firstColor"]).value), fontSize: 20)),

      iconButtonTheme: IconButtonThemeData(style: ButtonStyle(iconColor: WidgetStatePropertyAll(Color(HexColor(theme["firstColor"]).value)))),
      
      cardTheme: CardTheme(color: Color(HexColor(theme["backgroundColor"]).value),
      shadowColor: Colors.black,
      elevation: 3.0),

      scaffoldBackgroundColor: Color(HexColor(theme["pageBackgroundColor"]).value),
      dialogBackgroundColor: Color(HexColor(theme["pageBackgroundColor"]).value),
      dialogTheme: const DialogTheme(titleTextStyle: TextStyle(color: Colors.white)),// Invalid Constant Error
      //textTheme: Typography.blackMountainView, // Got the idea from TextTheme and its copyWith() details
      textTheme: typographySwitcher(int.parse(theme["typography"])),
      //primaryTextTheme: typographySwitcher(int.parse(theme["typography"])),
      textButtonTheme: TextButtonThemeData(style : ButtonStyle(
        elevation: WidgetStatePropertyAll(2.0),
        shadowColor: WidgetStatePropertyAll(Colors.black),
        //backgroundColor: WidgetStatePropertyAll(Color(HexColor(theme["backgroundColor"]).value)),// Invalid Constant Error
        backgroundColor: WidgetStatePropertyAll(Color(HexColor(theme["backgroundColor"]).value)),
        iconColor: WidgetStatePropertyAll(Color(HexColor(theme["firstColor"]).value)),
        textStyle: WidgetStatePropertyAll(TextStyle(color: Color(HexColor(theme["firstColor"]).value), fontWeight: FontWeight.bold)), // Invalid Constant Error
        side: WidgetStatePropertyAll(BorderSide(color: Color(HexColor(theme["firstColor"]).value), width: 1.0)),// Invalid Constant Error
        )
        
        ),
      )
    );
  }
}


typographySwitcher(int index){
  switch (index) {
    case 0:
      return Typography.blackHelsinki;
    case 1:
      return Typography.whiteHelsinki;
    default: return Typography.whiteHelsinki;
  }
}