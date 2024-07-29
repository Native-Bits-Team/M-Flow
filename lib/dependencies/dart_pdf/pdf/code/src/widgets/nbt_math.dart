// This file was create by Native Bits Team
// Learning how dart_pdf widgets and md2pdf (another dependency we use) and widget_wrapper work (Imad Laggoune: "not really"), "I wrote this file to add "MathJax" feature to be exported to PDF" 
// I also looked into flutter_math_folk dependency to debug an error about missing fontSize and color, the solution was to add TextStyle that has these two values;

// DEPRECATED: This file was kept for both Historical and to credits the dependencies which "by seeing/learning and guessing how they work" helped develope this implmentation
// NOTE: this file may get removed

/*
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_math_fork/flutter_math.dart';
import '../../pdf.dart';
import '../pdf/document.dart';
import '../pdf/obj/image.dart';
import 'geometry.dart';
import 'widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart' as m;

class PdfMath extends Widget {
  PdfMath(this.text);
  final String text;
  //var box;
  @override
  void layout(Context context, BoxConstraints constraints, {bool parentUsesSize = false}) {
    print(constraints.maxWidth);
    print(constraints.minHeight);
    box = PdfRect.fromLTRB(0.0, 0.0, constraints.maxWidth, 100.0);
    // TODO: implement layout
  }
  @override
  void paint(Context context) async {
    // TODO: implement paint
    super.paint(context);
    context.canvas.drawLine(0,0,500,500);
    print(text.replaceAll(r'$$', ''));
    Image image = await ScreenshotController.widgetToUiImage(Math.tex(text.replaceAll(r'$$', ''), textStyle: m.TextStyle(fontSize: 15.0, color: Color.fromARGB(255,0 ,255 , 255))));
    //.then((image){
    ByteData? rawBytes = await image.toByteData();
    if (rawBytes == null){
      print("ERROR");
    }
    //.then((rawBytes){
      context.canvas.drawImage(PdfImage(PdfDocument(), image: rawBytes!.buffer.asUint8List(), width: image.width, height: image.height), 40, 40);
      print(image.width);
      print(image.height);
      //});
    //});
  }
  
}

*/