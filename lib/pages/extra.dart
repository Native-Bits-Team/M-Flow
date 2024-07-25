// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:m_flow/components/profile_drawer.dart';
// import 'package:m_flow/dependencies/flutter_markdown/code/flutter_markdown.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:m_flow/dependencies/md2pdf.dart';
// import 'package:m_flow/functions/json_db.dart';
// import 'package:m_flow/functions/mark_down_styler.dart';
// import 'package:m_flow/functions/string_utilities.dart';
// import 'package:pdf/pdf.dart';


// // _FormPageState? temp;

// class FormPage extends StatefulWidget {
//   final String initText;

//   const FormPage({super.key, required this.initText}); // '?': Denotes that key can be of type 'null' or 'key'...
//   // We can choose not to provide a Key when instantiating FormPage...
//   //final String initText = "";
//   @override
//   State<FormPage> createState() => _FormPageState();
// }

// class _FormPageState extends State<FormPage> {
//   TextEditingController leftController = TextEditingController();
//   String markdownText = "";  // Initialized an empty variable of type 'String' to store markdown text...
//   MarkdownStyleSheet markdownStyle = MarkdownStyleSheet();
//   Color? themeBackgroundColor; // Maybe replace with global theme
//   Color? formPageBackgroundColor;
//   // bool stopper = true;
//   double zoom = 1.0;


//   // bool _isUpdatingStyle = false; // if don't wanna use debounce, uncomment this, use approach I...
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     markdownText = widget.initText;
//     leftController.text = markdownText;
//     leftController.addListener(_updateRightField);
//     updateStyle(); // Call updateStyle once during initialization
//   }

