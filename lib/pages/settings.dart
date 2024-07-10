


import 'package:flutter/material.dart';


void AutoSaveParameter(bool? newValue){

}

class SettingsPanel extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Expanded(child: Padding(padding: EdgeInsets.all(16.0),child: Column(crossAxisAlignment: CrossAxisAlignment.stretch
      ,children: [
        Row(children: [Text("Language: "), DropdownMenu(dropdownMenuEntries: [DropdownMenuEntry(value: "english", label: "English")])]),
        Row(children: [Text("Enable AutoSave: "), Checkbox(value: false, onChanged: AutoSaveParameter)])

      ],))),
    );
  }
}