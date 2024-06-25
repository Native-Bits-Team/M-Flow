import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:m_flow/dependencies/md2pdf.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: PreviewPanel(markdownText: markdownText),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {showDialog(context: context, builder: (BuildContext context) {return ExportDialog(dialogContext: context, markdownTextExport: markdownText);});},
                          label: const Text("Export"),
                          icon: const Icon(Icons.save),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 183, 232, 255)),
                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                        ),
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
  const PreviewPanel({super.key, required this.markdownText}); 

  @override
  Widget build(BuildContext context) {

    // Card: A Material Design Card...
    return Card(
      shadowColor: Colors.grey,
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Markdown(data: markdownText, styleSheet: MarkdownStyleSheet(code: const TextStyle(backgroundColor: Colors.transparent),codeblockDecoration: const BoxDecoration(color: Colors.black26) ),),
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