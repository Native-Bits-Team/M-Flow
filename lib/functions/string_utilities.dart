

String addSidesToWord(String text, int start, String symbol){
  int start = 0;
  int index = start + 1;
  int? end;
  bool findStart = false;
  bool findEnd = false;
  String split = "";
  for (int i=0; i < index; ++i){
    findStart = text.startsWith(' ', start-i);
    if (findStart){
      start = start-i+1; // +1 to remove the space itself
      break;
      }
  }
  split = text.substring(start);
  for (int i=2; i < split.length; ++i){
    findEnd = split.substring(0, i).endsWith(' ');
    if (findEnd){
      end = i-1; // -1 to remove the space itself
      break;
    }
  }
  if (end == null){
    end = split.length;
  }
  String newText = "*";
  newText += text.substring(start, start+end);
  newText += "*";
  text.replaceRange(start, start+end, newText);
  return text;
}