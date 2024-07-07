

String addSidesToWord(String text, int start, String symbol){
  if (text.isEmpty){
    return "";
  }
  int start = 0;
  int index = start + 1;
  int end = text.length;
  bool findStart = false;
  bool findEnd = false;
  String split = "";
  for (int i=0; i < index; ++i){
    findStart = text.startsWith([' ','.','('] as Pattern, start-i);
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
    if (i == split.length){
      end = split.length;
      break;
    }
  }
  String newText = "*";
  newText += text.substring(start, start+end);
  newText += "*";
  if (start == 0 && (start+end) == text.length){
    return newText;
  } else {
  text.replaceRange(start, start+end, newText); // Bug: this doesn't replace everything if start == 0 and start+end == length
  return text;
  }
}