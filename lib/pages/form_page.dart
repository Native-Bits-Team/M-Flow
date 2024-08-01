import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_flow/components/profile_drawer.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/flutter_markdown.dart';
import 'package:m_flow/functions/json_db.dart';
import 'package:m_flow/functions/mark_down_styler.dart';
import 'package:m_flow/functions/string_utilities.dart';
import 'package:m_flow/main.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/settings.dart';
import 'package:m_flow/widgets/dialog_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



class TurnBold extends Intent {
  const TurnBold();
}

class SaveProject extends Intent {
  const SaveProject();
}

// import 'package:permission_handler/permission_handler.dart';

_FormPageState? temp;

class FormPage extends StatefulWidget {
  final String initText;
  final String initTitle;
  final String? initPath;
  final String? initTheme;

  const FormPage({super.key, required this.initText, required this.initTitle, this.initPath, this.initTheme = "default"}); // '?': Denotes that key can be of type 'null' or 'key'...
  // We can choose not to provide a Key when instantiating FormPage...
  //final String initText = "";
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late String title;
  late String? path;

  FocusNode focusGuider = FocusNode();
  TextEditingController leftController = TextEditingController();
  String markdownText = ""; // Initialized an empty variable of type 'String' to store markdown text...
  MarkdownStyleSheet markdownStyle = MarkdownStyleSheet();
  bool notSaved = false;
  //Color? themeBackgroundColor; // Maybe replace with global theme
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
        final directory = await getApplicationDocumentsDirectory(); // TODO: we could reduce dependency count by removing this one and replacing it with built in solution or custom solution

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
      //print('Error: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    title = widget.initTitle;
    path = widget.initPath;
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
    if (markdownText == getUserInput()){
      return;
    }
    if (globalDatabase["settings"]["autosave"]){
    if (!_debounce!.isActive){
      _debounce = Timer(const Duration(minutes: 5), (){
        autoSave();
      });
    }
    }
    //notSaved = true;
    setState(() {
      if (!notSaved){
        title = title + '*';
        notSaved = true;
      }
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

  void updateStyle({bool? zoomOnly}) {
    if (zoomOnly != null && zoomOnly){
      setState(() {
        markdownStyle = markdownStyleZoom(zoom, markdownStyle);
      });
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 90), () {
      var markdownStyleValue = buildMarkdownStyle(zoom);
      globalAppHandler!.updateGlobalAppTheme();
      setState(() {
        markdownStyle = markdownStyleValue;
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

  // To handle the icons (bold, italic, mathjax, ....) features gracefully
  void _formatText(String prefix, String suffix, {bool isBlock = false}) {
    final start = leftController.selection.start;
    final end = leftController.selection.end;

    // Check for valid selection
    if (start == -1 || end == -1) {
      return; // Invalid selection
    }

    if (start == end) {
      // Handle when no text is selected
      leftController.text = addSidesToWord(
        leftController.text,
        start,
        prefix,
      );
      focusGuider.requestFocus();
      leftController.selection = TextSelection(baseOffset: start + prefix.length, extentOffset: start + prefix.length);

    } else {
      // Handle when text is selected
      String selectedText = leftController.text.substring(start, end);
      String newText;

      if (selectedText.startsWith(prefix) && selectedText.endsWith(suffix)) {
        // Remove formatting
        newText = selectedText.substring(prefix.length, selectedText.length - suffix.length);
      } else {
        // Add formatting
        if (isBlock) {
          newText = '$prefix\n$selectedText\n$suffix';
        } else {
          newText = '$prefix$selectedText$suffix';
        }
      }

      leftController.text = leftController.text.replaceRange(start, end, newText);
    }
  }


  @override
  Widget build(BuildContext context) {
    // if (stopper) {
    //   stopper = false;
    //   updateStyle();
    // }
   /* List<DropdownMenuEntry> dropEntries = []; // Moved to json_db.dart;
    Directory("assets/themes").listSync().forEach((entry){
      File data = File(entry.path);
      if (data.existsSync()){
      Map<String, dynamic> dataD =  jsonDecode(data.readAsStringSync());
      dropEntries.add(DropdownMenuEntry(value: dataD["themeFileName"], label: dataD["themeName"]));
      }
    });*/
    temp = this;
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            //style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
            )),

      // *DRAWER : -------------------------------------------------------------------------------- *
      drawer: ProfileDrawer(
        onSettingsTap: () {
        /*  showDialog(
            context: context,
            builder: (BuildContext context) {
              return ExportDialog(
                dialogContext: context,
                markdownTextExport: markdownText,
                markdownStyle: temp!.markdownStyle,
              );
            },
          );*/
          
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsPanel()));
        },
        onDashTap: () {
          //Navigator.push(context,
            //  MaterialPageRoute(builder: (context) => const DashBoard()));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const DashBoard()));
        },
/*
        onDashTap: () {
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
                content: SizedBox(
                  width: 100,
                  height: 60,
                  child: DropdownMenu(
                    trailingIcon: const Icon(Icons.arrow_drop_down),
                    initialSelection: "github_dark",
                    expandedInsets: const EdgeInsets.all(0.0),
                    inputDecorationTheme: const InputDecorationTheme(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none
                    ),
                    onSelected: (valueName) {
                      setState(() {
                        // Handle selection if needed
                      });
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                          value: "github_dark", label: "Github Flavour"),
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
        }, */// GitTap ends here
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
                        _formatText("**", "**");
                      },
                    icon: const Icon(Icons.format_bold),
                    ),

                    IconButton(
                      onPressed: () {
                        _formatText("*", "*");
                      },
                      icon: const Icon(Icons.format_italic),
                    ),

                    IconButton(
                      onPressed: () {
                        _formatText("`", "`");
                      },
                      icon: const Icon(Icons.code),
                    ),
                    IconButton(
                      onPressed: () {
                        _formatText("```\n", "\n```", isBlock: true);
                      },
                      icon: const Icon(Icons.format_quote),
                    ),

                    IconButton(
                      onPressed: () async {
                        await _handleUploadImage(); // go to the top...
                      },icon: const Icon(Icons.upload_file)
                    ),


                    IconButton(
                      onPressed: () {
                        const mathExpressionTemplate = r'$$your_math_expression_here$$';
                        leftController.text = leftController.text.replaceRange(
                          leftController.selection.start,
                          leftController.selection.end,
                          mathExpressionTemplate,
                        );
                      },
                      icon: const Icon(Icons.functions),
                    )
                  ]),
                  Expanded(
                    child: 
                    Shortcuts(shortcuts: <ShortcutActivator,Intent>{
                      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB): const TurnBold(),
                      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): const SaveProject(),
                    },
                    child: Actions(
                      actions: {
                        TurnBold: CallbackAction(onInvoke: (intent) {
                          _formatText("**", "**");
                        }),
                        SaveProject: CallbackAction(onInvoke: (intent) {
                          if (path != null){
                            saveMFlowFile(content: markdownText, path: path);
                            setState(() {
                                title = widget.initTitle;
                            notSaved = false;

                            });
                          } else{
                          var p = saveMFlowFile(content: markdownText).then((nPath){
                            if (nPath == null){
                              return;
                            }
                            path = nPath;
                            setState(() {
                                title = widget.initTitle;
                                notSaved = false;

                            });
                          });
                          }
                        })
                      },
                      child: Focus( // is this needed for shotcuts to work?
                        child: TextField( // [TRANSPARENCY] Imad : I mistankely opened text_field.dart
                      controller: leftController,
                      focusNode: focusGuider, // The Description is useful
                      decoration: const InputDecoration(
                        hintText: 'What\'s on your mind?',
                      ),
                      maxLines: null,
                      minLines: 50,
                    ))),
                  )),
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
                            updateStyle(zoomOnly: true);
                          });
                        },
                        icon: const Icon(Icons.zoom_in)),
                    IconButton(
                        onPressed: () {
                          zoom -= 0.2;
                          setState(() {
                            updateStyle(zoomOnly: true);
                          });
                        },
                        icon: const Icon(Icons.zoom_out)),
                    const SizedBox(width: 10),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue.shade100, width: 1),
                        
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownMenu(
                        // label: const Text("Theme: "),
                        enableFilter: true,
                        trailingIcon: const Icon(Icons.arrow_drop_down, color: Colors.white60),
                        initialSelection: getDropThemeEntries().isEmpty ? "default" : widget.initTheme,
                        inputDecorationTheme: const InputDecorationTheme(
                          contentPadding: EdgeInsets.all(9.0),
                          constraints: BoxConstraints(maxHeight: 35),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.red, width: 0.5),
                          //   borderRadius: BorderRadius.circular(16.0),
                          // ),
                          isCollapsed: true,
                        ),
                        //textStyle: const TextStyle(fontSize: 13),
                        onSelected: (valueName) {
                          setState(() {
                            loadThemeFile(valueName as String);
                            updateStyle();
                          });
                        },
                        dropdownMenuEntries: getDropThemeEntries()
                      )
                    ),

                    const Spacer(), // Pushes icons to the rightmost edge

                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    /*    IconButton(
                          onPressed: () {
                            //implement here
                          },
                          icon: const Icon(
                            Icons.icecream,
                            color: Colors.greenAccent,
                          ),
                          color: Colors.greenAccent)*/
                        
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ExportDialog(
                                  dialogContext: context,
                                  markdownTextExport: markdownText,
                                  markdownStyle: temp!.markdownStyle,
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.save, color: Colors.blueAccent),
                          color: Colors.blueAccent,
                        ),
                      ],
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


