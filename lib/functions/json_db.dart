import 'dart:convert';
import 'dart:io';

// Json Directions are hardcoded
/*
void addNewValue(dynamic value){
  Map<String, dynamic> jsonValues;
  File db =File("user.json");
  db.readAsString().then((jsonString){
    jsonValues = jsonDecode(jsonString) as Map<String, dynamic>;
    jsonValues[subField].addAll({jsonValues[subField].length.toString(): value});
    print(jsonValues);
    String da = jsonEncode(jsonValues);
    print(da);
    File("test.json").openWrite(mode: FileMode.write).write(da);
 // File("test_temp.json").writeAsString(jsonEncode(jsonValues));
  });
}
*/
// 0
// 1
// 2
// 3

// 1
// 2
// 3
// 4

void addRecentOpen(String? path, String? fileName) {
  Map<String, dynamic> jsonValues;
  File db = File("user.json");
  db.readAsString().then((jsonString) {
    jsonValues = jsonDecode(jsonString) as Map<String, dynamic>;
    var recentOpenList = jsonValues["projects"]["recentOpen"];
    // if (jsonValues["projects"]["recentOpen"].length > 4){
    //jsonValues["projects"]["recentOpen"].remove("0");

    //jsonValues["projects"]["recentOpen"].forEach((key, value){
    //    jsonValues["projects"]["recentOpen"][] = value;
    //  });

    String? keyToRemove;
    int lastKey = 0;
    if (recentOpenList.keys.isNotEmpty) {
      lastKey = int.parse(recentOpenList.keys.last) + 1;
    }

    recentOpenList.forEach((key, value) {
      if (recentOpenList[key].toString() ==
          {"filePath": path, "fileName": fileName}.toString()) {
        // jsonValues["projects"]["recentOpen"].remove(key);
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
      jsonValues["projects"]["recentOpen"].remove(keyToRemove);
      jsonValues["projects"]["recentOpen"].addAll({
        lastKey.toString(): {"filePath": path, "fileName": fileName}
      });
    } else {
      jsonValues["projects"]["recentOpen"].addAll({
        lastKey.toString(): {"filePath": path, "fileName": fileName}
      });
    }
    //  jsonValues["projects"]["recentOpen"].addAll(jsonValues["projects"]["recentOpen"]);

    // }
    //.
    //print(jsonValues);
    String newValues = jsonEncode(jsonValues);
    //print(da);
    File("user.json").openWrite(mode: FileMode.write).write(newValues);
    // File("test_temp.json").writeAsString(jsonEncode(jsonValues));
  });
}

/*
removeRecentOpen(String? path, String? fileName){ // could result in bugs

  Map<String, dynamic> jsonValues;
  File db =File("user.json");
  db.readAsString().then((jsonString){
    jsonValues = jsonDecode(jsonString) as Map<String, dynamic>;
    var recentOpenList = jsonValues["projects"]["recentOpen"];
  String? keyToRemove;

  recentOpenList.forEach((key, value){
    if (recentOpenList[key].toString() == {"filePath": path, "fileName": fileName}.toString()){
       keyToRemove = key;
      return;
    }
  });

  if (keyToRemove != null){
     jsonValues["projects"]["recentOpen"].remove(keyToRemove);
  }
    String newValues = jsonEncode(jsonValues);
    File("user.json").openWrite(mode: FileMode.write).write(newValues);
  });

}


*/

removeRecentOpen(String? path, String? fileName) async {
  // could result in bugs

  Map<String, dynamic> jsonValues;
  File db = File("user.json");
  String jsonString = await db.readAsString();

  jsonValues = jsonDecode(jsonString) as Map<String, dynamic>;
  var recentOpenList = jsonValues["projects"]["recentOpen"];
  String? keyToRemove;

  recentOpenList.forEach((key, value) {
    if (recentOpenList[key].toString() ==
        {"filePath": path, "fileName": fileName}.toString()) {
      keyToRemove = key;
      return;
    }
  });

  if (keyToRemove != null) {
    jsonValues["projects"]["recentOpen"].remove(keyToRemove);
  }
  String newValues = jsonEncode(jsonValues);
  File("user.json").openWrite(mode: FileMode.write).write(newValues);
  return;
}

loadThemeFile(String themePath) async {
  Map<String, dynamic> jsonValues;
  File db = File(themePath);
  String jsonString = await db.readAsString();


  jsonValues = jsonDecode(jsonString) as Map<String, dynamic>;
  return jsonValues;
}

/*

"0": {
                "filePath" : "",
                "projectName" : "",
                "projectTheme" : "github"
            }

*/

/*
"0": {
                "filePath" : "",
                "fileName" : ""
            }
            */