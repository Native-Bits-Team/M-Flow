import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m_flow/dependencies/md2pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class wwe extends StatefulWidget {
  @override
  State<wwe> createState() => _wweState();
}

class _wweState extends State<wwe> {
  ImageProvider? as;
  @override
  Widget build(BuildContext context) {
   // im= generatePdfFromMD("# Test", PdfPageFormat.a4);
   generatePdfImageFromMD("# e", PdfPageFormat.a4).then((onValue){
    setState(() {
      as = onValue;
    });
    
   });
  if (true){
    return Text("ERROR");
  } else {
    ImageProvider l = as!;
    return Image(image: l);
  }
  }
  }