// class PreviewPanel extends StatelessWidget {
//   final String markdownText; // used to declare a variable that can only be assigned once...
//   // A final variable must be initialized either at the time of declaration or in a constructor (if it's an instance variable)...
//   final MarkdownStyleSheet style;

//   const PreviewPanel({
//     super.key,
//     required this.markdownText,
//     required this.style,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Card: A Material Design Card...
//     return Card(
//       elevation: 1.0,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Markdown(data: markdownText, styleSheet: style),
//       ),
//     );
//   }
// }

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
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Markdown() has a padding of 16.0
       child: Markdown(data: markdownText, styleSheet: style),
     //   child: ListView(
     //     children: _buildMarkdownWidgets(markdownText, style),
     //   ),
      ),
    );
  }

/* Not needed anymore
  // MATHJAX INTEGRATION FOR OUR MARKDOWN...
  List<Widget> _buildMarkdownWidgets(String text, MarkdownStyleSheet style) {
    List<Widget> widgets = [];

    // Split the text by lines
    List<String> lines = text.split('\n');

    for (String line in lines) {
      // Check if the line contains a math expression (e.g., enclosed in $...$ or $$...$$)
      if (line.contains(r'\$') || line.contains(r'$$')) {
        if (line.startsWith(r'$$') && line.endsWith(r'$$')) {
          // Block math expression
          widgets.add(Math.tex(
            line.replaceAll(r'$$', ''),
            textStyle: TextStyle(fontSize: 16),
          ));
        } else {
          // Inline math expression
          final parts = line.split(r'$');
          for (int i = 0; i < parts.length; i++) {
            if (i % 2 == 0) {
              widgets.add(MarkdownBody(
                data: parts[i],
                styleSheet: style,
              ));
            } else {
              widgets.add(Math.tex(
                parts[i],
                textStyle: TextStyle(fontSize: 16),
              ));
            }
          }
        }
      } else {
        widgets.add(MarkdownBody(
          data: line,
          styleSheet: style,
        ));
      }
    }

    return widgets;
  }*/
}



MarkdownStyleSheet buildMarkdownStyle(double zoom, {String? tempTheme}) {
  Map<String, dynamic> themeValues;
  if (tempTheme == null){
  themeValues = getTheme();
  } else {
  themeValues = loadThemeFileReturn(tempTheme);
  }
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
      listBullet: pStyle, // TODO: pStyle For now
      textScaler: TextScaler.linear(zoom));
}


MarkdownStyleSheet markdownStyleZoom(double zoom, MarkdownStyleSheet style){
  return style.copyWith(textScaler: TextScaler.linear(zoom));
}

/* For now, this is not needed
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
                  DropdownMenuEntry(value: "github_dark", label: "Github Theme")
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
*/


autoSave(){
  File("autosave${DateTime.now().toUtc().toIso8601String().replaceAll(':', '')}.md").writeAsStringSync(temp!.markdownText);
}