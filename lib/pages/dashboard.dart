import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/code_src/style_sheet.dart';
import 'package:m_flow/dependencies/md2pdf/md2pdf.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/pages/form_page.dart';
import 'package:m_flow/pages/settings.dart';


import 'package:m_flow/pages/info.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("M-Flow"),
        ),
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
                            IntrinsicWidth(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                if (data["content"] == null){
                                                  //print("Error");
                                                }
                                                Navigator.pushReplacement(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return FormPage(
                                                    initText: data["content"],
                                                    initTitle: data["title"] == "" || data["title"] == null ? result.files.first.name : data["title"],
                                                    initPath: result.files.first.path,
                                                  );
                                                }));
                                              });
                                            } else {
                                              loadFormPage(context, result.files.first.path!,false, title: result.files.first.name);
                                            }
                                          });
                                        },
                                        label: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Open Document'),
                                        ),
                                      ),


                                    const SizedBox(height: 20),
                                    TextButton.icon(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const FormPage(
                                              initText: "",
                                              initTitle: "M-Flow",
                                            );
                                          }));
                                        },
                                        label: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('New Document'),
                                        )
                                    ),
                                  ]),
                            ),
                            const Column( // TODO: is this needed?
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                SizedBox(height: 20),
                                ]),
                                IntrinsicWidth(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextButton.icon(
                                        label: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('settings'),
                                        ),
                                        icon: const Icon(Icons.settings),
                                        onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context) {return const SettingsPanel();}));
                                        }),
                                        const SizedBox(height: 20),
                                    TextButton.icon(
                                        label: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('info'),
                                        ),
                                        icon: const Icon(Icons.info),
                                        onPressed: () {
                                            Navigator.push(context,MaterialPageRoute(builder: (context) {return const Info();}));
                                        })
                                  ]),
                                )
                          ]))),
                  const SizedBox(height: 32),
                  const Text("Recent Documents", textScaler: TextScaler.linear(1.5),),
                  const SizedBox(height: 16),

                  const Expanded(child: ProjectGrid())
                ])));
  }
}

class DocPreview extends StatefulWidget {
  DocPreview({
    super.key,
    required this.projectPathW,
    required this.projectNameW,
    required this.onDelete,
    required this.deleteJsonDoc,
  });

  String projectPathW;
  String projectNameW;
  final Function(String, String) onDelete;  // Added it....
  final Function(String, String) deleteJsonDoc;
  //Widget? previewImageBytes;
  @override
  State<DocPreview> createState() => _DocPreviewState();
}


class _DocPreviewState extends State<DocPreview> {
 late String projectPathS;
 late String projectNameS;
 Widget? previewImageBytesS;
  String test = ""; // This is temporary (used to hold the content of doc)
  bool enabled = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    projectPathS = widget.projectPathW;
    projectNameS = widget.projectNameW;
    updatePreview();
  }

  // added it ......................
  void deleteDoc() {
    //widget.onDelete(widget.projectPath, widget.projectName);
    widget.onDelete(projectPathS, projectNameS);
  }

  void deleteJsonDoc(){
    //removeRecentOpen(widget.projectPath, widget.projectName);
    //widget.deleteJsonDoc(widget.projectPath, widget.projectName);
    widget.deleteJsonDoc(projectPathS, projectNameS);
  }
  // ..............................

  void updatePreview({bool force = false}){
    //if ((widget.previewImageBytes == null && widget.projectPath != "") || force) {
    if ((previewImageBytesS == null && projectPathS != "" || force)){
      //ScreenshotController sController = ScreenshotController();
      //var file = File(widget.projectPath);
      var file = File(projectPathS);
      if (!file.existsSync()) {
        setState(() {
          enabled = false;
          //widget.previewImageBytes = const Tooltip(
          previewImageBytesS = const Tooltip(
            message: "File not found!",
            child: Icon(Icons.info, color: Colors.red));
        });
      } else {
        enabled = true;
      _debounce?.cancel(); // Credits to NBT member Madhur for this code
      _debounce = Timer(const Duration(milliseconds: 200), () {
        // This was added to remove lag when switching to the dashbaord, this isn't a permenent solution, as all previews will
        // update at the same time, a better solution would be to make preview update one by one, or in a spread thread, etc...

        file.readAsString().then((text) {
          test = text;
          // TODO: Wrong way of handling opening and closing a file?
          if (text.startsWith("mflow")) {
            Map<String, dynamic> data = jsonDecode(text.substring(10));
            test = data["content"];
            generatePdfImageFromMD(data["content"], buildMarkdownStyle(1.0, tempTheme: data["theme"]), tempTheme: data["theme"], dpiMultiplicator: 0.7, fq: FilterQuality.high)
            .then((imageAndSize) {
              setState(() {
                //widget.previewImageBytes = imageAndSize[0];
                previewImageBytesS = imageAndSize[0];
              });
            });
          } else {
            generatePdfImageFromMD(text, MarkdownStyleSheet(), tempTheme: "mflow", dpiMultiplicator: 0.7, fq: FilterQuality.high)
            .then((imageAndSize) {
              setState(() {
                //widget.previewImageBytes = imageAndSize[0];
                previewImageBytesS = imageAndSize[0];
              });
            });
          }
        });
      });}
    }
  }

