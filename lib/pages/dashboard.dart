import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/code_src/style_sheet.dart';
import 'package:m_flow/dependencies/md2pdf/md2pdf.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/form_page.dart';
import 'package:m_flow/pages/information.dart';
import 'package:m_flow/pages/settings.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("M-Flow"),
          //backgroundColor: const Color.fromARGB(255, 5, 24, 32),
        ),

        // *DRAWER : -------------------------------------------------------------------------------- *
     /*   Imad: The main page doesn't really need a drawer, most things are already shown
     drawer: ProfileDrawerDashboard(
          onProfileTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
        ),*/
        // *DRAWER : -------------------------------------------------------------------------------- *

        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                      child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        FilePicker fP = FilePicker.platform;
                                        fP.pickFiles(
                                            dialogTitle: "Open Document",
                                            initialDirectory: "~/",
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              "md",
                                              "mflow"
                                            ]).then((result) {
                                              if (result == null){
                                                return;
                                              }
                                          if (result.files.first.path == "") {
                                            return;
                                          }
                                          addRecentOpen(result.files.first.path,
                                              result.files[0].name);
                                          if (result.files.first.extension ==
                                              "mflow") {
                                            loadMFlowFile(
                                                    result.files.first.path)
                                                .then((data) {
                                              if (data == null) {
                                                //print("ERROR");
                                                return;
                                              }
                                          //    if (data["title"] == null ||
                                            //      data["title"] == "") {
                                              //  data["title"] =
                                                //    result.files.first.name;
                                              //}
                                              if (data["content"] == null){
                                                //print("Error");
                                              }
                                              //data["mflow"] = true;
                                           //   data["filePath"] = result.files.first.path;
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return FormPage(
                                                  initText: data["content"],
                                                  //File(result.files[0]
                                                    //      .path as String)
                                                      //.readAsStringSync(),
                                                  //fileData: data,
                                                  initTitle: data["title"] == "" || data["title"] == null ? result.files.first.name : data["title"],
                                                  initPath: result.files.first.path,
                                                );
                                              }));
                                            });
                                          } else {
                                            loadFormPage(context, result.files.first.path!,false, title: result.files.first.name);
                                           /* Navigator.push(context,MaterialPageRoute(builder: (context) {
                                              return FormPage(
                                                initText: File(result.files[0]
                                                        .path as String)
                                                    .readAsStringSync(),
                                                fileData: {
                                                  "title":
                                                      result.files.first.name
                                                },
                                              );
                                            }));*/
                                          }
                                        });
                                      },
                                      label: const Text("Open Document")),
                                  const SizedBox(height: 20),
                                  TextButton.icon(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          //addNewValue("projects", {"projectName": "Unknown", "filePath" : "README.md"});
                                          return const FormPage(
                                            initText: "",
                                            initTitle: "M-Flow",
                                          );
                                        }));
                                      },
                                      label: const Text("New Document"))
                                ]),
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 // Spacer(),
                                  /*TextButton.icon(
                                      style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.blueGrey), backgroundColor: WidgetStatePropertyAll(Colors.grey)),
                                      label: const Text("NOT WORKING: Load From URL"),
                                      icon: const Icon(Icons.error),
                                      onPressed: () {}),*/
                                SizedBox(height: 20),
                                /*TextButton.icon(
                                      style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.blueGrey), backgroundColor: WidgetStatePropertyAll(Colors.grey)),
                                      label: const Text("NOT WORKING: Load From Template"),
                                      icon: const Icon(Icons.error),
                                      onPressed: () {}),*/
                                ]),
                               // const SizedBox.expand(child: Text("e"),),
                                Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                      label: const Text("Settings"),
                                      icon: const Icon(Icons.settings),
                                      onPressed: () {
                                      Navigator.push(context,MaterialPageRoute(builder: (context) {return const SettingsPanel();}));
                                      }),
                                      const SizedBox(height: 20),
                                  TextButton.icon(
                                      label: const Text("Info"),
                                      icon: const Icon(Icons.info),
                                      onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context) {return const InfoPage();}));
                                      })
                                ])
                          ]))),
                  const SizedBox(height: 32),
                  const Text("Recent Documents", textScaler: TextScaler.linear(1.5),),
                  const SizedBox(height: 16),

                  Expanded(child: ProjectGrid())
                ])));
  }
}

class DocPreview extends StatefulWidget {
  const DocPreview(
      {super.key,
      required this.projectPath,
      required this.projectName,
      required this.parentHandle});
  final String projectPath;
  final String projectName;
  final _ProjectGridState parentHandle; // TODO: Should be removed
  @override
  State<DocPreview> createState() => _DocPreviewState();
}

