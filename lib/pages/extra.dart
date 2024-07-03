import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m_flow/dependencies/flutter_markdown/lib/flutter_markdown.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/dependencies/md2pdf.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/functions/mark_down_styler.dart';

_FormPageState? temp;


class FormPage extends StatefulWidget {
  
  final String initText;

  const FormPage({super.key, required this.initText});  // '?': Denotes that key can be of type 'null' or 'key'...
  // We can choose not to provide a Key when instantiating FormPage...
  //final String initText = "";
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController leftController = TextEditingController();
  String markdownText = "";  // Initialized an empty variable of type 'String' to store markdown text...
  MarkdownStyleSheet markdownStyle = MarkdownStyleSheet();
  Color? themeBackgroundColor; // Maybe replace with global themer
  Color? formPageBackgroundColor;
  bool stopper = true;

  @override
  void initState() {
    super.initState();
    markdownText = widget.initText;
    leftController.text = markdownText;
    leftController.addListener(_updateRightField);
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed, So that state object is removed permanently from the tree...
    leftController.dispose(); // Important to dispose of the controllers to free up resources and avoid memory leaks...
    super.dispose();
  }

  void _updateRightField() {
    setState(() {
      markdownText = leftController.text;  // Assigned user's input(left-form) to 'markdownText' variable...
     // GetPageAmount(markdownText);
    });
  }

  void updateStyle() {
    buildMarkdownStyle().then((markdownStyleValue){
      getBackgroundColors().then((backgroundColors){
      setState(() {
        markdownStyle = markdownStyleValue;
        themeBackgroundColor = backgroundColors[0];
        formPageBackgroundColor = backgroundColors[1];

      });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (stopper){
      stopper = false;
      updateStyle();
    }
   // if (themeBackgroundColor == null){
    //File("assets/themes/github.json").readAsString().then((theme){
    //});
    //}
    temp = this;
    return Scaffold(
      backgroundColor: formPageBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 183, 232, 255),
        toolbarHeight: 50.0,
        // title: Text("First Document!"),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Colors.white, size: 25.0,)),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left form
            Expanded(
             // child: Container(
               // height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: leftController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(99, 128, 127, 127))
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'What\'s on your mind?',
                        ),
                        maxLines: null,
                        minLines: 50,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_left)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_right)),
                      ],
                    ),
                  ],
                ),
              ),
          //  ),

            // Spacer
            const SizedBox(width: 50),

            // Right form (PreviewPanel)
            Expanded(
            //  child: Container(
              //  height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: PreviewPanel(markdownText: markdownText, style: markdownStyle, BackgroundColor: themeBackgroundColor),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      
                      children: [TextButton.icon(
                          onPressed: () {showDialog(context: context, builder: (BuildContext context) {return ParameterDialog(dialogContext: context);});},
                          label: const Text("Apperance"),
                          icon: const Icon(Icons.icecream),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 106, 228, 191)),
                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                        ),
                        SizedBox(width: 16.0,),
                        TextButton.icon(
                          onPressed: () {showDialog(context: context, builder: (BuildContext context) {return ExportDialog(dialogContext: context, markdownTextExport: markdownText);});},
                          label: const Text("Export"),
                          icon: const Icon(Icons.save),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 71, 146, 180)),
                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
            //  ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviewPanel extends StatelessWidget {
  final String markdownText;  // used to declare a variable that can only be assigned once...
  // A final variable must be initialized either at the time of declaration or in a constructor (if it's an instance variable)...
  
  // Required keyword ensures that this parameter must be provided when constructing an instance of PreviewPanel...
  PreviewPanel({super.key, required this.markdownText, required this.style, this.BackgroundColor}); 
  MarkdownStyleSheet style;
  Color? BackgroundColor;
  @override
  Widget build(BuildContext context) {

    // Card: A Material Design Card...

    return Card(
      shadowColor: Colors.grey,
      elevation: 1.0,
      color: BackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Markdown(data: markdownText, styleSheet: style),
      ),
    );
  }
}



class ExportDialog extends StatefulWidget {

  final BuildContext dialogContext;
  final String markdownTextExport;

