
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/code_src/style_sheet.dart';
import 'package:m_flow/dependencies/md2pdf/md2pdf.dart';
import 'package:m_flow/widgets/preview_widgets.dart';



class ExportDialog extends StatefulWidget {
  final BuildContext dialogContext;
  final String markdownTextExport;
  final MarkdownStyleSheet markdownStyle;

  const ExportDialog({
    super.key,
    required this.dialogContext,
    required this.markdownTextExport,
    required this.markdownStyle
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  List<String> exportFormatOptions = ["HTML", "PDF", "MD"];
  String exportFormat = "PDF";
  //TextEditingController pathParameter =
    //  TextEditingController(text: "");
  TextEditingController authorName = TextEditingController(text: "");
  TextEditingController documentTitle =
      TextEditingController(text: "");
  TextEditingController documentSubject =
      TextEditingController(text: "");

  bool _showAuthorAndSubject = true;

  // METHOD ADDED TO HANDLE SWITCH PRE-FILLED TEXT B/W HTML, PDF, MD...
  void updateTextFields(String format) {
    switch (format) {
      case "HTML":
     //   pathParameter.text = "Document_1";
     //   documentTitle.text = "Document_1";
        _showAuthorAndSubject = false;
        break;
      case "PDF":
      //  pathParameter.text = "Document_1.pdf";
       // documentTitle.text = "Document_1.pdf";
        _showAuthorAndSubject = true;
        break;
      case "MD":
      //  pathParameter.text = "Document_1.md";
        //documentTitle.text = "Document_1.md";
        _showAuthorAndSubject = false;
        break;
      default:
      //  pathParameter.text = "Document_1.pdf";
        //documentTitle.text = "Document_1.pdf";
        _showAuthorAndSubject = true;
        break;
    }
  }

// // BUILD METHOD FOR EXPORT DIALOG----------------------------------------------------------------------------*

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Document Export Settings", style: TextStyle(fontWeight: FontWeight.bold), textScaler: TextScaler.linear(1.3)),
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
                  height: 300,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(
                      top: 6.0, bottom: 12.0, left: 11, right: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(
                    //    width: 300,
                  //      child: Row(
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                          //children: [
                       //     Container(
                         //     width: 100, // FIXED WIDTH FOR LABELS
                           //   padding: const EdgeInsets.only(top: 22),
                           //   child: const Text("Export Path: ",
                            //      style:
                             //         TextStyle(fontWeight: FontWeight.bold)),
                            //),
                            //const SizedBox(width: 30.0),
                     //       Expanded(
                       //       child: TextField(
                         //       controller: pathParameter,
                           //     decoration: const InputDecoration(
                             //     border: OutlineInputBorder(),
                               //   hintText: 'Enter export path',
                               // ),
                              //),
                            //),
                          //],
                      //  ),
                      //),
                     // const SizedBox(height: 10.0),
                      SizedBox(
                        width: 350,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          //  Container(
                            //  width: 100, // FIXED WIDTH FOR LABELS
                              //padding: const EdgeInsets.only(top: 22),
                              //child: 
                              const Expanded(
                                flex: 60,
                                child: 
                              Text("Doc. Title: ", strutStyle: StrutStyle(height: 3),
                                //  style:
                              //        TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            //const SizedBox(width: 30.0),
                            const Spacer(),
                            Expanded(
                              flex: 61,
                              child: TextField(
                                controller: documentTitle,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '...',
                                ),
                              ),
                            ),
                          //Spacer()
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Visibility(
                        visible: _showAuthorAndSubject,
                        child: SizedBox(
                          width: 350,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Container(
                                //width: 100, // FIXED WIDTH FOR LABELS
                                //padding: const EdgeInsets.only(top: 22),
                                //child: 
                                const Expanded(flex: 60,child: Text("Author Name: ", strutStyle: StrutStyle(height: 3),
                                  //  style:
                                    //    TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              //const SizedBox(width: 30.0),
                              const Spacer(),
                              Expanded(
                                flex: 61,
                                child: TextField(
                                  controller: authorName,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '...',
                                  ),
                                ),
                              ),
                            //Spacer()
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Visibility(
                        visible: _showAuthorAndSubject,
                        child: SizedBox(
                          width: 350,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Container(
                                //width: 100, // FIXED WIDTH FOR LABELS
                                //padding: const EdgeInsets.only(top: 14),
                                //child: 
                                const Expanded(flex: 60, child: Text("Doc. Subject: ", strutStyle: StrutStyle(height: 3),
                                  //  style:
                                    //    TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              //const SizedBox(width: 30.0),
                              const Spacer(),
                              Expanded(
                                flex: 61,
                                child: TextField(
                                  controller: documentSubject,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '...',
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
                const SizedBox(height: 1.0),
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

                      // const SizedBox(height: 25.0),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => const ProfilePage()));
                      //   },
                      //   child: const Text("Personalize First Page"),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 75.0),
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(widget.dialogContext).pop(null);
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text("Cancel", style: TextStyle(fontSize: 13.5),),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 11),
                        ),
                    //    style: TextButton.styleFrom(
                      //    shape: RoundedRectangleBorder(
                        //    borderRadius: BorderRadius.circular(10.0),
                          //),
                          //padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
                        //  side: BorderSide(color: Colors.white, width: 0.2),
                      //    shadowColor: Colors.black.withOpacity(0.3), // Shadow color and opacity
                    //      elevation: 2, // Optional: add a border color
                     //   ),
                      ),
                      const SizedBox(width: 20),
                      TextButton.icon(
                        onPressed: () {
                          var fp = FilePicker.platform;
                          fp.saveFile(dialogTitle: "Export", fileName: "Document" + "." +exportFormat.toLowerCase(), allowedExtensions: [exportFormat.toLowerCase()]).then((result){
                            if (result == null){
                              return;
                            }
                          if (exportFormat == exportFormatOptions[0]) {
                            mdtopdf(widget.markdownTextExport,
                                result, true, widget.markdownStyle);
                        Navigator.of(widget.dialogContext).pop();
                          } else if (exportFormat == exportFormatOptions[1]) {
                            mdtopdf(widget.markdownTextExport,
                                result, false, widget.markdownStyle);
                            Navigator.of(widget.dialogContext).pop();
                          } else {
                            File(result)
                                .writeAsString(widget.markdownTextExport)
                                .then((value) {
                              Navigator.of(widget.dialogContext).pop();
                            });
                          }
                          });
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Export", style: TextStyle(fontSize: 13.5),),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 11),
                        ),
                     //   style: TextButton.styleFrom(
                       //   shape: RoundedRectangleBorder(
                         //   borderRadius: BorderRadius.circular(10.0),
                         // ),
                         // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
                        //  side: BorderSide(color: Colors.white, width: 0.2), // Thinner border
                     //     shadowColor: Colors.black,//.withOpacity(0.9), // Shadow color and opacity
                       //   elevation: 4, // Shadow elevation
                        //),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(child: DocumentPreview(widget.markdownTextExport, markdownStyle: widget.markdownStyle,))
          ],
        ),
      ],
    );
  }
}