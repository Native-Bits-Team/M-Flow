import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:m_flow/components/profile_drawer.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/flutter_markdown.dart';
import 'package:m_flow/dependencies/md2pdf/md2pdf.dart';
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
      print('Error: $e');
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
void addPrefixToStartWrap(String prefix){
    var start = leftController.selection.baseOffset;
    //var prefix = "";
    var originalLength = leftController.text.length;
    var newText = addToLineStart(leftController.text, start, prefix);
    if (newText == null){
      focusGuider.requestFocus();
      leftController.selection = TextSelection(baseOffset: start, extentOffset: start);
      return;}
    leftController.text = newText;
    var diff = newText.length - originalLength - 1;
    focusGuider.requestFocus();
    leftController.selection = TextSelection(baseOffset: start + diff, extentOffset: start+ diff );
}


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

  void updateStyle({bool zoomChangedOnly = false}) {
    if (zoomChangedOnly){
      setState(() {
      markdownStyle = buildMarkdownStyleZoomChange(markdownStyle, zoom);
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
      } else if (lines[i].startsWith('w\$')){
        lines[i] = lines[i].replaceFirst('w\$', '');
        lines[i] += 'w\$';
      } else if (lines[i].startsWith('r\$')){
        lines[i] = lines[i].replaceFirst('r\$', '');
        lines[i] += 'r\$';
      }
    }

    // Join the lines back together
    userInput = lines.join('\n');
    // Print or use the userInput as needed
    // print('User Input: $userInput');
    return userInput;
  }

  // To handle the icons (bold, italic, mathjax, ....) features gracefully
  void _formatText(String prefix, String suffix, {bool isBlock = false}) { // NOTE: prefix should be equal in length to the suffix, otherwise it may cause a problem at REF #6
    final start = leftController.selection.start;
    final end = leftController.selection.end;

    var originalLength = leftController.text.length;
    
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
      leftController.selection = TextSelection(baseOffset: start + ((leftController.text.length - originalLength)/2.0).toInt(), extentOffset: start +  ((leftController.text.length - originalLength)/2.0).toInt()); // REF #6
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

      focusGuider.requestFocus();
      leftController.selection = TextSelection(baseOffset: start + ((leftController.text.length - originalLength)/2.0).toInt(), extentOffset: end + ((leftController.text.length - originalLength)/2.0).toInt());
    }
  }


  @override
  Widget build(BuildContext context) {
    temp = this;
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            ),
        //actionsIconTheme: IconThemeData(color: Colors.red),
        ),

      // *DRAWER : -------------------------------------------------------------------------------- *
      drawer: ProfileDrawer(
        onSettingsTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsPanel()));
        },
        onDashTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const DashBoard()));
        },
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
                    IconButton(onPressed: (){
                      _formatText("-", "-");
                    }, icon: const Icon(Icons.format_underline)),

                    IconButton(
                      onPressed: () {
                        _formatText("`", "`");
                      },
                      icon: const Icon(Icons.water_drop),
                    ),
                    IconButton(
                      onPressed: () {
                        _formatText("\n```\n", "\n```\n", isBlock: true);
                      },
                      icon: const Icon(Icons.code),
                    ),
                    IconButton(onPressed: (){
                      addPrefixToStartWrap(">");
                    }, icon: const Icon(Icons.format_quote)),

                    IconButton(
                      onPressed: () async {
                        await _handleUploadImage(); // go to the top...
                      },icon: const Icon(Icons.image)
                    ),
                    IconButton(onPressed: (){
                    addPrefixToStartWrap("");
                    }, icon: const Icon(Icons.align_horizontal_left)),
                    IconButton(onPressed: (){
                      addPrefixToStartWrap("w\$");
                    }, icon: const Icon(Icons.align_horizontal_center)),
                    IconButton(onPressed: (){
                      addPrefixToStartWrap("r\$");
                    }, icon: const Icon(Icons.align_horizontal_right)),


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
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(HexColor(getTheme()["forthColor"]).value),
                          shape: RoundedRectangleBorder(side: BorderSide(),borderRadius: BorderRadius.circular(5.0)),
                          //borderOnForeground: true,
                         // clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: TextField(
                            //shap
                          textDirection: TextDirection.ltr,
                          
                          //keyboardType: ,
                          //selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
                      controller: leftController,
                      focusNode: focusGuider,
                      //strutStyle: StrutStyle(),
                      
                      decoration: const InputDecoration(
                        hintText: 'What\'s in your mind?',
                      ),
                      maxLines: null,
                      minLines: 50,
                    )))),
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
                            updateStyle(zoomChangedOnly: true);
                          });
                        },
                        icon: const Icon(Icons.zoom_in)),
                    IconButton(
                        onPressed: () {
                          zoom -= 0.2;
                          setState(() {
                            updateStyle(zoomChangedOnly: true);
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
                        trailingIcon: const Icon(Icons.arrow_drop_down, color: Colors.white60),
                        initialSelection: getDropThemeEntries().isEmpty ? "default" : widget.initTheme,
                        inputDecorationTheme: const InputDecorationTheme(
                          contentPadding: EdgeInsets.all(7.0),
                          constraints: BoxConstraints(maxHeight: 35),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
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
                    //Text("Page Count: ", ),
                    pageInfo(),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          showDialog(context: context, builder: (BuildContext context){
                            return DocumentSettings();
                          });
                        }, icon: Icon(Icons.settings)),
                        IconButton(
                          onPressed: () {
                            //print(temp!.getUserInput());
                            //print(markdownText);
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
                  true ? 
                  Expanded(
                    child: PreviewPanel(
                      markdownText: markdownText,
                      style: markdownStyle,
                    ),
                  ) : AspectRatio(aspectRatio: 0.8,
                   child: PreviewPanel(markdownText: markdownText, style: markdownStyle),),
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
      color: Color(HexColor(getTheme()["pageBackgroundColor"]).value), // TODO: CHANGE
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Markdown() has a padding of 16.0
       child: Markdown(data: markdownText, styleSheet: style),
      ),
    );
  }
}

MarkdownStyleSheet buildMarkdownStyleZoomChange(MarkdownStyleSheet style, double zoom){
  return style.copyWith(textScaler: TextScaler.linear(zoom));
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

autoSave(){
  File("autosave${DateTime.now().toUtc().toIso8601String().replaceAll(':', '')}.md").writeAsStringSync(temp!.markdownText);
}



class pageInfo extends StatefulWidget {
  @override
  State<pageInfo> createState() => _pageInfoState();
}

class _pageInfoState extends State<pageInfo> {
  int pageCount = 0;
  @override
  Widget build(BuildContext context) {
    //print("update");
    // TODO: implement build
    //throw UnimplementedError();
    getPageCount(temp!.getUserInput()).then((newPageCount){
      if (newPageCount != pageCount){
      setState(() {
        pageCount = newPageCount;
        //print("t");
      });
      //pageCount= newPageCount
    }});
    //print("update done");
    return Text("Page Count: $pageCount");// getPageCount(temp.getUserInput().toString()));
  }
}