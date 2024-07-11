import 'dart:convert';
import 'dart:io';



Map<String, dynamic> globalDatabase = {};
Map<String, dynamic> globalTheme = {};

initDatabaseAndThemes(){

  if(File("user.json").existsSync()){
    globalDatabase = jsonDecode(File("user.json").readAsStringSync());
    loadThemeFile(globalDatabase["settings"]["lastTheme"]);
  } else {
    globalDatabase = newDatabase();
    loadThemeFile("assets/themes/github.json");
  }
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

loadThemeFile(String themePath) {
  globalTheme = jsonDecode(File("assets/themes/$themePath.json").readAsStringSync());
}