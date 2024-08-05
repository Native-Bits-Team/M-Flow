
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/form_page.dart';
//import 'package:m_flow/pages/form_page.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  // [TRANSPARENCY] Learned from Usage part of windowManager Documentation | A
  WidgetsFlutterBinding();
  windowManager.ensureInitialized();
  var winOp =
      const WindowOptions(size: Size(1360, 900), center: true, title: "M-Flow");

  windowManager.waitUntilReadyToShow(winOp, () async {
    await windowManager.show();
    await windowManager.focus();

    //await windowManager.setIcon("icon.ico"); // Used ImageToIcon to generate this .ico file

    //await windowManager.setProgressBar(0.1);
    //await windowManager.setPreventClose(true);
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
    //print("size");
    //windowManager.setSize(Size(1920,1920)).onError((error,s){print(error);print(s);}); // [TRANSPARENCY] I have confirmed the source of this is variable is the dependency itself

    /*Timer(Duration(seconds: 3),(){

    windowManager.setTitle("M-Flow");
    windowManager.focus();
    windowManager.setFullScreen(true); // TODO: This doesn't work
    print("done");
    });
    print("size done");*/
    //Color firstColor = theme["firstColor"];
    //TextStyle textStyle = const TextStyle();
    globalAppHandler = this;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const DashBoard(),
        //const FormPage(
          //  initText: "Test TEST TEST", initTitle: "Test"),
        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          drawerTheme: DrawerThemeData(
              backgroundColor: Color(HexColor(theme["backgroundColor"]).value),
              shape: const ContinuousRectangleBorder()),
          //iconTheme: IconThemeData(color: Color(HexColor(theme["backgroundColor"]).value)),
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54)),
              border: const OutlineInputBorder(),
              //hintStyle: TextStyle(color: Colors.white38),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(HexColor(theme["firstColor"]).value)))),

          appBarTheme: AppBarTheme(
              centerTitle: true,
              toolbarHeight: 40,
              backgroundColor: Color(HexColor(theme["backgroundColor"]).value),
              titleTextStyle: TextStyle(
                  color: Color(HexColor(theme["firstColor"]).value),
                  fontSize: 20)),

          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                  iconColor: WidgetStatePropertyAll(
                      Color(HexColor(theme["firstColor"]).value)))),

          cardTheme: CardTheme(
              color: Color(HexColor(theme["backgroundColor"]).value),
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 3.0),
          listTileTheme: ListTileThemeData(
              iconColor: Color(HexColor(theme["firstColor"]).value)),
          scaffoldBackgroundColor:
              Color(HexColor(theme["pageBackgroundColor"]).value),
          dialogBackgroundColor:
              Color(HexColor(theme["pageBackgroundColor"]).value),
          dialogTheme:
              const DialogTheme(titleTextStyle: TextStyle(color: Colors.white)),
          //textTheme: Typography.blackMountainView, // Got the idea from TextTheme and its copyWith() details
          textTheme: typographySwitcher(int.parse(theme["typography"])),
          hintColor: Color(HexColor(theme["firstColor"]).value).withAlpha(80),
          //primaryTextTheme: typographySwitcher(int.parse(theme["typography"])),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 19.0, horizontal: 16.0)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
            elevation: const WidgetStatePropertyAll(2.0),
            shadowColor: const WidgetStatePropertyAll(Colors.black),
            //backgroundColor: WidgetStatePropertyAll(Color(HexColor(theme["backgroundColor"]).value)),
            backgroundColor: WidgetStatePropertyAll(
                Color(HexColor(theme["backgroundColor"]).value)),
            iconColor: WidgetStatePropertyAll(
                Color(HexColor(theme["firstColor"]).value)),
            textStyle: WidgetStatePropertyAll(TextStyle(
                color: Color(HexColor(theme["firstColor"]).value),
                fontWeight: FontWeight.bold)),
            side: WidgetStatePropertyAll(BorderSide(
                color: Color(HexColor(theme["firstColor"]).value), width: 1.0)),
          )),
        ));
  }
}

typographySwitcher(int index) {
  switch (index) {
    case 0:
      return Typography.blackHelsinki;
    case 1:
      return Typography.whiteHelsinki;
    default:
      return Typography.whiteHelsinki;
  }
}
