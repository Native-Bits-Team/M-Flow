


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:m_flow/pages/form_page.dart';


String mdLoader(){
  File fileLoad = File("test.md");
  String markdown = fileLoad.readAsStringSync();
  return markdown;
}

class DashBoard extends StatelessWidget{
  SliverGridDelegate gridDelegateRef = SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: GridView(gridDelegate: gridDelegateRef, children: [PreviewPanel(markdownText: mdLoader()), Card(),Card(), Card(),Card(), Card()])
    );
  }
}