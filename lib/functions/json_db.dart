import 'dart:convert';
import 'dart:io';


void addRecentOpen(String? path, String? fileName) {
  Map<String, dynamic> jsonValues;
  File db = File("user.json");
  db.readAsString().then((jsonString) {
    jsonValues = jsonDecode(jsonString) as Map<String, dynamic>;
    var recentOpenList = jsonValues["projects"]["recentOpen"];
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
      jsonValues["projects"]["recentOpen"].remove(keyToRemove);
      jsonValues["projects"]["recentOpen"].addAll({
        lastKey.toString(): {"filePath": path, "fileName": fileName}
      });
    } else {
      jsonValues["projects"]["recentOpen"].addAll({
        lastKey.toString(): {"filePath": path, "fileName": fileName}
      });
    }
    String newValues = jsonEncode(jsonValues);
    File("user.json").openWrite(mode: FileMode.write).write(newValues);
  });
}

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