void checkPreviewInfo(){
  //print(projectNameS == widget.projectNameW ? "SAME NAME" : "DIFFERENET NAME");
  if (projectNameS != widget.projectNameW || projectPathS != widget.projectPathW){
   // print("ERROR");
    //print(projectNameS);
    //print(widget.projectNameW);
   // setState(() {
      projectNameS = widget.projectNameW;
      projectPathS = widget.projectPathW;
      previewImageBytesS = const Center(child: CircularProgressIndicator());
      updatePreview(force: true);
    //});
  }
}
  @override
  Widget build(BuildContext context) {
    //checkPreviewInfo(); // TODO: This method removes a RecentOpen and then regenerate all DocPreviews, a better solution would to just delete the most recent then the button of it
    checkPreviewInfo();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
        child: MaterialButton(
        hoverElevation: 0.2,
        elevation: 0.1,
        padding: EdgeInsets.zero,
       /* onLongPress: () { // TODO: make it right click
          showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(10, 10, 10, 10), // TODO: mouse position
              items: [
                PopupMenuItem(
                    onTap: () {
                      deleteDoc();
                      // removeRecentOpen(widget.projectPath, widget.projectName);//.then(() {
                      // widget.parentHandle.updatePreviews(); // TODO: Replace this method
                      // dispose();
                      
                    //  });
                    },
                    child: const Text("Delete"))
              ]);
        },*/
        onPressed: () {
          if (!enabled) {return;}
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return FormPage(
              initText: test,
              //initTitle: widget.projectName,
              //initPath : widget.projectPath,
              initTitle: projectNameS,
              initPath: projectPathS,
            );
          }));
        },
        color: Colors.transparent,
        child: GridTile(header: Align(alignment: Alignment.centerRight, child: IconButton(onPressed: (){
          _showDeleteConfirmation(context);
        },icon: const Icon(Icons.delete, color: Colors.redAccent,))),child: //widget.previewImageBytes
        previewImageBytesS ?? const Center(child: CircularProgressIndicator()),),

      )),


      const SizedBox(height: 5),
     // Row(
       // mainAxisAlignment: MainAxisAlignment.center, 
        //children: [
        
          Tooltip(message: projectNameS,//widget.projectName,
          child: Center(child: Text(projectNameS, maxLines:1 ))),//widget.projectName, maxLines: 1))),
          //IconButton(
            //onPressed: () {_showDeleteConfirmation(context);}, // Added it.............
            //icon: const Icon(Icons.delete)),
        //]
      //)
    ]);
  }


  // Added it............................................................

  void _showDeleteConfirmation(BuildContext context) {
    bool deleteFromSystem = false; // Local state for checkbox within the dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Confirm Removale", style: TextStyle(fontWeight: FontWeight.bold),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Are you sure you want to remove the document?"),
                  CheckboxListTile(
                    title: const Text("Delete from system", style: TextStyle(color: Colors.red),),
                    value: deleteFromSystem,
                    tileColor: Colors.transparent,
                    
                    
                    onChanged: (value) {
                      setState(() {
                        deleteFromSystem = value ?? true; // Update the local state
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.redAccent)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    if (deleteFromSystem) {
                      deleteDoc(); // Call the deleteDoc method
                    } else {
                      deleteJsonDoc(); // Call the deleteJsonDoc method
                    }
                  },
                  child: const Text("Delete", style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          },
        );
      },
    );
  }

}

