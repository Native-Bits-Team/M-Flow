


import 'package:flutter/material.dart';
import 'package:m_flow/functions/json_db.dart';

class SettingsPanel extends StatefulWidget{
  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body:  Padding(padding: EdgeInsets.all(16.0),child: Card(child: Padding(padding: EdgeInsets.all(32.0),child: Column(crossAxisAlignment: CrossAxisAlignment.stretch
      ,children: [
       // Row(children: [Text("Language: "), DropdownMenu(initialSelection: "english",dropdownMenuEntries: [DropdownMenuEntry(value: "english", label: "English")])]),
       // SizedBox(height: 10),
        Row(children: [const Text("Enable AutoSave: "), Checkbox(value: getGlobalDatabase()["settings"]["autosave"], onChanged: (newValue){
          updateAndSave(["settings"], "autosave", newValue);
          setState(() {
           // print("t");
          });
        })])
,
      Spacer(),
      Row(mainAxisAlignment: MainAxisAlignment.end,children: [TextButton.icon(label: Text("Save") ,onPressed: (){
        saveDatabase();
      }, icon: Icon(Icons.save),)],)],)))),
    );
  }
}