//   @override
//   void dispose() {
//     // Dispose the controllers when the widget is disposed, So that state object is removed permanently from the tree...
//     leftController.dispose(); // Important to dispose of the controllers to free up resources and avoid memory leaks...
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _updateRightField() {
//     setState(() {
//       markdownText = getUserInput(); // get user input from this method...
//     });
//   }

// //  // updateStyle() method OLD ----------------------------------------
//   // void updateStyle() {
//   //   var markdownStyleValue = buildMarkdownStyle(zoom);
//   //   var backgroundColors = getBackgroundColors();
//   //   setState(() {
//   //     markdownStyle = markdownStyleValue;
//   //     themeBackgroundColor = backgroundColors[0];
//   //     formPageBackgroundColor = backgroundColors[1];
//   //   });
//   // }

// //  // updateStyle() method OPTIMIZATION APPROACH - I (using _isUpdatingStyle())----------*DO NOT REMOVE THIS*------------------------------

//   // void updateStyle() {
//   //   if (_isUpdatingStyle) return;

//   //   var markdownStyleValue = buildMarkdownStyle(zoom);
//   //   var backgroundColors = getBackgroundColors();

//   //   setState(() {
//   //     _isUpdatingStyle = true;
//   //     // Your style update logic here
//   //     markdownStyle = markdownStyleValue;
//   //     themeBackgroundColor = backgroundColors[0];
//   //     formPageBackgroundColor = backgroundColors[1];
      
//   //     _isUpdatingStyle = false;
//   //   });
//   // }

// // ------------------------- * if DeBounce creates a 'Race-Condition' we'll remove it... * ------------------------------------------



// //  // updateStyle() method OPTIMIZATION APPROACH - II (using _debounce())----------------------------------------

//   void updateStyle() {

//     if (_debounce?.isActive ?? false) _debounce!.cancel();

//     _debounce = Timer(Duration(milliseconds: 90), () {
//       var markdownStyleValue = buildMarkdownStyle(zoom);
//       var backgroundColors = getBackgroundColors();

//       setState(() {
//         markdownStyle = markdownStyleValue;
//         themeBackgroundColor = backgroundColors[0];
//         formPageBackgroundColor = backgroundColors[1];
//       });
//     });
//   }

//   // Implementing Dynamic Line Manipulation -
//   // Used to provide feature where 'Users' can move around any particular line while still rendering the markdown...
//   String getUserInput() {
//     String userInput = leftController.text;  // Get the entire user input
//     // Split the input into lines
//     List<String> lines = userInput.split('\n');

//     // Iterate through each line and replace 'm$ ' with a zero-width space if it is at the start of the line
//     for (int i = 0; i < lines.length; i++) {
//       if (lines[i].startsWith('m\$ ')) {
//         lines[i] = lines[i].replaceFirst('m\$ ', '\u200B'); // Unicode character for a zero-width space (ZWSP). 
//         // It is a non-printing character that doesn't produce any visible space or mark, but it is still present in the text
//       }
//     }

//     // Join the lines back together
//     userInput = lines.join('\n');
//     // Print or use the userInput as needed
//     // print('User Input: $userInput');
//     return userInput;
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // if (stopper) {
//     //   stopper = false;
//     //   updateStyle();
//     // }

//     // temp = this;
//     return Scaffold( 
//       backgroundColor: formPageBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 5, 24, 32),
//         toolbarHeight: 40.0,
//         centerTitle: true,
//         title: const Text("Welcome to M-Flow Document Making Software !"),
//         titleTextStyle: const TextStyle(color: Colors.white),
//       ),
      
//       // *DRAWER : -------------------------------------------------------------------------------- *
//       drawer: ProfileDrawer(
//         onExportTap: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return ExportDialog(
//                 dialogContext: context,
//                 markdownTextExport: markdownText,
//               );
//             },
//           );
//           },
//         onLogoutTap: (){},
//       ),
//       // *DRAWER : -------------------------------------------------------------------------------- *

//       body: Padding(
//         padding: const EdgeInsets.all(27),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       IconButton(onPressed: () {      
//                         if (leftController.selection.start == leftController.selection.end){
//                         leftController.text = addSidesToWord(leftController.text, leftController.selection.start, "**");
//                         } else{
//                         String newText = "**";
//                         newText += leftController.text.substring(leftController.selection.start, leftController.selection.end);
//                         newText += "**";
//                         leftController.text = leftController.text.replaceRange(leftController.selection.start, leftController.selection.end, newText);
//                         }              
//                       }, icon: const Icon(Icons.format_bold)),
//                       IconButton(onPressed: () {
//                         if (leftController.selection.start == leftController.selection.end){
//                         leftController.text = addSidesToWord(leftController.text, leftController.selection.start, "*");
//                         } else{
//                         String newText = "*";
//                         newText += leftController.text.substring(leftController.selection.start, leftController.selection.end);
//                         newText += "*";
//                         leftController.text = leftController.text.replaceRange(leftController.selection.start, leftController.selection.end, newText);
//                         }
//                       }, icon: const Icon(Icons.format_italic)),
//                       IconButton(onPressed: () {}, icon: const Icon(Icons.format_underline)),
//                       IconButton(onPressed: () {}, icon: const Icon(Icons.code)),
//                       IconButton(onPressed: () {}, icon: const Icon(Icons.format_quote)),
//                     ]),
//                   Expanded(
//                     child: TextField(
//                       controller: leftController,
//                       decoration: const InputDecoration(
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.lightBlue),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.white54),
//                         ),
//                         border: OutlineInputBorder(),
//                         hintText: 'What\'s on your mind?',
//                         hintStyle: TextStyle(color: Colors.white38)
//                       ),
//                       maxLines: null,
//                       minLines: 50,
//                       style: const TextStyle(color: Colors.white60),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 47), // Spacer

//             Expanded(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [IconButton(onPressed: () {
//                       zoom += 0.2;
//                       setState(() {
//                         updateStyle();
//                       });
//                     }, icon: const Icon(Icons.zoom_in)),
//                     IconButton(onPressed: () {
//                       zoom -= 0.2;
//                       setState(() {
//                         updateStyle();
//                       });
//                     }, icon: const Icon(Icons.zoom_out)),
//                     const SizedBox(width: 10),
                
//                     // Expanded(child: DropdownMenu(
//                     //   //label: const Text("Theme: "),
//                     //   trailingIcon: const Icon(Icons.arrow_drop_down),
//                     //   initialSelection: "github",
//                     //   inputDecorationTheme: const InputDecorationTheme(contentPadding: EdgeInsets.all(0), constraints: BoxConstraints(maxHeight: 40), isCollapsed: true),
//                     //   textStyle: const TextStyle(color: Colors.white60, fontSize: 16),
//                     //   onSelected: (valueName) {
//                     //     setState(() {
//                     //       updateStyle();
//                     //     });
//                     //   },
//                     //   dropdownMenuEntries: const [
//                     //     DropdownMenuEntry(value: "github", label: "Github Theme")
//                     //   ],
//                     // )),
              