class ProjectGrid extends StatefulWidget {
  const ProjectGrid({super.key});
  //List<String> pathPreview = [];
  //List<String> namePreview = [];
  //bool init = false;

  @override
  State<ProjectGrid> createState() => _ProjectGridState();
}


class _ProjectGridState extends State<ProjectGrid> {
List<String> pathPreviewS = [];
List<String> namePreviewS = [];
  @override
  void initState() {
    super.initState();
    updatePreviews();

  }

  Widget generateDocs(){
    return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.65, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0), itemCount: pathPreviewS.length,//widget.pathPreview.length,
     itemBuilder: (context, count){
      return DocPreview(projectPathW: pathPreviewS[count], projectNameW: namePreviewS[count], onDelete: deleteDocument, deleteJsonDoc: deleteFromJson);
    });
  }

  void deleteDocument(String path, String name) async {
    removeRecentOpen(path, name);
    try {
      await File(path).delete();
      setState(() {
        updatePreviews();
      });

      // Hide the current snackbar if there is one
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document deleted successfully')),
      );
    } catch (e) {
      //print(e);

      // Hide the current snackbar if there is one
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting document!')),
      );
    }
  }


  void deleteFromJson(String path, String name) {
    removeRecentOpen(path, name);
    // print('hello');
    try {
      setState(() {
        updatePreviews();
        //widget.namePreview.remove(name); // TODO: BUG: Multiple documents with differenet paths could have same name
      });
      
      // Hide the current snackbar if there is one
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document removed successfully')),
      );
    } catch (e) {
      
     // print(e);

      // Hide the current snackbar if there is one
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing document!')),
      );
    }
  }




  // Added it...................................

  @override
  Widget build(BuildContext context) {
    return generateDocs();
  }

  void updatePreviews() {
    // Timer(Duration(milliseconds: 30), () {
    Future.delayed(const Duration(milliseconds: 30), () {
      List<String> pathPreviewTemp = [];
      List<String> namePreviewTemp = [];

      // Fetch updated previews
      List<List<String>> result = getMostRecentOpens();
      namePreviewTemp = result[0];
      pathPreviewTemp = result[1];

      if (pathPreviewTemp.toString() != pathPreviewS.toString() || //widget.pathPreview.toString() ||
          namePreviewTemp.toString() != namePreviewS.toString()) {//widget.namePreview.toString()) {
        setState(() {
          //widget.pathPreview = pathPreviewTemp;
          //widget.namePreview = namePreviewTemp;
          pathPreviewS = pathPreviewTemp;
          namePreviewS = namePreviewTemp;
        });
       // populateChildPreview();
      }
    });
  }
  // Added it......................................................
  
}


// Needs improvements......................................................................
loadFormPage(BuildContext context, String path, bool isNotMflowFile ,{String title = "M-Flow"}) {
  if (!isNotMflowFile){
  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
  return FormPage(
  initText: File(path).readAsStringSync(), initTitle : title , 
  initPath : path,
  // "mflow" : isMflowFile}
  );
  }));

  } else {
    loadMFlowFile(path).then((data){
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
  return FormPage(
  initText: data["content"], initTitle : title , 
  initPath : path,
  // "mflow" : isMflowFile}
  );
  }));

    });
  }
}

