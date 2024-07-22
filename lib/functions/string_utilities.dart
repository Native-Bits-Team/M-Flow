

String addSidesToWord(String text, int start, String symbol){
  if (text.isEmpty){
    return "";
  }
  int index = start + 1;
  bool findStart = false;
  bool findEnd = false;
  String split = "";
  for (int i=0; i < index; ++i){
    findStart = text.startsWith(RegExp("(,| )"), start-i); // Got the idea from the description of startsWith function and RegExp description // TODO: Should we use space for this?
    if (findStart){
      start = start-i+1; // +1 to remove the space itself
      break;
      }
    if (i == index-1){
      start = 0;
    }
  }
  split = text.substring(start);
  int end = split.length;

  for (int i=2; i < split.length; ++i){
    findEnd = endsWithOneOf([',',' '], split.substring(0, i));
    if (findEnd){
      end = i-1; // -1 to remove the space itself
      break;
    }
  }
  String newText = symbol;
  newText += text.substring(start, start+end);
  newText += symbol;
  if (start == 0 && (start+end) == text.length){
    return newText;
  } else {
  text = text.replaceRange(start, start+end, newText); // Bug: this doesn't replace everything if start == 0 and start+end == length
  return text;
  }
}


bool endsWithOneOf(List<String> l, String text){
  bool endValue = false;
  for (var value in l) {
    if (text.endsWith(value)){
      endValue = true;
      break;
    }
  }
  return endValue;
}