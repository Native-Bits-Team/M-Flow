// [HISTORY] [TRANSPARENCY] Check information_history.dart, I (Imad Laggoune) may have got expereience from making that lost file that may helped the making of this new file.


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m_flow/oss_licenses.dart';

class Info extends StatelessWidget{
  const Info({super.key});
  @override
  Widget build(BuildContext context) {
    var infoTextController = TextEditingController();
    var infoText = "";
    infoText += "M-Flow 0.1v, By Native Bits Team";
    infoText += "\n\n";
    infoText += "Developers:\n\n";
    infoText += "Imad Laggoune | Project Manager | Lead Developer\n\n";
    infoText += "Madhur Pandey | Lead Developer\n\n";
    infoText += "---------------LICENSES---------------\n\n\n";

    allDependencies.forEach((dep){
      infoText += "${dep.name} | License text:\n\n${dep.license}";

      infoText += "\n\n";
    });
    infoTextController.text = infoText;
    return Scaffold(appBar: AppBar(title: const Text("Information")),
    body: Padding(padding: const EdgeInsets.all(16.0), child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: 
    [TextButton.icon(icon: Icon(Icons.info),onPressed: (){
      showLicensePage(context: context, applicationName: "M-Flow", applicationVersion: "0.1v Beta",applicationLegalese: "By Native Bits Team", applicationIcon: Image.file(File("assets/icon.png")));
    }, label: Text("License Page")),
    SizedBox(height: 10),
      Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16.0), child: 
    TextField(
    maxLines: 3000, 
    minLines: 200,
     controller: infoTextController, onChanged: (newText){
      var oldSelection = infoTextController.selection;
      infoTextController.text = infoText;
      infoTextController.selection = oldSelection;
    },))))])));
  }
  
}