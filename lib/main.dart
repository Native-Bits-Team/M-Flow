import 'package:flutter/material.dart';
void main() {
  runApp(const MainApp());
}



Widget InputToMarkdown(){
  String test = "MarkDown Document";
  String test_2 = "This is a Test Markdown Document that will be used to design the software !";

  Widget conWidget = Scaffold(
    body: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(test, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
    Text(test_2, style: TextStyle(fontSize: 20.0))
    ]),
  );


  return conWidget;
}


class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "M-Flow Markdown Document Writer",
      home: Scaffold(
        body: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [SizedBox(width: 500,child: SizedBox(width:500, height: 700, child: InputPanel()))
        ,SizedBox(width: 500,child: SizedBox(width:500, height: 700, child: PreviewPanel()))])
        ),
    );
  }
}


class InputPanel extends StatefulWidget {
  const InputPanel({super.key});
  @override
  State<InputPanel> createState() => _InputPanelState();
}

class _InputPanelState extends State<InputPanel> {
  TextEditingController tcontroller = TextEditingController();
  FocusNode tfocusnode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Card.outlined(shadowColor: Colors.grey, elevation: 1.0, 
    child: Padding(padding: const EdgeInsets.all(10.0), child: EditableText(maxLines: 30, controller: tcontroller, focusNode: tfocusnode, style: const TextStyle(color: Colors.black),cursorColor: const Color.fromARGB(255, 104, 75, 75), backgroundCursorColor: const Color.fromARGB(255, 119, 20, 20))
));
    }
}



class PreviewPanel extends StatefulWidget {
  const PreviewPanel({super.key});
  @override
  State<PreviewPanel> createState() => _PreviewPanelState();
}

class _PreviewPanelState extends State<PreviewPanel> {
  TextEditingController tcontroller = TextEditingController();
  FocusNode tfocusnode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Card.outlined(shadowColor: Colors.grey, elevation: 1.0, 
    child: Padding(padding: const EdgeInsets.all(10.0), child: InputToMarkdown()),
);
    }
}