  const ExportDialog({super.key, required this.dialogContext, required this.markdownTextExport});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  List<String> exportFormatOptions = ["HTML", "PDF", "MD"]; 
  String exportFormat = "PDF";
  TextEditingController pathParameter =TextEditingController(text: "document_1.pdf");
  TextEditingController authorName =TextEditingController(text: "Mr. YOU");

  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
                                      title: const Text("Export Parameters"),
                                      elevation: 3.0,
                                      contentPadding: const EdgeInsets.all(24.0),
                                      children: [
                                        Row(children: [
                                          const Text("Export Path: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 30.0),
                                          Expanded(
                                              child: TextField(
                                                  controller: pathParameter))
                                        ]),
                                        const SizedBox(height: 10.0),
                                        Row(children: [
                                          const Text("File Format: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 10),
                                          const Text("HTML"),
                                          Radio(
                                              value: exportFormatOptions[0],
                                              groupValue: exportFormat,
                                              onChanged: (Object? newSelect) {
                                                setState(() {
                                                  exportFormat =
                                                      newSelect.toString();
                                                });
                                              }),
                                          const SizedBox(width: 10.0),
                                          const Text("PDF"),
                                          Radio(
                                              value: exportFormatOptions[1],
                                              groupValue: exportFormat,
                                              onChanged: (Object? newSelect) {
                                                setState(() {
                                                  exportFormat =
                                                      newSelect.toString();
                                                });
                                              }),
                                              const SizedBox(width: 10.0),
                                          const Text("MD"),
                                          Radio(
                                              value: exportFormatOptions[2],
                                              groupValue: exportFormat,
                                              onChanged: (Object? newSelect) {
                                                setState(() {
                                                  exportFormat =
                                                      newSelect.toString();
                                                });
                                              })
                                        ]),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                          const Text("Document Title: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 30.0),
                                          Expanded(
                                              child: TextField(
                                                  controller: pathParameter))
                                        ]),
                                        Row(children: [
                                          const Text("Author Name: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 30.0),
                                          Expanded(
                                              child: TextField(
                                                  controller: pathParameter))
                                        ]),
                                        Row(children: [
                                          const Text("Document Subject: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 30.0),
                                          Expanded(
                                              child: TextField(
                                                  controller: pathParameter))
                                        ]),    
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                                onPressed: () {
                                                  Navigator.of(widget.dialogContext)
                                                      .pop(null);
                                                },
                                                icon: const Icon(Icons.cancel),
                                                label: const Text("Cancel")),
                                            TextButton.icon(
                                                onPressed: () {
                                                  if (exportFormat == exportFormatOptions[0]){
                                                  mdtopdf(widget.markdownTextExport, pathParameter.text, true);
                                                  } else if (exportFormat == exportFormatOptions[1]) {
                                                  mdtopdf(widget.markdownTextExport, pathParameter.text, false);
                                                  } else {
                                                    File(pathParameter.text).writeAsString(widget.markdownTextExport).then((value) {
                                                      Navigator.of(widget.dialogContext).pop();
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.save),
                                                label: const Text("Export"))
                                          ],
                                        ),
                                      ]);
  }
}



Future<MarkdownStyleSheet> buildMarkdownStyle() async{
  Map<String, dynamic> themeValues = await loadThemeFile("assets/themes/github.json");
  print("Generating Style..");
  //Color codeblockDecorationValue = makeColorJson(themeValues["codeblockDecoration"]);
  
  var h1Style;
  var pStyle;

  

  themeValues.forEach((key, value){
    if (key == "h1"){
      h1Style = makeTextStyleJson(value);
    }
    if (key == "p"){
      pStyle = makeTextStyleJson(value);

    }
  });


  return MarkdownStyleSheet(
  code: const TextStyle(backgroundColor: Colors.transparent, fontWeight: FontWeight.bold
  ),
  codeblockDecoration: BoxDecoration(color: Colors.blue),
  h1: h1Style,
  p: pStyle
  //strong: TextStyle(fontWeight: FontWeight.bold),
  );
}



Future<List<Color>> getBackgroundColors() async{
    Map<String, dynamic> themeValues = await loadThemeFile("assets/themes/github.json");
    return [Color(HexColor(themeValues["backgroundColor"]).value),Color(HexColor(themeValues["pageBackgroundColor"]).value)];
}


class ParameterDialog extends StatefulWidget {

  final BuildContext dialogContext;
  //_FormPageState? formContext;
  ParameterDialog({super.key, required this.dialogContext});//, required this.formContext});

  @override
  State<ParameterDialog> createState() => _ParameterDialogState();
}

class _ParameterDialogState extends State<ParameterDialog> {

  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
                                      title: const Text("Apperance Parameters"),
                                      elevation: 3.0,
                                      contentPadding: const EdgeInsets.all(24.0),
                                      children: [
                                        Row(children: [
                                        Expanded(child: DropdownMenu(label: Text("Theme: "),
                                      trailingIcon: Icon(Icons.arrow_drop_down),
                                      onSelected: (valueName){
                                        temp!.updateStyle();
                                      },
                                        dropdownMenuEntries: [DropdownMenuEntry(value: "github", label: "Github Theme")]))
                                        ]),
                                        const SizedBox(height: 20.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                                onPressed: () {
                                                  Navigator.of(widget.dialogContext)
                                                      .pop(null);
                                                },
                                                icon: const Icon(Icons.cancel),
                                                label: const Text("Cancel")),
                                            TextButton.icon(
                                                onPressed: () {
                                                 
                                                },
                                                icon: const Icon(Icons.save),
                                                label: const Text("Save"))
                                          ],
                                        ),]);
  }
}