//                     // IconButton(
//                     //     onPressed: () {
//                     //       // implement here
//                     //     }, icon: const Icon(Icons.icecream, color: Colors.greenAccent,), color: Colors.greenAccent),
//                     // IconButton(
//                     //     onPressed: () {
//                     //       showDialog(
//                     //         context: context,
//                     //         builder: (BuildContext context) {
//                     //           return ExportDialog(
//                     //             dialogContext: context,
//                     //             markdownTextExport: markdownText,
//                     //           );
//                     //         },
//                     //       );
//                     //     }, icon: const Icon(Icons.save, color: Colors.blueAccent), color: Colors.blueAccent,),
//                     ]),
                    
//                     Expanded(
//                       child: PreviewPanel(
//                         markdownText: markdownText,
//                         style: markdownStyle,
//                         backgroundColor: themeBackgroundColor
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PreviewPanel extends StatelessWidget {
//   final String markdownText; // used to declare a variable that can only be assigned once...
//   // A final variable must be initialized either at the time of declaration or in a constructor (if it's an instance variable)...
//   final MarkdownStyleSheet style;
//   final Color? backgroundColor;

//   const PreviewPanel({
//     super.key,
//     required this.markdownText,
//     required this.style,
//     this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Card: A Material Design Card...
//     return Card(
//       shadowColor: Colors.grey,
//       elevation: 1.0,
//       color: backgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Markdown(data: markdownText, styleSheet: style),
//       ),
//     );
//   }
// }

// class ExportDialog extends StatefulWidget {
//   final BuildContext dialogContext;
//   final String markdownTextExport;

//   const ExportDialog({
//     super.key,
//     required this.dialogContext,
//     required this.markdownTextExport,
//   });

//   @override
//   State<ExportDialog> createState() => _ExportDialogState();
// }

// class _ExportDialogState extends State<ExportDialog> {
//   List<String> exportFormatOptions = ["HTML", "PDF", "MD"];
//   String exportFormat = "PDF";
//   TextEditingController pathParameter = TextEditingController(text: "document_1.pdf");
//   TextEditingController authorName = TextEditingController(text: "Mr. YOU");
//   TextEditingController documentTitle = TextEditingController(text: "Document\_1.pdf");
//   TextEditingController documentSubject = TextEditingController(text: "Be Creative...");
  
//   bool _showAuthorAndSubject = true;


//   // METHOD ADDED TO HANDLE SWITCH PRE-FILLED TEXT B/W HTML, PDF, MD...
//   void updateTextFields(String format) {
//     switch (format) {
//       case "HTML":
//         pathParameter.text = "Document_1.html";
//         documentTitle.text = "Document_1.html";
//         _showAuthorAndSubject = false;
//         break;
//       case "PDF":
//         pathParameter.text = "Document_1.pdf";
//         documentTitle.text = "Document_1.pdf";
//         _showAuthorAndSubject = true;
//         break;
//       case "MD":
//         pathParameter.text = "Document_1.md";
//         documentTitle.text = "Document_1.md";
//         _showAuthorAndSubject = false;
//         break;
//       default:
//         pathParameter.text = "Document_1.pdf";
//         documentTitle.text = "Document_1.pdf";
//         _showAuthorAndSubject = true;
//         break;
//     }
//   }

// // // BUILD METHOD FOR EXPORT DIALOG----------------------------------------------------------------------------*

//   @override
//   Widget build(BuildContext context) {
//     return SimpleDialog(
//       backgroundColor: Colors.blueGrey[100],
//       title: const Text("Document Export Settings"),
//       elevation: 3.0,
//       contentPadding: const EdgeInsets.only(top:26, bottom:12.0, left: 11, right: 11),
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 Container(
//                   height: 245,
//                   margin: EdgeInsets.only(top: 10),
//                   padding: const EdgeInsets.only(top:6.0, bottom:12.0, left: 11, right: 11),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(color: Colors.blueGrey),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 300,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [

//                             Container(
//                               width: 100, // FIXED WIDTH FOR LABELS
//                               padding: EdgeInsets.only(top: 22),
//                               child: const Text("Export Path: ", style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),

//                             const SizedBox(width: 30.0),
//                             Expanded(
//                               child: TextField(
//                                 controller: pathParameter,
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter export path',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10.0),
//                       SizedBox(
//                         width: 300,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [

//                             Container(
//                               width: 100, // FIXED WIDTH FOR LABELS
//                               padding: EdgeInsets.only(top: 22),
//                               child: const Text("Doc Title: ", style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),

//                             const SizedBox(width: 30.0),
//                             Expanded(
//                               child: TextField(
//                                 controller: documentTitle,
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter Doc Title',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10.0),
//                       Visibility(
//                         visible: _showAuthorAndSubject,
//                         child: SizedBox(
//                           width: 300,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
                        
//                               Container(
//                                 width: 100, // FIXED WIDTH FOR LABELS
//                                 padding: EdgeInsets.only(top: 22),
//                                 child: const Text("Author Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
//                               ),
                        
//                               const SizedBox(width: 30.0),
//                               Expanded(
//                                 child: TextField(
//                                   controller: authorName,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     hintText: 'Enter author name',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10.0),
//                       Visibility(
//                         visible: _showAuthorAndSubject,
//                         child: SizedBox(
//                           width: 300,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
                              
//                               Container(
//                                 width: 100, // FIXED WIDTH FOR LABELS
//                                 padding: EdgeInsets.only(top: 14),
//                                 child: const Text("Doc Subject: ", style: TextStyle(fontWeight: FontWeight.bold)),
//                               ),
                        
//                               const SizedBox(width: 30.0),
//                               Expanded(
//                                 child: TextField(
//                                   controller: documentSubject,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     hintText: 'Enter Doc Subject',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 Container(
//                   padding: const EdgeInsets.all(12.0),
//                   // decoration: BoxDecoration(
//                   //   borderRadius: BorderRadius.circular(12),
//                   //   border: Border.all(color: Colors.blueGrey),
//                   // ),
//                   child: Column(
//                     children: [
//                       // const Text("File Format: ", style: TextStyle(fontWeight: FontWeight.bold)),
//                       // const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           const Text("HTML"),
//                           Radio(
//                             value: exportFormatOptions[0],
//                             groupValue: exportFormat,
//                             onChanged: (Object? newSelect) {
//                               setState(() {
//                                 exportFormat = newSelect.toString();
//                                 updateTextFields(exportFormat); // UPDATES THE PRE-FILLED TEXTS
//                               });
//                             },
//                           ),
//                           const SizedBox(width: 10.0),
//                           const Text("PDF"),
//                           Radio(
//                             value: exportFormatOptions[1],
//                             groupValue: exportFormat,
//                             onChanged: (Object? newSelect) {
//                               setState(() {
//                                 exportFormat = newSelect.toString();
//                                 updateTextFields(exportFormat); // UPDATES THE PRE-FILLED TEXTS
//                               });
//                             },
//                           ),
//                           const SizedBox(width: 10.0),
//                           const Text("MD"),
//                           Radio(
//                             value: exportFormatOptions[2],
//                             groupValue: exportFormat,
//                             onChanged: (Object? newSelect) {
//                               setState(() {
//                                 exportFormat = newSelect.toString();
//                                 updateTextFields(exportFormat); // UPDATES THE PRE-FILLED TEXTS
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 75.0),
//                 SizedBox(
//                   width: 400,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       TextButton.icon(
//                         onPressed: () {
//                           Navigator.of(widget.dialogContext).pop(null);
//                         },
//                         icon: const Icon(Icons.cancel),
//                         label: const Text("Cancel"),
//                       ),
//                       TextButton.icon(
//                         onPressed: () {
//                           if (exportFormat == exportFormatOptions[0]) {
//                             mdtopdf(widget.markdownTextExport, pathParameter.text, true);
//                           } else if (exportFormat == exportFormatOptions[1]) {
//                             mdtopdf(widget.markdownTextExport, pathParameter.text, false);
//                           } else {
//                             File(pathParameter.text).writeAsString(widget.markdownTextExport).then((value) {
//                               Navigator.of(widget.dialogContext).pop();
//                             });
//                           }
//                         },
//                         icon: const Icon(Icons.save),
//                         label: const Text("Export"),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 30),
//             Column(
//               children: [
//                 SizedBox(width: 300, child: DocumentPreview(widget.markdownTextExport))
//               ],
//             ),
//           ],
//         ),
//       ],
//       );
//     }
//   }

// // BUILD METHOD FOR EXPORT DIALOG (ENDS HERE)-----------------------------------------------------------------**


// MarkdownStyleSheet buildMarkdownStyle(double zoom) {
//   Map<String, dynamic> themeValues = getTheme();

//   TextStyle? h1Style;
//   TextStyle? h2Style;
//   TextStyle? h3Style;


//   TextStyle? pStyle;
//   TextStyle? aStyle;
//   TextStyle? codeStyle;
//   Decoration? codeblockDecoration;
//   Decoration? blockquoteDecoration;

//   themeValues.forEach((key, value){

//     switch (key) {
//       case "h1":
//         h1Style = makeTextStyleJson(value);
//         break;
//       case "h2":
//         h2Style = makeTextStyleJson(value);
//         break;
//       case "h3":
//         h3Style = makeTextStyleJson(value);
//         break;
//       case "p":
//         pStyle = makeTextStyleJson(value);
//         break;
//       case "a":
//         aStyle = makeTextStyleJson(value);
//         break;
//       case "code":
//         codeStyle = makeTextStyleJson(value);
//         break;
//       case "codeblockDecoration":
//         codeblockDecoration = makeBoxDecorationJson(value);
//         break;
//       case "blockquoteDecoration":
//         blockquoteDecoration = makeBoxDecorationJson(value);
//         break;
//       default:
//     }
//   });

//   return MarkdownStyleSheet(
//   code: codeStyle,
//   codeblockDecoration: codeblockDecoration,
//   h1: h1Style,
//   h2: h2Style,
//   h3: h3Style,
//   p: pStyle,
//   a: aStyle,
//   blockquoteDecoration: blockquoteDecoration,
//   textScaler: TextScaler.linear(zoom)
//   );
// }

// List<Color> getBackgroundColors() {
//   return [
//     Color(HexColor(getTheme()["backgroundColor"]).value),
//     Color(HexColor(getTheme()["pageBackgroundColor"]).value),
//   ];
// }

// class ParameterDialog extends StatefulWidget {
//   final BuildContext dialogContext;

//   const ParameterDialog({super.key, required this.dialogContext});

//   @override
//   State<ParameterDialog> createState() => _ParameterDialogState();
// }

// class _ParameterDialogState extends State<ParameterDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return SimpleDialog(
//       title: const Text("Apperance Parameters"),
//       elevation: 3.0,
//       contentPadding: const EdgeInsets.all(24.0),
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: DropdownMenu(
//                 label: const Text("Theme: "),
//                 trailingIcon: const Icon(Icons.arrow_drop_down),
//                 textStyle: const TextStyle(color: Colors.white60, backgroundColor: Colors.white60),
//                 onSelected: (valueName) {
//                   Navigator.of(widget.dialogContext).pop();
//                 },
//                 dropdownMenuEntries: const [
//                   DropdownMenuEntry(value: "github", label: "Github Theme", style: ButtonStyle(textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white60))))
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             TextButton.icon(
//               onPressed: () {
//                 Navigator.of(widget.dialogContext).pop(null);
//               },
//               icon: const Icon(Icons.cancel),
//               label: const Text("Cancel"),
//             ),
//             TextButton.icon(
//               onPressed: () {},
//               icon: const Icon(Icons.save),
//               label: const Text("Save"),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }


// class DocumentPreview extends StatefulWidget {
//   final String content;

//   DocumentPreview(this.content, {super.key});

//   @override
//   _DocumentPreviewState createState() => _DocumentPreviewState();
// }

// class _DocumentPreviewState extends State<DocumentPreview> {
//   Image? previewImage;

//   @override
//   Widget build(BuildContext context) {
//     double size = 300;
//     double ratio = PdfPageFormat.a4.height / PdfPageFormat.a4.width;
//     ratio *= 300;

//     if (widget.content.isEmpty) {
//       return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => FullPreviewScreen(widget.content),
//             ),
//           );
//         },
//         child: Container(
//           width: size,
//           height: ratio,
//           child: Card(
//             child: const Center(
//               child: Text(
//                 "Nothing to display", 
//                 style: TextStyle(
//                   color: Colors.red
//                   ),
//                 ),
//             ),
//           ),
//         ),
//       );
//     }

//     if (previewImage == null) {
//       generatePdfImageFromMD(widget.content).then((image) {
//         setState(() {
//           previewImage = image;
//         });
//       });
//     }

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => FullPreviewScreen(widget.content),
//           ),
//         );
//       },
//       child: Container(
//         width: size,
//         height: ratio,
//         child: Card(
//           child: previewImage != null 
//             ? previewImage 
//             : const Center(child: CircularProgressIndicator()),
//         ),
//       ),
//     );
//   }
// }

// class FullPreviewScreen extends StatefulWidget {
//   final String content;

//   const FullPreviewScreen(this.content, {super.key});

//   @override
//   _FullPreviewScreenState createState() => _FullPreviewScreenState();
// }

// class _FullPreviewScreenState extends State<FullPreviewScreen> {
//   Image? previewImage;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.content.isNotEmpty) {
//       generatePdfImageFromMD(widget.content).then((image) {
//         setState(() {
//           previewImage = image;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double size = 600;
//     double ratio = PdfPageFormat.a4.height / PdfPageFormat.a4.width;
//     ratio *= size;

//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 2, 22, 32),
//       appBar: AppBar(
//         toolbarHeight: 28,
//         backgroundColor: Color.fromARGB(255, 2, 22, 32),
//       ),
//       body: Center(
//         child: widget.content.isEmpty
//             ? const Text("Nothing to display", style: TextStyle(color: Colors.red))
//             : SingleChildScrollView(
//                 child: Container(
//                   width: size,
//                   height: ratio,
//                   decoration: BoxDecoration(),
//                   child: Card(
//                     child: previewImage != null 
//                       ? previewImage 
//                       : const Center(child: CircularProgressIndicator()),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }


                    
                  //   IconButton(
                  //     onPressed: () async {
                  //       final ImagePicker _picker = ImagePicker();
                  //       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  //       if (image != null) {
                  //         // Store the image temporarily
                  //         final Directory tempDir = await getTemporaryDirectory();
                  //         final File tempImage = await File(image.path).copy('${tempDir.path}/temp_image.jpg');
                  //         final String url = 'file://${tempImage.path}';
                  //         print(url);
                  //         final HttpServer server = await HttpServer.bind('localhost', 8080, shared: true);
                  //         server.listen((HttpRequest request) {
                  //           final File imageFile = File(tempImage.path);
                  //           request.response.headers.contentType = ContentType('image', 'jpeg');
                  //           imageFile.openRead().pipe(request.response).catchError((e) {
                  //             request.response.statusCode = HttpStatus.internalServerError;
                  //             request.response.close();
                  //           });
                  //         });

                  //         final Uri url1 = Uri.parse('http://localhost:8080/temp_image.jpg');
                  //         print('Image can be accessed at: $url1');
                  //       }
                  //     }, icon: const Icon(Icons.upload_file)
                  //   )
                  // ]),











//                   Make sure to add the necessary permissions to your AndroidManifest.xml file to read and write files:

// xml

// Verify

// Open In Editor
// Edit
// Copy code
// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
// This should allow you to store the image in the app's directory and use it in your markdown content.














  // Future<void> _handleUploadImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image!= null) {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final file = File('${directory.path}/image.png');
  //       await file.writeAsBytes(await image.readAsBytes());
  //       final imageData = await file.readAsBytes();
  //       final imagePath = file.path;
  //       setState(() {
  //         // final markdownText = '![Image](data:image/png;base64,${base64Encode(imageData)})';
  //         final markdownTex = '![Image]($imagePath)';
  //         leftController.text += markdownTex;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     // Handle the error, e.g., show an error message to the user
  //   }
  // }



        // body: Padding(
        // padding: const EdgeInsets.all(14),
        // child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Expanded(
        //       child: Column(
        //         children: [
        //           Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        //             IconButton(
        //                 onPressed: () {
        //                   if (leftController.selection.start ==
        //                       leftController.selection.end) {
        //                     leftController.text = addSidesToWord(
        //                         leftController.text,
        //                         leftController.selection.start,
        //                         "**");
        //                   } else {
        //                     String newText = "**";
        //                     newText += leftController.text.substring(
        //                         leftController.selection.start,
        //                         leftController.selection.end);
        //                     newText += "**";
        //                     leftController.text = leftController.text
        //                         .replaceRange(leftController.selection.start,
        //                             leftController.selection.end, newText);
        //                   }
        //                 },
        //                 icon: const Icon(Icons.format_bold)),
        //             IconButton(
        //                 onPressed: () {
        //                   if (leftController.selection.start ==
        //                       leftController.selection.end) {
        //                     leftController.text = addSidesToWord(
        //                         leftController.text,
        //                         leftController.selection.start,
        //                         "*");
        //                   } else {
        //                     String newText = "*";
        //                     newText += leftController.text.substring(
        //                         leftController.selection.start,
        //                         leftController.selection.end);
        //                     newText += "*";
        //                     leftController.text = leftController.text
        //                         .replaceRange(leftController.selection.start,
        //                             leftController.selection.end, newText);
        //                   }
        //                 },
        //                 icon: const Icon(Icons.format_italic)),
        //             IconButton(
        //                 onPressed: () {},
        //                 icon: const Icon(Icons.format_underline)),
        //             IconButton(onPressed: () {
        //               if (leftController.selection.start ==
        //                       leftController.selection.end) {
        //                     leftController.text = addSidesToWord(
        //                         leftController.text,
        //                         leftController.selection.start,
        //                         "`");
        //                   } else {
        //                     String newText = "```\n";
        //                     newText += leftController.text.substring(
        //                         leftController.selection.start,
        //                         leftController.selection.end);
        //                     newText += "\n```";
        //                     leftController.text = leftController.text
        //                         .replaceRange(leftController.selection.start,
        //                             leftController.selection.end, newText);
        //                   }
        //             }, icon: const Icon(Icons.code)),
        //             IconButton(
        //                 onPressed: () {
        //                                         if (leftController.selection.start ==
        //                       leftController.selection.end) {
        //                     leftController.text = addSidesToWord(
        //                         leftController.text,
        //                         leftController.selection.start,
        //                         "`");
        //                   } else {
        //                     String newText = "```\n";
        //                     newText += leftController.text.substring(
        //                         leftController.selection.start,
        //                         leftController.selection.end);
        //                     newText += "\n```";
        //                     leftController.text = leftController.text
        //                         .replaceRange(leftController.selection.start,
        //                             leftController.selection.end, newText);
        //                   }
        //                 }, icon: const Icon(Icons.format_quote)
        //             ),
                    
        //             IconButton(
        //               onPressed: () async {
        //                 await _handleUploadImage(); // go to the top...
        //               },icon: const Icon(Icons.upload_file)
        //             ),

















      // body: Padding(
      //   padding: const EdgeInsets.all(14),
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Expanded(
      //         child: Column(
      //           children: [
      //             Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      //               IconButton(
      //                 onPressed: () {
      //                   int start = leftController.selection.start;
      //                   int end = leftController.selection.end;

      //                   if (start == -1 || end == -1) {
      //                     return; // Invalid selection
      //                   }

      //                   if (start == end) {
      //                     // Handle when no text is selected
      //                     leftController.text = addSidesToWord(
      //                       leftController.text,
      //                       start,
      //                       "**",
      //                     );
      //                   } else {
      //                     // Handle when text is selected
      //                     int start = leftController.selection.start;
      //                     int end = leftController.selection.end;
      //                     String selectedText = leftController.text.substring(start, end);
      //                     String newText;
      
      //                     if (selectedText.startsWith("**") && selectedText.endsWith("**")) {
      //                       // Remove bold formatting
      //                       newText = selectedText.substring(2, selectedText.length - 2);
      //                     } else {
      //                       // Add bold formatting
      //                       newText = "**$selectedText**";
      //                     }
      
      //                     leftController.text = leftController.text.replaceRange(start, end, newText);
      //                   }
      //                 },
      //                 icon: const Icon(Icons.format_bold),
      //               ),
      //               IconButton(
      //                 onPressed: () {
      //                   if (leftController.selection.start == leftController.selection.end) {
      //                     // Handle when no text is selected
      //                     leftController.text = addSidesToWord(
      //                       leftController.text,
      //                       leftController.selection.start,
      //                       "*",
      //                     );
      //                   } else {
      //                     // Handle when text is selected
      //                     int start = leftController.selection.start;
      //                     int end = leftController.selection.end;
      //                     String selectedText = leftController.text.substring(start, end);
      //                     String newText;
      
      //                     if (selectedText.startsWith("*") && selectedText.endsWith("*")) {
      //                       // Remove italic formatting
      //                       newText = selectedText.substring(1, selectedText.length - 1);
      //                     } else {
      //                       // Add italic formatting
      //                       newText = "*$selectedText*";
      //                     }
      
      //                     leftController.text = leftController.text.replaceRange(start, end, newText);
      //                   }
      //                 },
      //                 icon: const Icon(Icons.format_italic),
      //               ),
      //               IconButton(
      //                   onPressed: () {},
      //                   icon: const Icon(Icons.format_underline)),
      //               IconButton(onPressed: () {
      //                 if (leftController.selection.start ==
      //                         leftController.selection.end) {
      //                       leftController.text = addSidesToWord(
      //                           leftController.text,
      //                           leftController.selection.start,
      //                           "`");
      //                     } else {
      //                       String newText = "```\n";
      //                       newText += leftController.text.substring(
      //                           leftController.selection.start,
      //                           leftController.selection.end);
      //                       newText += "\n```";
      //                       leftController.text = leftController.text
      //                           .replaceRange(leftController.selection.start,
      //                               leftController.selection.end, newText);
      //                     }
      //               }, icon: const Icon(Icons.code)),
      //               IconButton(
      //                   onPressed: () {
      //                                           if (leftController.selection.start ==
      //                         leftController.selection.end) {
      //                       leftController.text = addSidesToWord(
      //                           leftController.text,
      //                           leftController.selection.start,
      //                           "`");
      //                     } else {
      //                       String newText = "```\n";
      //                       newText += leftController.text.substring(
      //                           leftController.selection.start,
      //                           leftController.selection.end);
      //                       newText += "\n```";
      //                       leftController.text = leftController.text
      //                           .replaceRange(leftController.selection.start,
      //                               leftController.selection.end, newText);
      //                     }
      //                   }, icon: const Icon(Icons.format_quote)
      //               ),
                    
      //               IconButton(
      //                 onPressed: () async {
      //                   await _handleUploadImage(); // go to the top...
      //                 },icon: const Icon(Icons.upload_file)
      //               ),


      //               IconButton(
      //                 onPressed: () {
      //                   final mathExpressionTemplate = r'$$your_math_expression_here$$';
      //                   leftController.text = leftController.text.replaceRange(
      //                     leftController.selection.start,
      //                     leftController.selection.end,
      //                     mathExpressionTemplate,
      //                   );
      //                 },
      //                 icon: const Icon(Icons.functions),
      //               )
      //             ]),
      //             Expanded(
      //               child: TextField(
      //                 controller: leftController,
      //                 decoration: const InputDecoration(
      //                   hintText: 'What\'s on your mind?',
      //                 ),
      //                 maxLines: null,
      //                 minLines: 50,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),

      //       const SizedBox(width: 47), // Spacer


                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.white60, width: 1),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: DropdownButtonFormField(
                    //       decoration: InputDecoration(
                    //         contentPadding: EdgeInsets.all(10.0),
                    //         border: InputBorder.none,
                    //         focusedBorder: InputBorder.none,
                    //         enabledBorder: InputBorder.none,
                    //         isCollapsed: true,
                    //       ),
                    //       style: TextStyle(fontSize: 16, color: Colors.white),
                    //       icon: Icon(Icons.arrow_drop_down, color: Colors.white60),
                    //       iconSize: 24,
                    //       elevation: 0,
                    //       value: dropEntries.first.value, // TODO: FIX THIS

                    //       onChanged: (valueName) {
                    //         setState(() {
                    //           loadThemeFile(valueName);
                    //           updateStyle();
                    //         });
                    //       },
                    //       items: dropEntries.map((entry) {
                    //         return DropdownMenuItem(
                    //           value: entry.value,
                    //           child: Text(entry.label, style: TextStyle(fontSize: 16)),
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    // )