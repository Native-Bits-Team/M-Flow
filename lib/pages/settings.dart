


import 'package:flutter/material.dart';


void AutoSaveParameter(bool? newValue){

}

class SettingsPanel extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Expanded(child: Padding(padding: EdgeInsets.all(16.0),child: Column(crossAxisAlignment: CrossAxisAlignment.stretch
      ,children: [
        Row(children: [Text("Language: "), DropdownMenu(initialSelection: "english",dropdownMenuEntries: [DropdownMenuEntry(value: "english", label: "English")])]),
        SizedBox(height: 10),
        Row(children: [Text("Enable AutoSave: "), Checkbox(value: false, onChanged: AutoSaveParameter)])

      ],))),
    );
  }
}