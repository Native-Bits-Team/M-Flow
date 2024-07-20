import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/components/profile_drawer.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/flutter_markdown.dart';
import 'package:m_flow/dependencies/md2pdf/md2pdf.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/functions/mark_down_styler.dart';
import 'package:m_flow/functions/string_utilities.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/profile_page.dart';
import 'package:pdf/pdf.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:permission_handler/permission_handler.dart';

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
  String markdownText = ""; // Initialized an empty variable of type 'String' to store markdown text...
  MarkdownStyleSheet markdownStyle = MarkdownStyleSheet();
  Color? themeBackgroundColor; // Maybe replace with global theme
  Color? formPageBackgroundColor;
  // bool stopper = true;
  double zoom = 1.0;


  // bool _isUpdatingStyle = false; // if don't wanna use debounce, uncomment this, use approach I...
  Timer? _debounce;
  

  // Handles the image uploads and provide a pre-filled md syntax url on to the left-panel...
  Future<void> _handleUploadImage() async {
    try {
      // Pick an image from the gallery
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image!= null) {
        // Get the application documents directory to store the image
        final directory = await getApplicationDocumentsDirectory();

        // Create a unique filename using a timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'image_$timestamp.png';

        // Create a new file in the application documents directory
        final file = File('${directory.path}/$fileName');

        // Write the picked image's bytes to the file
        await file.writeAsBytes(await image.readAsBytes());

        // Get the file path
        final imagePath = file.path;

        // Create a URI for the file
        final uri = Uri.file(imagePath);
        setState(() {
          final markdownText = '![](${uri.toString()})\n';
          leftController.text += markdownText;
        });
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    markdownText = widget.initText;
    leftController.text = markdownText;
    leftController.addListener(_updateRightField);
    updateStyle(); // Call updateStyle once during initialization
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed, So that state object is removed permanently from the tree...
    leftController
        .dispose(); // Important to dispose of the controllers to free up resources and avoid memory leaks...
    _debounce?.cancel();
    super.dispose();
  }

  // void _pickImage(){
  //   // will write code here...
  // }

  void _updateRightField() {
    setState(() {
      markdownText = getUserInput(); // get user input from this method...
    });
  }

//  // updateStyle() method OLD ----------------------------------------
  // void updateStyle() {
  //   var markdownStyleValue = buildMarkdownStyle(zoom);
  //   var backgroundColors = getBackgroundColors();
  //   setState(() {
  //     markdownStyle = markdownStyleValue;
  //     themeBackgroundColor = backgroundColors[0];
  //     formPageBackgroundColor = backgroundColors[1];
  //   });
  // }

//  // updateStyle() method OPTIMIZATION APPROACH - I (using _isUpdatingStyle())----------*DO NOT REMOVE THIS*------------------------------

  // void updateStyle() {
  //   if (_isUpdatingStyle) return;

  //   var markdownStyleValue = buildMarkdownStyle(zoom);
  //   var backgroundColors = getBackgroundColors();

  //   setState(() {
  //     _isUpdatingStyle = true;
  //     // Your style update logic here
  //     markdownStyle = markdownStyleValue;
  //     themeBackgroundColor = backgroundColors[0];
  //     formPageBackgroundColor = backgroundColors[1];

  //     _isUpdatingStyle = false;
  //   });
  // }

// ------------------------- * if DeBounce creates a 'Race-Condition' we'll remove it... * ------------------------------------------

//  // updateStyle() method OPTIMIZATION APPROACH - II (using _debounce())----------------------------------------

  void updateStyle() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 90), () {
      var markdownStyleValue = buildMarkdownStyle(zoom);
      var theme = getTheme();
      setState(() {
        markdownStyle = markdownStyleValue;
        themeBackgroundColor = Color(HexColor(theme["backgroundColor"]).value);
        formPageBackgroundColor =
            Color(HexColor(theme["pageBackgroundColor"]).value);
      });
    });
  }

  // Implementing Dynamic Line Manipulation -
  // Used to provide feature where 'Users' can move around any particular line while still rendering the markdown...
  String getUserInput() {
    String userInput = leftController.text; // Get the entire user input
    // Split the input into lines
    List<String> lines = userInput.split('\n');

    // Iterate through each line and replace 'm$ ' with a zero-width space if it is at the start of the line
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('m\$ ')) {
        lines[i] = lines[i].replaceFirst('m\$ ',
            '\u200B'); // Unicode character for a zero-width space (ZWSP).
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
    // if (stopper) {
    //   stopper = false;
    //   updateStyle();
    // }
    temp = this;
    return Scaffold(
      backgroundColor: formPageBackgroundColor,
      appBar: AppBar(
        title: const Text("M-Flow",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ),

      // *DRAWER : -------------------------------------------------------------------------------- *
      drawer: ProfileDrawer(
        onExportTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ExportDialog(
                dialogContext: context,
                markdownTextExport: markdownText,
              );
            },
          );
        },

        onIceTap: () {},

        onDashTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DashBoard()));
        },

        onGitTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.blueGrey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust border radius as needed
                  side: const BorderSide(
                      color: Colors.black,
                      width: 2.0), // Adjust border color and width
                ),
                title: const Text('Select Theme'),
                content: Container(
                  width: 100,
                  height: 60,
                  child: DropdownMenu(
                    trailingIcon: const Icon(Icons.arrow_drop_down),
                    initialSelection: "github",
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                      isCollapsed: true,
                    ),
                    onSelected: (valueName) {
                      setState(() {
                        // Handle selection if needed
                      });
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                          value: "github", label: "Github Flavour"),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        }, // GitTap ends here
      ),
      // *DRAWER : -------------------------------------------------------------------------------- *

      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    IconButton(
                        onPressed: () {
                          if (leftController.selection.start ==
                              leftController.selection.end) {
                            leftController.text = addSidesToWord(
                                leftController.text,
                                leftController.selection.start,
                                "**");
                          } else {
                            String newText = "**";
                            newText += leftController.text.substring(
                                leftController.selection.start,
                                leftController.selection.end);
                            newText += "**";
                            leftController.text = leftController.text
                                .replaceRange(leftController.selection.start,
                                    leftController.selection.end, newText);
                          }
                        },
                        icon: const Icon(Icons.format_bold)),
                    IconButton(
                        onPressed: () {
                          if (leftController.selection.start ==
                              leftController.selection.end) {
                            leftController.text = addSidesToWord(
                                leftController.text,
                                leftController.selection.start,
                                "*");
                          } else {
                            String newText = "*";
                            newText += leftController.text.substring(
                                leftController.selection.start,
                                leftController.selection.end);
                            newText += "*";
                            leftController.text = leftController.text
                                .replaceRange(leftController.selection.start,
                                    leftController.selection.end, newText);
                          }
                        },
                        icon: const Icon(Icons.format_italic)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.format_underline)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.code)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.format_quote)
                    ),
                    
                    IconButton(
                      onPressed: () async {
                        await _handleUploadImage(); // go to the top...
                      },icon: const Icon(Icons.upload_file)
                    )
                  ]),
                  Expanded(
                    child: TextField(
                      controller: leftController,
                      decoration: const InputDecoration(
                        hintText: 'What\'s on your mind?',
                      ),
                      maxLines: null,
                      minLines: 50,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 47), // Spacer

            Expanded(
              child: Column(
                children: [
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          zoom += 0.2;
                          setState(() {
                            updateStyle();
                          });
                        },
                        icon: const Icon(Icons.zoom_in)),
                    IconButton(
                        onPressed: () {
                          zoom -= 0.2;
                          setState(() {
                            updateStyle();
                          });
                        },
                        icon: const Icon(Icons.zoom_out)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: DropdownMenu(
                      // label: const Text("Theme: "),
                      trailingIcon: const Icon(Icons.arrow_drop_down),
                      initialSelection: "github",
                      inputDecorationTheme: const InputDecorationTheme(
                          contentPadding: EdgeInsets.all(0),
                          constraints: BoxConstraints(maxHeight: 40),
                          isCollapsed: true),
                      textStyle: const TextStyle(fontSize: 16),
                      onSelected: (valueName) {
                        setState(() {
                          updateStyle();
                        });
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                            value: "github", label: "Github Theme")
                      ],
                    )),
                    IconButton(
                        onPressed: () {
                          //implement here
                        },
                        icon: const Icon(
                          Icons.icecream,
                          color: Colors.greenAccent,
                        ),
                        color: Colors.greenAccent),
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
                        );
                      },
                      icon: const Icon(Icons.save, color: Colors.blueAccent),
                      color: Colors.blueAccent,
                    ),


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
  final String
      markdownText; // used to declare a variable that can only be assigned once...
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
  TextEditingController pathParameter =
      TextEditingController(text: "Document_1.pdf");
  TextEditingController authorName = TextEditingController(text: "Mr. YOU");
  TextEditingController documentTitle =
      TextEditingController(text: "Document_1.pdf");
  TextEditingController documentSubject =
      TextEditingController(text: "Be Creative...");

  bool _showAuthorAndSubject = true;

  // METHOD ADDED TO HANDLE SWITCH PRE-FILLED TEXT B/W HTML, PDF, MD...
  void updateTextFields(String format) {
    switch (format) {
      case "HTML":
        pathParameter.text = "Document_1";
        documentTitle.text = "Document_1";
        _showAuthorAndSubject = false;
        break;
      case "PDF":
        pathParameter.text = "Document_1.pdf";
        documentTitle.text = "Document_1.pdf";
        _showAuthorAndSubject = true;
        break;
      case "MD":
        pathParameter.text = "Document_1.md";
        documentTitle.text = "Document_1.md";
        _showAuthorAndSubject = false;
        break;
      default:
        pathParameter.text = "Document_1.pdf";
        documentTitle.text = "Document_1.pdf";
        _showAuthorAndSubject = true;
        break;
    }
  }

