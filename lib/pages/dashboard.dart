



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:m_flow/pages/form_page.dart';
import 'package:screenshot/screenshot.dart';


class DashBoard extends StatelessWidget{
  const DashBoard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(30.0), child: Column(children: [Expanded(child: Card(child: TextButton.icon(onPressed: (){}, label: const Text("New Document")))),
        const Expanded(child: ProjectGrid())]))
    );
  }
}


class DocPreview extends StatefulWidget {
  const DocPreview({super.key});

  @override
  State<DocPreview> createState() => _DocPreviewState();
}

class _DocPreviewState extends State<DocPreview> {
  Image? previewImageBytes;
  String test = ""; // This is temporary
  @override
  Widget build(BuildContext context) {
    if (previewImageBytes == null){
    ScreenshotController sController = ScreenshotController();
    File("test.md").readAsString().then((text){
    test = text;
    sController.captureFromWidget(MarkdownBody(data: text)).then((data){
        setState(() {
          previewImageBytes = Image.memory(data, alignment: Alignment.topCenter);
        });
    });
    
    });
    }
    //return FilledButton(onPressed: () {print("test");}, child: Card(child: previewImageBytes,));
    // Add pins
    return Column(children: [Expanded(child: MaterialButton(onLongPress: () {

      
      showMenu(context: context, position: const RelativeRect.fromLTRB(10.0, 10.0, 30.0, 30.0), items: [PopupMenuItem(child: TextButton.icon(icon: const Icon(Icons.delete),onPressed: (){}, label: const Text("Delete"), style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.redAccent)),))]);
      
    },onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return FormPage(initText: test);
      }));
    }, color: Colors.white, child: previewImageBytes)), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Project #1"), IconButton(onPressed: () {}, icon: const Icon(Icons.settings))])]);
    
  }
}


class ProjectGrid extends StatelessWidget {
  final SliverGridDelegate gridDelegateRef = const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.65, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0);

  const ProjectGrid({super.key});
  @override
  Widget build(BuildContext context) {
    List<DocPreview> projPreview = [];
    for (int i=0; i < 10; ++i){
      projPreview.add(const DocPreview());
    }
    return GridView(gridDelegate: gridDelegateRef, children: projPreview);
  }
}