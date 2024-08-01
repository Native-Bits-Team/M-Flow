import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


Map<String, dynamic> globalDatabase = {};
Map<String, dynamic> globalTheme = {};
List<DropdownMenuEntry<Object>> themeDropEntries = [const DropdownMenuEntry(value: "default", label: "Default")];


updateAndSave(List<String> parameterPath,String key, dynamic value){
  Map<String, dynamic> tempGlobalDatabase = globalDatabase;
  for (String i in parameterPath){
    tempGlobalDatabase = tempGlobalDatabase[i];
  }
  tempGlobalDatabase[key] = value;
  for (String i in parameterPath.reversed){
    tempGlobalDatabase = {i: tempGlobalDatabase};
  }
  globalDatabase.addAll(tempGlobalDatabase);
}

initDatabaseAndThemes(){

  if(File("user.json").existsSync()){
    globalDatabase = jsonDecode(File("user.json").readAsStringSync());
    loadThemeFile(globalDatabase["settings"]["lastTheme"]);
  } else {
    globalDatabase = newDatabase();
    loadThemeFile("github_dark");
  }

  updateDropThemeEntries();
}

newDatabase(){
  var file = File("user.json").openWrite();
  Map<String, dynamic> initValues = {
        "user": {
        "name": "user"
    },
    "settings": {
        "signature": false,
        "compress": false,
        "deflat": false,
        "autosave": true,
        "lastFormat": "pdf",
        "lastTheme": "github",
        "lastNameUsed": ""
    },
    "projects": {
        "recentOpen": {},
        "list": {}
    }
  };

  file.write(jsonEncode(initValues));
  file.close();
}

getTheme(){
  return globalTheme;
}

getDatabase(){
  return globalDatabase;
}


saveDatabase(){
  var file = File("user.json").openWrite();
  file.write(jsonEncode(globalDatabase));
}

void addRecentOpen(String? path, String? fileName) {
    var recentOpenList = globalDatabase["projects"]["recentOpen"];
    String? keyToRemove;
    int lastKey = 0;
    if (recentOpenList.keys.isNotEmpty) {
      lastKey = int.parse(recentOpenList.keys.last) + 1;
    }

    recentOpenList.forEach((key, value) {
      if (recentOpenList[key].toString() ==
          {"filePath": path, "fileName": fileName}.toString()) {
        keyToRemove = key;
        return;
      }
    });
    if (keyToRemove != null) {
      if (recentOpenList.keys.isNotEmpty) {
        if (recentOpenList[recentOpenList.keys.last].toString() ==
            {"filePath": path, "fileName": fileName}.toString()) {
          return;
        }
      }
      globalDatabase["projects"]["recentOpen"].remove(keyToRemove);
      globalDatabase["projects"]["recentOpen"].addAll({
        lastKey.toString(): {"filePath": path, "fileName": fileName}
      });
    } else {
      globalDatabase["projects"]["recentOpen"].addAll({
        lastKey.toString(): {"filePath": path, "fileName": fileName}
      });
    }
  saveDatabase();
}

removeRecentOpen(String? path, String? fileName) {

  var recentOpenList = globalDatabase["projects"]["recentOpen"];
  String? keyToRemove;

  recentOpenList.forEach((key, value) {
    if (recentOpenList[key].toString() ==
        {"filePath": path, "fileName": fileName}.toString()) {
      keyToRemove = key;
      return;
    }
  });

  if (keyToRemove != null) {
    globalDatabase["projects"]["recentOpen"].remove(keyToRemove);
  }
  saveDatabase();
}

loadThemeFile(String? themePath) {
  if (themePath == "default"){
    // TODO: Add a default theme here
    globalTheme = jsonDecode(File("assets/themes/github_dark.json").readAsStringSync());
    return;
  }
  if (themePath == null){
    return;
  }
  globalTheme = jsonDecode(File("assets/themes/$themePath.json").readAsStringSync());
}

loadThemeFileReturn(String? themePath) {
  if (themePath == null){
    return;
  }
  return jsonDecode(File("assets/themes/$themePath.json").readAsStringSync());
}


loadMFlowFile(String? path) async {
  if (path == null){
    return;
  }
  var fileContent = await File(path).readAsString();
  if (fileContent.startsWith("mflow")){
    //if (fileContent.startsWith() == "0.1"){
      Map<String, dynamic> data =  jsonDecode(fileContent.substring(10));
      return data;
    //}
  }
}

Future<String?> saveMFlowFile({String content = "", String? path}) async {
    Map<String, dynamic> data ={
      "content" : content
    };
  if (path == null){
  var o = await FilePicker.platform.saveFile(dialogTitle: "Save Project", allowedExtensions: ["mflow", "md"], fileName: "project.mflow");
  //.then((path){
    if (o != null){
      if (o.endsWith(".mflow")){
      File(o).writeAsStringSync("mflow\n0.1\n${jsonEncode(data)}");
      } else {
        File(o).writeAsStringSync(content);
      }
      return o;
    } else {
      return null;
    }
  //});
  
  } else {
    if (path.endsWith(".mflow")){
      File(path).writeAsStringSync("mflow\n0.1\n${jsonEncode(data)}");
      } else {
        File(path).writeAsStringSync(content);
      }
  }
  return null;
}


List<List<String>> getMostRecentOpens(){
      List<String> filePaths = [];
      List<String> fileNames = [];
      var list = getDatabase()["projects"]["recentOpen"];
      list.forEach((key, value) {
        // maybe we should save the data as json too, rather then a list
        filePaths.add(list[key]["filePath"]);
        fileNames.add(list[key]["fileName"]);
      });
      return [fileNames, filePaths];
}


updateDropThemeEntries(){
  themeDropEntries.clear();
  themeDropEntries.add(const DropdownMenuEntry(value: "default", label: "Default"));
      Directory("assets/themes").listSync().forEach((entry){
      File data = File(entry.path);
      if (data.existsSync()){
      Map<String, dynamic> dataD =  jsonDecode(data.readAsStringSync());
      themeDropEntries.add(DropdownMenuEntry(value: dataD["themeFileName"], label: dataD["themeName"]));
      }
    });
}

List<DropdownMenuEntry<Object>> getDropThemeEntries(){
  return themeDropEntries;
}

getGlobalDatabase(){
  return globalDatabase;
}