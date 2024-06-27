



import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/form_page.dart';
import 'package:screenshot/screenshot.dart';



class DashBoard extends StatelessWidget{
  const DashBoard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(30.0), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch ,children: [Card(child: Padding(padding: EdgeInsets.all(30.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        TextButton.icon(icon: Icon(Icons.add), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black12)),onPressed: (){
          FilePicker fP = FilePicker.platform;
          fP.pickFiles(dialogTitle: "Open Document", initialDirectory: "~/", type: FileType.custom, allowedExtensions: ["md"]).then((result){
            if (result!.files[0].path == ""){
              return;
            }
            File(result.files[0].path as String).readAsString().then((data){
Navigator.push(context, MaterialPageRoute(builder: (context){
        return FormPage(initText: data);
      }));
            });
            
          });
        },
         label: const Text("Open Document")),
        SizedBox(height: 20),
        TextButton.icon(icon: Icon(Icons.add), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black12)),onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context){
        //addNewValue("projects", {"projectName": "Unknown", "filePath" : "README.md"});
        return FormPage(initText: "");
      }));

        }, label: const Text("New Document"))

        
        
        ]))), SizedBox(height: 30),
        Expanded(child: ProjectGrid())]))
    );
  }
}


class DocPreview extends StatefulWidget {
  DocPreview({super.key, projectPath, projectName});
  String projectPath = "";
  String projectName = "Unknown";
  @override
  State<DocPreview> createState() => _DocPreviewState();
}

class _DocPreviewState extends State<DocPreview> {
  Image? previewImageBytes;
  String test = ""; // This is temporary
  @override
  Widget build(BuildContext context) {
   // print("build");
   // print(widget.projectPath);

    if (previewImageBytes == null && widget.projectPath != ""){
    ScreenshotController sController = ScreenshotController();
    File(widget.projectPath).readAsString().then((text){
    test = text;
    sController.captureFromWidget(MarkdownBody(data: text)).then((data){
        setState(() {
          previewImageBytes = Image.memory(data, alignment: Alignment.topCenter, filterQuality: FilterQuality.none);
        });
    });
    
    });
    }
    //return FilledButton(onPressed: () {print("test");}, child: Card(child: previewImageBytes,));
    // Add pins
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(child: MaterialButton(onLongPress: () {

      
      showMenu(context: context, position: const RelativeRect.fromLTRB(10.0, 10.0, 30.0, 30.0), items: [PopupMenuItem(onTap: (){
        
      },child: const Text("Delete"))]);
      
    },onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return FormPage(initText: test);
      }));
    }, color: Colors.white, child: previewImageBytes)), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(widget.projectName), IconButton(onPressed: () {}, icon: const Icon(Icons.settings))])]);
    
  }
}


class ProjectGrid extends StatefulWidget {

  ProjectGrid({super.key});
  List<String> pathPreview = [];
  List<String> namePreview = [];
  int previewLength = 0; // temporarly

  @override
  State<ProjectGrid> createState() => _ProjectGridState();
}

class _ProjectGridState extends State<ProjectGrid> {
  final SliverGridDelegate gridDelegateRef = const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.65, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0);

  @override
  Widget build(BuildContext context) {
          List<String> pathPreviewTemp = [];
          List<String> namePreviewTemp = [];

    if (widget.previewLength == 0){

    File("test.json").readAsString().then((onValue){
      
      var d = jsonDecode(onValue) as Map<String, dynamic>;
      int size = d["projects"].length;
      widget.previewLength = size;
      for (int k=0; k < size; ++k){
                pathPreviewTemp.add(d["projects"][k.toString()]["filePath"]);
                namePreviewTemp.add(d["projects"][k.toString()]["projectName"]);

    }
    setState(() {
                widget.pathPreview.addAll(pathPreviewTemp);
                widget.namePreview.addAll(namePreviewTemp);

    });
    });
    
    }
    //print(widget.pathPreview.first.projectPath);
    List<DocPreview> childPreview = [];
    for (int j = 0 ; j < widget.pathPreview.length; ++j){
      childPreview.add(DocPreview());
      childPreview[j].projectPath = widget.pathPreview[j];
      childPreview[j].projectName = widget.namePreview[j];
    }

    return GridView(gridDelegate: gridDelegateRef, children: childPreview);
  }
}