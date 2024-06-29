


import 'dart:convert';
import 'dart:io';

void addNewValue(String subField, dynamic value){
  Map<String, dynamic> jsonValues;
  File db =File("test.json");
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