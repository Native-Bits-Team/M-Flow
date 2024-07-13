import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/flutter_markdown.dart';
import 'package:m_flow/dependencies/md2pdf.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/functions/mark_down_styler.dart';
import 'package:m_flow/functions/string_utilities.dart';
import 'package:pdf/pdf.dart';

_FormPageState? temp;

class FormPage extends StatefulWidget {
  final String initText;

  const FormPage({super.key, required this.initText}); // '?': Denotes that key can be of type 'null' or 'key'...
  // We can choose not to provide a Key when instantiating FormPage...
  //final String initText = "";
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController leftController = TextEditingController();
  String markdownText = "";  // Initialized an empty variable of type 'String' to store markdown text...
  MarkdownStyleSheet markdownStyle = MarkdownStyleSheet();
  bool stopper = true;
  double zoom = 1.0;

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
      markdownText = getUserInput(); // get user input from this method...
    });
  }

  void updateStyle() {
    var markdownStyleValue = buildMarkdownStyle(zoom);
        setState(() {
          markdownStyle = markdownStyleValue;
        });
  }


  // Implementing Dynamic Line Manipulation -
  // Used to provide feature where 'Users' can move around any particular line while still rendering the markdown...
  String getUserInput() {
    String userInput = leftController.text;  // Get the entire user input

    // Split the input into lines
    List<String> lines = userInput.split('\n');

    // Iterate through each line and replace 'm$ ' with a zero-width space if it is at the start of the line
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('m\$ ')) {
        lines[i] = lines[i].replaceFirst('m\$ ', '\u200B'); // Unicode character for a zero-width space (ZWSP). 
        // It is a non-printing character that doesn't produce any visible space or mark, but it is still present in the text
      }
    }

    // Join the lines back together
    userInput = lines.join('\n');

    // Print or use the userInput as needed
    // print('User Input: $userInput');
    return userInput;
  }
  
  @override
  Widget build(BuildContext context) {
    if (stopper) {
      stopper = false;
      updateStyle();
    }

    temp = this;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 24, 32),
        toolbarHeight: 40.0,
        centerTitle: true,
        title: const Text("Welcome to M-Flow Document Making Software !"),
        titleTextStyle: const TextStyle(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(27),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(onPressed: () {      
                        if (leftController.selection.start == leftController.selection.end){
                        leftController.text = addSidesToWord(leftController.text, leftController.selection.start, "**");
                        } else{
                        String newText = "**";
                        newText += leftController.text.substring(leftController.selection.start, leftController.selection.end);
                        newText += "**";
                        leftController.text = leftController.text.replaceRange(leftController.selection.start, leftController.selection.end, newText);
                        }              
                      }, icon: const Icon(Icons.format_bold)),
                      IconButton(onPressed: () {
                        if (leftController.selection.start == leftController.selection.end){
                        leftController.text = addSidesToWord(leftController.text, leftController.selection.start, "*");
                        } else{
                        String newText = "*";
                        newText += leftController.text.substring(leftController.selection.start, leftController.selection.end);
                        newText += "*";
                        leftController.text = leftController.text.replaceRange(leftController.selection.start, leftController.selection.end, newText);
                        }
                      }, icon: const Icon(Icons.format_italic)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.format_underline)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.code)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.format_quote)),
                    ]),
                  Expanded(
                    child: TextField(
                      controller: leftController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'What\'s on your mind?',
                        hintStyle: TextStyle(color: Colors.white38)
                      ),
                      maxLines: null,
                      minLines: 50,
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 47), // Spacer

            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [IconButton(onPressed: () {
                    zoom += 0.2;
                    temp!.updateStyle();
                  }, icon: const Icon(Icons.zoom_in)),
                  IconButton(onPressed: () {
                    zoom -= 0.2;
                    temp!.updateStyle();
                  }, icon: const Icon(Icons.zoom_out)),
                  const SizedBox(width: 10),
                Expanded(child: DropdownMenu(
                //label: const Text("Theme: "),
                trailingIcon: const Icon(Icons.arrow_drop_down),
                initialSelection: "github",
                inputDecorationTheme: const InputDecorationTheme(contentPadding: EdgeInsets.all(0), constraints: BoxConstraints(maxHeight: 40), isCollapsed: true),
                textStyle: const TextStyle(color: Colors.white60, fontSize: 16),
                onSelected: (valueName) {
                  temp!.updateStyle();
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "github", label: "Github Theme")
                ],
              )),
              
               IconButton(
                    onPressed: () {
                    }, icon: const Icon(Icons.icecream, color: Colors.greenAccent,), color: Colors.greenAccent),
               IconButton(
                    onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ExportDialog(
                                dialogContext: context,
                                markdownTextExport: markdownText,
                              );
                            },
                          );}, icon: const Icon(Icons.save, color: Colors.blueAccent), color: Colors.blueAccent,),
                  ]),
                  Expanded(
                    child: PreviewPanel(
                      markdownText: markdownText,
                      style: markdownStyle,
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviewPanel extends StatelessWidget {
  final String markdownText; // used to declare a variable that can only be assigned once...
  // A final variable must be initialized either at the time of declaration or in a constructor (if it's an instance variable)...
  final MarkdownStyleSheet style;

  const PreviewPanel({
    super.key,
    required this.markdownText,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Card: A Material Design Card...
    return Card(
      shadowColor: Colors.grey,
      elevation: 1.0,
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

  const ExportDialog({
    super.key,
    required this.dialogContext,
    required this.markdownTextExport,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  List<String> exportFormatOptions = ["HTML", "PDF", "MD"];
  String exportFormat = "PDF";
  TextEditingController pathParameter = TextEditingController(text: "document_1.pdf");
  TextEditingController authorName = TextEditingController(text: "Mr. YOU");

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Export Parameters"),
      elevation: 3.0,
      contentPadding: const EdgeInsets.all(24.0),
      children: [
        Row(children: [
        Column(children: [
          SizedBox(width: 300,child:
          Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          const Text("Export Path: ", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 30.0),
          Expanded(child: TextField(controller: pathParameter)),
        ])),
        const SizedBox(height: 10.0),
        SizedBox(width: 300, child: Row(children: [
          const Text("File Format: ", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          const Text("HTML"),
          Radio(
            value: exportFormatOptions[0],
            groupValue: exportFormat,
            onChanged: (Object? newSelect) {
              setState(() {
                exportFormat = newSelect.toString();
              });
            },
          ),
          const SizedBox(width: 10.0),
          const Text("PDF"),
          Radio(
            value: exportFormatOptions[1],
            groupValue: exportFormat,
            onChanged: (Object? newSelect) {
              setState(() {
                exportFormat = newSelect.toString();
              });
            },
          ),
          const SizedBox(width: 10.0),
          const Text("MD"),
          Radio(
            value: exportFormatOptions[2],
            groupValue: exportFormat,
            onChanged: (Object? newSelect) {
              setState(() {
                exportFormat = newSelect.toString();
              });
            },
          ),
        ])),
        const SizedBox(height: 10.0),
        SizedBox(width: 300, child: Row(
          children: [
            const Text("Document Title: ", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 30.0),
            Expanded(child: TextField(controller: pathParameter)),
          ],
        )),
        SizedBox(width: 300, child: Row(
          children: [
            const Text("Author Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 30.0),
            Expanded(child: TextField(controller: pathParameter)),
          ],
        )),
        SizedBox(width: 300, child: Row(
          children: [
            const Text("Document Subject: ", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 30.0),
            Expanded(child: TextField(controller: pathParameter)),
          ],
        )),
        const SizedBox(height: 10.0),
        SizedBox(width: 300, child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(widget.dialogContext).pop(null);
              },
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
            ),
            TextButton.icon(
              onPressed: () {
                if (exportFormat == exportFormatOptions[0]) {
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
              label: const Text("Export"),
            )
        
        
        ]))]),
        const SizedBox(width: 30,),
        Column(children: [SizedBox(width:300, child:DocumentPreview(content: widget.markdownTextExport))])
        //SizedBox( width: 10, height:  10,child: PdfPreview(build: (f) => generatePdfFromMD(widget.markdownTextExport,f), enableScrollToPage: true))
        ])
        ],
    );
  }
}

MarkdownStyleSheet buildMarkdownStyle(double zoom) {
  Map<String, dynamic> themeValues = getTheme();

  TextStyle? h1Style;
  TextStyle? h2Style;
  TextStyle? h3Style;


  TextStyle? pStyle;
  TextStyle? aStyle;
  TextStyle? codeStyle;
  Decoration? codeblockDecoration;
  Decoration? blockquoteDecoration;

  themeValues.forEach((key, value){

    switch (key) {
      case "h1":
        h1Style = makeTextStyleJson(value);
        break;
      case "h2":
        h2Style = makeTextStyleJson(value);
        break;
      case "h3":
        h3Style = makeTextStyleJson(value);
        break;
      case "p":
        pStyle = makeTextStyleJson(value);
        break;
      case "a":
        aStyle = makeTextStyleJson(value);
        break;
      case "code":
        codeStyle = makeTextStyleJson(value);
        break;
      case "codeblockDecoration":
        codeblockDecoration = makeBoxDecorationJson(value);
        break;
      case "blockquoteDecoration":
        blockquoteDecoration = makeBoxDecorationJson(value);
        break;
      default: // is it needed?
    }
  });

  return MarkdownStyleSheet(
  code: codeStyle,
  codeblockDecoration: codeblockDecoration,
  h1: h1Style,
  h2: h2Style,
  h3: h3Style,
  p: pStyle,
  a: aStyle,
  blockquoteDecoration: blockquoteDecoration,
  textScaler: TextScaler.linear(zoom)
  );
}

class ParameterDialog extends StatefulWidget {
  final BuildContext dialogContext;

  const ParameterDialog({super.key, required this.dialogContext});

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
        Row(
          children: [
            Expanded(
              child: DropdownMenu(
                label: const Text("Theme: "),
                trailingIcon: const Icon(Icons.arrow_drop_down),
                textStyle: const TextStyle(color: Colors.white60, backgroundColor: Colors.white60),
                onSelected: (valueName) {
                  temp!.updateStyle();
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "github", label: "Github Theme", style: ButtonStyle(textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white60))))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(widget.dialogContext).pop(null);
              },
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text("Save"),
            ),
          ],
        ),
      ],
    );
  }
}


class DocumentPreview extends StatefulWidget {
  final String content;
  const DocumentPreview({super.key, required this.content});
  @override
  State<DocumentPreview> createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview> {
  Image? previewImage;
  @override
  Widget build(BuildContext context) {
    double size = 300;
    double ratio = PdfPageFormat.a4.height / PdfPageFormat.a4.width;
    ratio *= 300;
    if (previewImage == null){
      generatePdfImageFromMD(widget.content).then((image){
        setState(() {
          previewImage = image;
        });
      });
    }

    return SizedBox(width: size, height: ratio,child: Card(child:previewImage));
  }
}