class _DocPreviewState extends State<DocPreview> {
  Widget? previewImageBytes;
  String test = ""; // This is temporary
  bool enabled = true;
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    updatePreview();
  }
  void updatePreview({bool force = false}){
    if ((previewImageBytes == null && widget.projectPath != "") || force) {
      //ScreenshotController sController = ScreenshotController();
      var file = File(widget.projectPath);
      if (!file.existsSync()) {
        enabled =false;
        // TODO: Maybe there is an alternative that doesn't use File object
        previewImageBytes = const Tooltip(
            message: "File Not Found",
            child: Icon(Icons.info, color: Colors.red));
      } else {
      if (_debounce?.isActive ?? false){
        _debounce!.cancel(); // Credits to NBT member Madhur for this code
      }
      _debounce = Timer(const Duration(milliseconds: 200), () {
        // This was added to remove lag when switching to the dashbaord, this isn't a permenent solution, as all previews will
        // update at the same time, a better solution would be to make preview update one by one, or in a spread thread, etc...
        // TODO: Implment a better solution

        file.readAsString().then((text) {
          test = text;
          // TODO: Wrong way of handling opening and closing a file?
          if (text.startsWith("mflow")) {
            Map<String, dynamic> data = jsonDecode(text.substring(10));
            test = data["content"];
            generatePdfImageFromMD(
                    data["content"], buildMarkdownStyle(1.0, tempTheme: data["theme"]),
                    tempTheme: data["theme"])
                .then((imageAndSize) {
              setState(() {
                previewImageBytes = imageAndSize[0];
              });
            });
          } else {
            generatePdfImageFromMD(text, MarkdownStyleSheet(),
                    tempTheme: "mflow")
                .then((imageAndSize) {
              setState(() {
                previewImageBytes = imageAndSize[0];
              });
            });
          }

          //sController.captureFromWidget(MarkdownBody(data: text)).then((data){
          //setState(() {
          //previewImageBytes = Image.memory(data, alignment: Alignment.topCenter, filterQuality: FilterQuality.none);
          //});
          //});
        });
      });}
    }
  }
void checkPreviewInfo(){
  if (widget.projectPath != "" && previewImageBytes.runtimeType == Tooltip && File(widget.projectPath).existsSync()){
    previewImageBytes = const CircularProgressIndicator();
    updatePreview(force: true);
  }
}
  @override
  Widget build(BuildContext context) {
  checkPreviewInfo(); // TODO: This method removes a RecentOpen and then regenerate all DocPreviews, a better solution would to just delete the most recent then the button of it
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
          child: MaterialButton(
        hoverElevation: 0.2,
        elevation: 0.1,
        padding: EdgeInsets.zero,
        onLongPress: () { // TODO: make it right click
          showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(10, 10, 10, 10), // TODO: mouse position
              items: [
                PopupMenuItem(
                    onTap: () {
                      removeRecentOpen(widget.projectPath, widget.projectName);//.then(() {
                      widget.parentHandle.updatePreviews(); // TODO: Replace this method
                      // dispose();
                      
                    //  });
                    },
                    child: const Text("Delete"))
              ]);
        },
        onPressed: () {
          if (!enabled){return;}
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return FormPage(
              initText: test,
              initTitle: widget.projectName,
              initPath : widget.projectPath,
            );
          }));
        },
        color: Colors.transparent,
        child: previewImageBytes,
      )),
      const SizedBox(height: 5),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(widget.projectName),
        // IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
      ])
    ]);
  }
}

class ProjectGrid extends StatefulWidget {
  ProjectGrid({super.key});
  List<String> pathPreview = [];
  List<String> namePreview = [];
  bool init = false;

  @override
  State<ProjectGrid> createState() => _ProjectGridState();
}

class _ProjectGridState extends State<ProjectGrid> {
  final SliverGridDelegate gridDelegateRef =
      const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.65,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0);
  @override
  void initState() {
    super.initState();
    updatePreviews();
  }
  @override
  Widget build(BuildContext context) { // TODO: There is a bug here
    List<DocPreview> childPreview = [];
    //if (!widget.init){
    //widget.init = true;
    //updatePreviews();
    //}
    for (int j = 0; j < widget.pathPreview.length; ++j) {
      childPreview.add(DocPreview(
        projectPath: widget.pathPreview[j],
        projectName: widget.namePreview[j],
        parentHandle: this, // TODO: Is there an alternative to this?
      ));
      //childPreview[j].projectPath = widget.pathPreview[j];
      //childPreview[j].projectName = widget.namePreview[j];
      //childPreview[j].parentHandle = this;
    }

    return GridView(gridDelegate: gridDelegateRef, children: childPreview);
  }

  void updatePreviews() {
    Timer(Duration(milliseconds: 30),(){
    List<String> pathPreviewTemp = [];
    List<String> namePreviewTemp = [];

    // List<Map<String, dynamic>> projectsPath = [];

    //var list = getDatabase()["projects"]["recentOpen"]; // Moved to json_db.dart
   // var projList = getDatabase()["projects"]["list"];
    //widget.previewLength = size;
    //list.forEach((key, value) { // Moved to json_db.dart
      // maybe we should save the data as json too, rather then a list
      //pathPreviewTemp.add(list[key]["filePath"]);
      //namePreviewTemp.add(list[key]["fileName"]);
    //});

    // projList.forEach((key, value){
    //projectsPath.add(value);
    //});

    List<List<String>> result = getMostRecentOpens();
    namePreviewTemp = result[0];
    pathPreviewTemp = result[1];
    if (pathPreviewTemp.toString() == widget.pathPreview.toString() &&
        namePreviewTemp.toString() == widget.namePreview.toString()) {
      return;
    } else {
      setState(() {
        widget.pathPreview = pathPreviewTemp;
        widget.namePreview = namePreviewTemp;
      });
    }
  });
}
}

loadFormPage(BuildContext context, String path, bool isMflowFile ,{String title = "M-Flow"}) {
  if (isMflowFile){
  Navigator.push(context,MaterialPageRoute(builder: (context) {
  return FormPage(
  initText: File(path).readAsStringSync(), initTitle : title , 
  initPath : path,
  // "mflow" : isMflowFile}
  );
  }));

  } else {
    loadMFlowFile(path).then((data){
    Navigator.push(context,MaterialPageRoute(builder: (context) {
  return FormPage(
  initText: data["content"], initTitle : title , 
  initPath : path,
  // "mflow" : isMflowFile}
  );
  }));

    });
  }
}