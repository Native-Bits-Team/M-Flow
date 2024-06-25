



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:m_flow/pages/form_page.dart';
import 'package:screenshot/screenshot.dart';


class DashBoard extends StatelessWidget{
  SliverGridDelegate gridDelegateRef = SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.65, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(30.0), child: Column(children: [Expanded(child: GridView(gridDelegate: gridDelegateRef, children: [DocPreview(),DocPreview(),DocPreview()]))]))
    );
  }
}


class DocPreview extends StatefulWidget {
  @override
  State<DocPreview> createState() => _DocPreviewState();
}

class _DocPreviewState extends State<DocPreview> {
  Image? previewImageBytes = null;
  String Test = ""; // This is temporary
  @override
  Widget build(BuildContext context) {
    if (previewImageBytes == null){
    ScreenshotController sController = ScreenshotController();
    File("test.md").readAsString().then((text){
    Test = text;
    sController.captureFromWidget(MarkdownBody(data: text)).then((data){
        setState(() {
          previewImageBytes = Image.memory(data, alignment: Alignment.topCenter);
        });
    });
    
    });
    }
    //return FilledButton(onPressed: () {print("test");}, child: Card(child: previewImageBytes,));
    return Column(children: [Expanded(child: MaterialButton(onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return FormPage(initText: Test);
      }));
    },child: previewImageBytes, color: Colors.white)), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Project #1"), IconButton(onPressed: () {}, icon: Icon(Icons.settings))])]);
    
  }
}