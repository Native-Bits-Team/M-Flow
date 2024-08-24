
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding();
  windowManager.ensureInitialized();
  var winOp =
      const WindowOptions(
        minimumSize: Size(1000, 700),
        size: Size(1360, 900), center: true, title: "M-Flow");

  windowManager.waitUntilReadyToShow(winOp, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

// IMPORTANT: Turning the MyApp into statefulWidget might/may cause a preformance issues? TODO: confirm or deny this

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

_MyAppState? globalAppHandler;

class _MyAppState extends State<MyApp> {
  late Map<String, dynamic> theme;

  updateGlobalAppTheme() {
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
    globalAppHandler = this;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const DashBoard(),
        theme: ThemeData(
          cardColor: Color(HexColor(theme["pageBackgroundColor"]).value),
          colorScheme: colorSchemeSwitcher(theme["type"]),
          //floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.red),
          //menuButtonTheme: MenuButtonThemeData(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red))),
          /*navigationDrawerTheme: NavigationDrawerThemeData(
            backgroundColor: Colors.red,
            iconTheme: WidgetStatePropertyAll(IconThemeData(color: Colors.red)),
            indicatorShape: CircleBorder()),*/
         
          drawerTheme: DrawerThemeData(
              backgroundColor: Color(HexColor(theme["backgroundColor"]).value),
              shape: const ContinuousRectangleBorder(),
              //elevation: 10.0,
              ),
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54)),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(HexColor(theme["firstColor"]).value)))),
          appBarTheme: AppBarTheme(
              centerTitle: true,
              toolbarHeight: 40,
              backgroundColor: Color(HexColor(theme["secondColor"]).value), // REF #TT
              titleTextStyle: TextStyle(
                  color: Color(HexColor(theme["firstColor"]).value),
                  fontSize: 20)),

          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                //splashFactory: ,
                //backgroundColor: 
                //surfaceTintColor: 
                //mouseCursor: 
                overlayColor: 
                WidgetStatePropertyAll(Color(HexColor(theme["forthColor"]).value)), // [T] below
                  iconColor: WidgetStatePropertyAll(
                      Color(HexColor(theme["thirdColor"]).value)))),

          iconTheme: IconThemeData(color: Color(HexColor(theme["forthColor"]).value)), // [T] REF #TT

          cardTheme: CardTheme(
              color: Color(HexColor(theme["secondColor"]).value),
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 3.0),
          
          listTileTheme: ListTileThemeData(
              iconColor: Color(HexColor(theme["thirdColor"]).value)),
          
          scaffoldBackgroundColor:
              Color(HexColor(theme["backgroundColor"]).value),
          dialogBackgroundColor:
              Color(HexColor(theme["pageBackgroundColor"]).value),
          dialogTheme:
              const DialogTheme(titleTextStyle: TextStyle(color: Colors.white)),
          textTheme: typographySwitcher(int.parse(theme["typography"])),
          hintColor: Color(HexColor(theme["firstColor"]).value).withAlpha(80),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 19.0, horizontal: 16.0)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
            elevation: const WidgetStatePropertyAll(2.0),
            shadowColor: const WidgetStatePropertyAll(Colors.black),
            backgroundColor: WidgetStatePropertyAll(
                Color(HexColor(theme["backgroundColor"]).value)),
            iconColor: WidgetStatePropertyAll(
                Color(HexColor(theme["thirdColor"]).value)),
            textStyle: WidgetStatePropertyAll(TextStyle(
                color: Color(HexColor(theme["firstColor"]).value),
                fontWeight: FontWeight.bold)),
            side: WidgetStatePropertyAll(BorderSide(
                color: Color(HexColor(theme["firstColor"]).value), width: 1.0)),
          )),
        ));
  }
}

typographySwitcher(int? index) {
  if (index == null){
    return Typography.whiteHelsinki;
  }
  switch (index) {
    case 0:
      return Typography.blackHelsinki;
    case 1:
      return Typography.whiteHelsinki;
    default:
      return Typography.whiteHelsinki;
  }
}


colorSchemeSwitcher(String? type){
  if (type == null){
    return const ColorScheme.dark();
  }
  if (type == "dark"){
    return const ColorScheme.dark();
  }
  if (type == 'light'){
    return const ColorScheme.light();
  }
}