// // BUILD METHOD FOR EXPORT DIALOG----------------------------------------------------------------------------*

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Document Export Settings"),
      elevation: 3.0,
      contentPadding:
          const EdgeInsets.only(top: 26, bottom: 22.0, left: 11, right: 11),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 245,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(
                      top: 6.0, bottom: 12.0, left: 11, right: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100, // FIXED WIDTH FOR LABELS
                              padding: const EdgeInsets.only(top: 22),
                              child: const Text("Export Path: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 30.0),
                            Expanded(
                              child: TextField(
                                controller: pathParameter,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter export path',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100, // FIXED WIDTH FOR LABELS
                              padding: const EdgeInsets.only(top: 22),
                              child: const Text("Doc Title: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 30.0),
                            Expanded(
                              child: TextField(
                                controller: documentTitle,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Doc Title',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Visibility(
                        visible: _showAuthorAndSubject,
                        child: SizedBox(
                          width: 300,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100, // FIXED WIDTH FOR LABELS
                                padding: const EdgeInsets.only(top: 22),
                                child: const Text("Author Name: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 30.0),
                              Expanded(
                                child: TextField(
                                  controller: authorName,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter author name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Visibility(
                        visible: _showAuthorAndSubject,
                        child: SizedBox(
                          width: 300,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100, // FIXED WIDTH FOR LABELS
                                padding: const EdgeInsets.only(top: 14),
                                child: const Text("Doc Subject: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 30.0),
                              Expanded(
                                child: TextField(
                                  controller: documentSubject,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter Doc Subject',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  child: Column(
                    children: [
                      // const Text("File Format: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("HTML"),
                          Radio(
                            value: exportFormatOptions[0],
                            groupValue: exportFormat,
                            onChanged: (Object? newSelect) {
                              setState(() {
                                exportFormat = newSelect.toString();
                                updateTextFields(exportFormat); // UPDATES THE PRE-FILLED TEXTS
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
                                updateTextFields(exportFormat); // UPDATES THE PRE-FILLED TEXTS
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
                                updateTextFields(exportFormat); // UPDATES THE PRE-FILLED TEXTS
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 25.0),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                        },
                        child: const Text("Personalize First Page"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 75.0),
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(widget.dialogContext).pop(null);
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text("Cancel"),
                      ),
                      const SizedBox(width: 20),
                      TextButton.icon(
                        onPressed: () {
                          if (exportFormat == exportFormatOptions[0]) {
                            mdtopdf(widget.markdownTextExport,
                                pathParameter.text, true, temp!.markdownStyle);
                          } else if (exportFormat == exportFormatOptions[1]) {
                            mdtopdf(widget.markdownTextExport,
                                pathParameter.text, false, temp!.markdownStyle);
                          } else {
                            File(pathParameter.text)
                                .writeAsString(widget.markdownTextExport)
                                .then((value) {
                              Navigator.of(widget.dialogContext).pop();
                            });
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Export"),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(child: DocumentPreview(widget.markdownTextExport))
          ],
        ),
      ],
    );
  }
}

// BUILD METHOD FOR EXPORT DIALOG (ENDS HERE)-----------------------------------------------------------------**

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

  themeValues.forEach((key, value) {
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
      textScaler: TextScaler.linear(zoom));
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
                onSelected: (valueName) {
                  Navigator.of(widget.dialogContext).pop();
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "github", label: "Github Theme")
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

  DocumentPreview(this.content, {super.key});

  @override
  _DocumentPreviewState createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview> {
  Image? previewImage;
  int pageCount = 1;
  int currentPageIndex = 1;
  int lastPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    double size = 300;
    double ratio = PdfPageFormat.a4.height / PdfPageFormat.a4.width;
    ratio *= 300;
    /*
    if (widget.content.isEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullPreviewScreen(widget.content),
            ),
          );
        },
        child: Column(children: [
          Container(
          width: size,
          height: ratio,
          child: const Card(
            child: Center(
              child: Text(
                "Nothing to display", 
                style: TextStyle(
                  color: Colors.red
                  ),
                ),
            ),
          ),
        )
        Text("Path 1/1")]),
      );
    }
*/ // NOT REALLY NEEDED

    if (previewImage == null || lastPageIndex != currentPageIndex) {
      previewImage = null;
      lastPageIndex = currentPageIndex;
      generatePdfImageFromMD(widget.content, temp!.markdownStyle, pageIndex: currentPageIndex-1)
          .then((imageAndSize) {
        setState(() {
          previewImage = imageAndSize[0];
          pageCount = imageAndSize[1];
        });
      });
    }
    Widget wError;
    if (widget.content.isEmpty) {
      wError = Center(
        child: const Text(
          "Nothing to Display",
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      wError = const Center(child: CircularProgressIndicator());
    }

    String pageText = "Page $currentPageIndex/$pageCount";
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPreviewScreen(widget.content, pageIndex: currentPageIndex-1,),
          ),
        );
      },
      child: Column(children: [
        Row(children: [
          IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = max(1, currentPageIndex - 1);
                });
              },
              icon: const Icon(Icons.chevron_left)),
          SizedBox(
              width: size,
              height: ratio,
              child: Card(clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 0.0,
              borderOnForeground: false,
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(0.0),
                  child: previewImage ??
                      wError //const Center(child: CircularProgressIndicator()),
                  )),
          IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = min(pageCount, currentPageIndex + 1);
                });
              },
              icon: const Icon(Icons.chevron_right))
        ]),
        const SizedBox(height: 20),
        Text(pageText)
      ]),
    );
  }
}

class FullPreviewScreen extends StatefulWidget {
  final String content;
  final int pageIndex;

  const FullPreviewScreen(this.content, {required this.pageIndex, super.key});

  @override
  _FullPreviewScreenState createState() => _FullPreviewScreenState();
}

class _FullPreviewScreenState extends State<FullPreviewScreen> {
  Image? previewImage;

  @override
  void initState() {
    super.initState();

    if (widget.content.isNotEmpty) {
      generatePdfImageFromMD(widget.content, temp!.markdownStyle, pageIndex: widget.pageIndex)
          .then((imageAndSize) {
        setState(() {
          previewImage = imageAndSize[0];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = 600;
    double ratio = PdfPageFormat.a4.height / PdfPageFormat.a4.width;
    ratio *= size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 22, 32),
      appBar: AppBar(
        toolbarHeight: 28,
        backgroundColor: const Color.fromARGB(255, 2, 22, 32),
      ),
      body: Center(
        child: widget.content.isEmpty
            ? const Text("Nothing to display",
                style: TextStyle(color: Colors.red))
            : SingleChildScrollView(
                child: Container(
                  width: size,
                  height: ratio,
                  decoration: const BoxDecoration(),
                  child: Card(
                    child: previewImage ??
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
      ),
    );
  }
}
